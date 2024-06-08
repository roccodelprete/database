/* ********************************************* QUERY *********************************************** */
/*
*   Per ogni utente, trovare il suo login, il suo nome e il numero di aste non concluse con una vendita in cui ha partecipato
*/
select r.login, u.nome, count(*)
from
    rilanciata r join utente u on u.login = r.login
    join asta a on a.id_asta = r.id_asta
where not exists (
    select a.id_asta
    from asta a join vendita v on a.id_asta = v.id_asta
    where a.id_asta = r.id_asta
)
group by u.nome, r.login

-- Trovare il nome e il CF di tutti gli utenti che hanno effettuato più di due acquisti
/*
    ! problema con il codice fiscale
*/
select u.nome, v.cf
from 
    utente u join rilanciata r on u.login = r.login
  join asta a on a.id_asta = r.id_asta
  join vendita v on v.id_asta = a.id_asta
group by u.login, u.nome, v.cf
having count(*) > 2

/*
*	Trovare il login e il nome di tutti gli utenti che hanno rilanciato almeno tre volte 
*	su almeno un oggetto proveniente dal ‘LOUVRE’
*/
select u.nome, u.login
from 
    utente u join rilanciata r on u.login = r.login
  join asta a on a.id_asta = r.id_asta
    join oggetto o on a.codice_oggetto = o.codice_oggetto
where o.provenienza = 'LOUVRE'
group by u.login, u.nome, r.id_asta
having count(*) >= 3

/*
*	Trovare il login e il nome di tutti gli utenti che hanno rilanciato più di due volte, 
*	in aste diverse, su un oggetto proveniente dal ‘LOUVRE’
*/
select u.nome, u.login
from 
    utente u join rilanciata r on u.login = r.login
  join asta a on a.id_asta = r.id_asta
    join oggetto o on a.codice_oggetto = o.codice_oggetto
where o.provenienza = 'LOUVRE'
group by u.login, u.nome
having count(*) > 2

/*
*	Trovare il codice e la provenienza di tutti gli oggetti venduti 
*	che sono stati all'asta più di due volte nel mese di dicembre (di qualsiasi anno)
*/
select o.codice_oggetto, o.provenienza
from  
    asta a join oggetto o on a.codice_oggetto = o.codice_oggetto
    join vendita v on v.id_asta = a.id_asta
where extract(month from a.data_inizio) = 12
group by o.codice_oggetto, o.provenienza
having count(*) > 2

/* ********************************************* QUERY *********************************************** */
/*
*	La durata di un'asta non può essere inferiore a tre giorni. 
*	In un mese un oggetto non può essere messo all'asta più di tre volte. 
*	Il rilancio minimo dev'essere almeno il 10% del prezzo base. 
*	Eccezioni: rilancio minimo troppo basso, asta troppo breve, oggetto troppe volte in vendita
*/
create or replace trigger t1
before insert on asta
for each row
declare
    low_min_raise exception;
    low_auction_duration exception;
    many_object_sold exception;
    count_object_in_auction number;

begin
    if (floor(:NEW.data_fine - :NEW.data_inizio) < 3) then
        raise low_auction_duration;
    end if;

    select count(*) into count_object_in_auction
    from asta
    where 
        data_inizio > (:NEW.data_inizio - 30)
        and codice_oggetto = :NEW.codice_oggetto

    if (count_object_in_auction > 2) then
        raise many_object_sold;
    end if;

    if (:NEW.rilancio_min < (:NEW.prezzo_base + ((:NEW.prezzo_base * 10) / 100))) then
        raise low_min_raise;
    end if;

exception
    when low_auction_duration then
        raise_application_error(-20001, 'Durata dell''asta troppo breve');

    when many_object_sold then
        raise_application_error(-20002, 'Oggetto all''asta già presente tre volte');

    when low_min_raise then
        raise_application_error(-20003, 'Il rilancio minimo deve essere almeno il 10% del prezzo base');
end;

/*
*	Un oggetto non può essere rimesso all'asta se è stato già venduto 
*	oppure se non è passata più di una settimana dall'ultima volta 
*	che è stato messo all’asta rimanendo invenduto. 
*	Gli oggetti di provenienza 'LOUVRE' non possono andare all'asta.
*	Eccezioni: oggetto già venduto, periodo trascorso dall’ultima asta troppo breve, 
*	oggetto non valido.
*/
create or replace trigger t2
before insert on asta
for each row
declare
    objectSold exception;
    lowPeriodPassed exception;
    invalidObject exception;
    numSoldObjects number;
    lastAuctionDate asta.data_inizio%type;
    provenience oggetto.provenienza%type;

begin
    select count(*) into numSoldObjects
    from asta a join vendita v on a.id_asta = v.id_asta
    where a.codice_oggetto = :NEW.codice_oggetto;

    if (numSoldObjects <> 0) then
        raise objectSold;
    end if;

    select max(data_inizio) into lastAuctionDate
    from asta
    where codice_oggetto = :NEW.codice_oggetto;

    if (:NEW.data_inizio < (lastAuctionDate + 7)) then
        raise lowPeriodPassed;
    end if;

    select o.provenienza into provenience
    from asta a join oggetto o on a.codice_oggetto = o.codice_oggetto
    where a.codice_oggetto = :NEW.codice_oggetto;

    if (provenience = 'LOUVRE') then
        raise invalidObject;
    end if;
    
    exception
        when objectSold then
            raise_application_error(-20001, 'Oggetto già venduto');

        when lowPeriodPassed then
            raise_application_error(-20002, 'Questo oggetto può essere rimesso all''asta solo se trascorre almeno una settimana');

        when invalidObject then
            raise_application_error(-20002, 'Gli oggetti con provenienza <LOUVRE> non possono andare all''asta');
end;