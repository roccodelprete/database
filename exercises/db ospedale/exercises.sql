/* ************************************************ QUERY ********************************************* */
-- * visualizzare Il CF e il nome del medico che ha effettuato il numero massimo di interventi di tipo ‘LASER’ nella sala 2
select p.cf, p.nome
from
  persona p join medico m on m.cf = p.cf
	join effettua e on e.cf_med = m.cf
	join intervento i on i.id = e.id_int
where
	i.tipo = 'LASER'
	and i.sala_op = 'SALA DUE'
group by p.cf, p.nome
having count(*) = (
  select max(count(*))
  from
    persona p join medico m on m.cf = p.cf
    join effettua e on e.cf_med = m.cf
    join intervento i on i.id = e.id_int
  where
    i.tipo = 'LASER'
    and i.sala_op = 'SALA DUE'
  group by i.id
)


-- * visualizzare per ogni paziente ricoverato più di una volta il suo nome e cognome, più gli anni di esperienza dei medici che l'hanno operato
select p.nome, p.cognome, floor(avg(m.anni_esp)) as Anni_Esperienza
from persona p
join paziente pa on p.cf = pa.cf
join intervento i on pa.cf = i.cf_paz and pa.data_ric = i.data_ric
join effettua e on e.id_int = i.id
join medico m on m.cf = e.cf_med
group by pa.cf, p.nome, p.cognome
having count(*) > 1;

/*
 * Visualizzare tutti i tipi degli interventi a cui è assegnato almeno un infermiere con al più 5 anni di esperienza
 * e almeno un altro infermiere con 3 anni di esperienza
*/
select distinct i.tipo
from intervento i
join assiste a on i.id = a.id_int
join infermiere inf1 on inf1.cf = a.cf_inf
join infermiere inf2 on a.cf_inf <> inf1.cf and inf1.cf <> inf2.cf and a.cf_inf = inf2.cf
where (sysdate - inf1.data_ass) >= 5 and (sysdate - inf2.data_ass) >= 3
group by i.id, i.tipo
having count(*) > 1

-- * visualizzare le date degli interventi a cui non partecipa nessun infermiere con meno di 5 anni di esperienza
select i.data_e_ora
from 
    intervento i join assiste a on a.id_int = i.id
  join infermiere inf on inf.cf = a.cf_inf
where
    ((sysdate - data_ass) / 365) >= 5
group by i.data_e_ora, i.id
order by i.id

-- visualizzare per ogni tipo di intervento gli anni di esperienza medi dei medici che vi partecipano
select floor(avg(med.anni_esp)) as anni_esperienza, i.tipo
from medico med join effettua e on e.cf_med = med.cf join intervento i on i.id = e.id_int
group by i.tipo

/* 
  per ogni sala operatoria, visualizzare la data di ricovero dell'ultima persona che si è operata in quella sala
  e il numero complessivo di interventi in essa effettuati 
*/
select sala_op, count(*) as num_interventi, max(data_ric)
from intervento
group by sala_op

/* 
 * visualizzare la data di nascita e il sesso di tutte le persone
 * che hanno subito un intervento di durata superiore alle 2 ore nell'ultima settimana (si considera l'ora di sistema come riferimento)
*/
select p.data_nascita, p.sesso
from persona p join intervento i on i.cf_paz = p.cf
where data_e_ora > (sysdate - 7) and durata > 2

/* 
 * visualizzare per il paziente con CF 'AAA0000000000016' nome di tutti i medici che lo hanno operato
 * e il numero di volte che ciascuno di essi ha partecipato ad una sua operazione 
*/
select p.nome, count(*)
from medico med join persona p on p.cf = med.cf join effettua eff on eff.cf_med = med.cf join intervento inter on inter.id = eff.id_int
where inter.cf_paz = 'AAA0000000000016'
group by p.nome

/* 
 * visualizzare per ogni infermiere il suo nome, la sua data di assunzione
 * e il numero delle tipologie di intervento (si contano solo le tipologie distinte) a cui ha assistito 
*/
select p.nome, count(distinct inter.tipo) as tipologia, inf.data_ass
from persona p join infermiere inf on inf.cf = p.cf join assiste ass on ass.cf_inf = inf.cf join intervento inter on inter.id = ass.id_int
group by p.nome, inf.data_ass

-- * visualizzare per ogni medico il suo nome, la sua specializzazione e il numero di sale operatorie diverse in cui ha operato
select p.nome, med.specializzazione, count(distinct inter.sala_op)
from persona p join medico med on med.cf = p.cf join effettua eff on eff.cf_med = med.cf join intervento inter on inter.id = eff.id_int
group by p.nome, med.specializzazione
order by p.nome

-- * visualizzare per ogni medico il suo nome, la sua specializzazione e il numero delle tipologie di intervento(si contano solo le tipologie distinte) che ha effettuato
select p.nome, med.specializzazione, count(distinct i.tipo) as tipologia
from persona p join medico med on med.cf = p.cf join effettua e on e.cf_med = med.cf join intervento i on i.id = e.id_int
group by p.nome, med.specializzazione
order by p.nome

-- * visualizzare per ogni coppia medico/infermiere il numero di volte in cui hanno partecipato allo stesso intervento (il numero di volte in cui hanno lavorato assieme)
select cf_med, cf_inf, count(*) as num_partecipazione
from effettua e join assiste ass on ass.id_int = e.id_int
group by cf_med, cf_inf

-- * visualizzare i nomi e i cognomi dei medici che non hanno effettuato interventi nell'ultima settimana (si considera l'ora di sistema come riferimento)
select p.nome, p.cognome
from 
    persona p join medico m on m.cf = p.cf
where not exists (
    select *
    from effettua e join intervento i on i.id = e.id_int
    where data_e_ora > (to_date('11-may-2009', 'dd-mon-yyyy') - 7) and p.cf = e.cf_med
  )

-- * visualizzare i nomi e i cognomi degli infermieri che hanno assistito almeno due interventi nell'ultima settimana (si considera l'ora di sistema come riferimento)
select p.nome, p.cognome, count(*) as num_interventi
from 
  persona p join infermiere inf on p.cf = inf.cf
  join assiste ass on ass.cf_inf = inf.cf
  join intervento i on i.id = ass.id_int
where i.data_e_ora > to_date('11-may-2009', 'dd-mon-yyyy') - 7
group by p.cf, p.nome, p.cognome
having count(*) >= 2

-- * visualizzare la data di nascita di tutti i pazienti operati più di una volta in uno stesso ricovero
select p.data_nascita
from 
  persona p join paziente paz on p.cf = paz.cf
  join intervento i on i.cf_paz = paz.cf and i.data_ric = paz.data_ric
group by p.cf, p.data_nascita
having count(*) > 1

-- * visualizzare il CF, nome e cognome di tutti i medici che hanno almeno due colleghi dello stesso sesso con la stessa specializzazione..
select m1.cf, p1.nome, p1.cognome
from 
    medico m1 join medico m2 on m1.cf <> m2.cf
    join persona p1 on m1.cf = p1.cf
    join persona p2 on m2.cf = p2.cf
where m1.specializzazione = m2.specializzazione and p1.sesso = p2.sesso
group by m1.cf, p1.nome, p1.cognome
having count(*) >= 2

-- visualizzare per ogni specializzazione la durata media degli interventi effettuati dai medici con quella specializzazione e il numero di pazienti operati.
select floor(avg(i.durata)) as durata_media, count(*) as num_pazienti, m.specializzazione
from 
    medico m join effettua e on m.cf = e.cf_med
    join intervento i on i.id = e.id_int
group by m.specializzazione

/*
*	visualizzare per ogni tipo di intervento e per ogni coppia medico/infermiere il loro nome e cognome 
*	e il numero di volte in cui hanno partecipato allo stesso tipo di intervento 
*	(il numero di volte in cui hanno lavorato assieme nello stesso tipo di intervento)
*/
select 
    p1.nome as nome_medico, p1.cognome as cognome_medico, 
    p2.nome as nome_infermiere, p2.cognome as cognome_infermiere, 
    i.tipo, count(*) as num_collab
from 
    effettua e join assiste a on a.id_int = e.id_int
    join intervento i on i.id = e.id_int and i.id = a.id_int
    join persona p1 on p1.cf = e.cf_med
    join persona p2 on p2.cf = a.cf_inf
group by i.tipo, p1.cf, p2.cf, p1.nome, p1.cognome, p2.nome, p2.cognome
order by i.tipo

/*
*	visualizzare per ogni sala operatoria e per ogni tipo di intervento il numero di interventi di quel tipo eseguiti in quella sala nell'ultimo anno.
*/
select sala_op, tipo, count(*) as num_interventi
from intervento
where extract (year from data_e_ora) = extract (year from to_date('11-MAY-2009'))
group by sala_op, tipo

/*
*	visualizzare il nome e cognome di tutti i medici che hanno almeno un collega con la stessa specializzazione e gli stessi anni di esperienza.
*/
select p.nome, p.cognome
from 
    persona p join medico m1 on m1.cf = p.cf
    join medico m2 on m1.cf <> m2.cf
where
    m1.specializzazione = m2.specializzazione
    and m1.anni_esp = m2.anni_esp
group by p.cf, p.nome, p.cognome
having count(*) > 0

/*
*	visualizzare per il paziente con CF 'AAA0000000000016' il nome e cognome di tutti i medici che lo hanno operato 
*	e di tutti gli infermieri che hanno assistito negli ultimi otto mesi.
*/
select p.nome, p.cognome
from 
    intervento i join effettua e on e.id_int = i.id
    join assiste a on a.id_int = i.id
    join persona p on p.cf = e.cf_med or p.cf = a.cf_inf
where
    i.data_e_ora >= add_months(to_date('11-05-2009', 'dd-mm-yyyy'), -8)
    and i.data_e_ora <= to_date('11-05-2009', 'dd-mm-yyyy')
    and i.cf_paz = 'AAA0000000000016'
group by p.cf, p.nome, p.cognome

/*
*	visualizzare per ogni specializzazione il numero di medici con quella specializzazione e almeno cinque anni di esperienza 
*	che non effettua interventi da almeno sei mesi.
*/
select count(*) as numero_medici, m.specializzazione
from medico m join effettua e on e.cf_med = m.cf
where 
    not exists (
      select 1
      from effettua e join intervento i on i.id = e.id_int
      where data_e_ora < add_months(to_date('11-05-2009', 'dd-mm-yyyy'), -6)
  )
    and anni_esp >= 5
group by m.specializzazione

/*
*	visualizzare per ciascun medico nome e cognome e il numero totale di ore lavorate in sala operatoria nell'ultima settimana, escludendo il venerdì
*/
select p.nome, p.cognome, sum(i.durata) as ore_lavorate, i.sala_op
from 
    medico m join persona p on p.cf = m.cf
  join effettua e on e.cf_med = m.cf
  join intervento i on e.id_int = i.id
where
    i.data_e_ora >= to_date('11-05-2009', 'dd-mm-yyyy') - 7
    and i.data_e_ora <= to_date('11-05-2009', 'dd-mm-yyyy')
    and to_char(data_e_ora, 'DAY') <> 'FRIDAY'
group by p.cf, p.nome, p.cognome, i.sala_op

/*
*	visualizzare, per ogni intervento di tipo ‘LASER’ effettuato negli ultimi 3 mesi, il numero di
*	medici e di infermieri con più di 5 anni di esperienza che vi hanno partecipato.
*/
select count(*) as numero_infermieri_medici
from 
    medico m join effettua e on e.cf_med = m.cf
  join intervento i on i.id = e.id_int
    join assiste a on a.id_int = i.id
    join infermiere inf on inf.cf = a.cf_inf
where
  m.anni_esp > 5
    and a.id_int = e.id_int
  and floor((sysdate - inf.data_ass) / 365) > 5
  and i.tipo = 'LASER'
  and i.data_e_ora >= to_date('11-MAY-2009') - 120
  and i.data_e_ora <= to_date('11-MAY-2009')
group by i.id

/*
*	visualizzare l'elenco dei medici (CF, nome e cognome) che hanno effettuato almeno un volta
*	nell'ultimo anno uno dei tipi di intervento subiti dal paziente con CF 'AAA0000000000016'
*/
select m.cf, p.nome, p.cognome
from
    persona p join medico m on p.cf = m.cf
    join effettua e on e.cf_med = m.cf
    join intervento i on i.id = e.id_int
where
  i.data_e_ora >= to_date('11-MAY-2009') - 365
  and i.data_e_ora <= to_date('11-MAY-2009')
    and i.cf_paz = 'AAA0000000000016'

/*
*	visualizzare per ogni paziente operato più di una volta in una settimana, il suo nome e cognome
*	più il numero e gli anni di esperienza medi dei medici che l'hanno operato
*/
select 
  p.nome, p.cognome, 
  floor(avg(m.anni_esp)) as anni_esperienza_medi, 
  count(e.cf_med) as numero_medici
from
  persona p join paziente paz on p.cf = paz.cf
  join intervento i on i.cf_paz = paz.cf and i.data_ric = paz.data_ric
  join effettua e on e.id_int = i.id
  join medico m on m.cf = e.cf_med
where 
  i.data_e_ora >= (
    select max(data_e_ora) - 7
    from intervento
    where cf_paz = paz.cf and data_ric = paz.data_ric
  )
  and i.data_e_ora <= (
    select max(data_e_ora)
    from intervento
    where cf_paz = paz.cf and data_ric = paz.data_ric
  )
group by p.cf, p.nome, p.cognome
having count(*) > 1

-- * visualizzare nome, cognome e data di nascita di tutti i pazienti che hanno subito due volte di seguito lo stesso tipo di intervento
select distinct p.nome, p.cognome, p.data_nascita
from 
  persona p join paziente paz on paz.cf = p.cf 
  join intervento i on i.cf_paz = paz.cf
  join intervento i2 on i2.cf_paz = paz.cf and i2.data_ric = paz.data_ric
where 
  i.data_e_ora < i2.data_e_ora 
  and i.tipo = i2.tipo

-- * visualizzare le qualifiche distinte degli infermieri che hanno lavorato per più di 30 ore nell'ultima settimana, escludendo il sabato
select inf.qualifica
from 
  infermiere inf join assiste ass on inf.cf = ass.cf_inf
	join intervento i on i.id = ass.id_int
where 
  i.data_e_ora >= to_date('11-MAY-2009') - 7
	and i.data_e_ora <= to_date('11-MAY-2009')
	and to_char(to_date(i.data_e_ora), 'DAY') <> 'SATURDAY'
group by inf.cf, inf.qualifica
having sum(i.durata) > 30

-- * visualizzare per ogni medico il suo nome, la sua specializzazione e il numero di pazienti minorenni che ha operato negli ultimi sei mesi
select p.nome, m.specializzazione, count(i.cf_paz) as numero_pazienti_minorenni
from 
	persona p join medico m on m.cf = p.cf
  join effettua e on e.cf_med = m.cf
  join intervento i on i.id = e.id_int
	join paziente paz on paz.cf = i.cf_paz
  join persona p2 on p2.cf = paz.cf
where 
  floor((sysdate - p2.data_nascita) / 365) < 18
  and i.data_e_ora >= to_date('20-MAY-2009') - 180
  and i.data_e_ora <= to_date('20-MAY-2009')
group by p.cf, p.nome, m.specializzazione

/*
 * visualizzare il CF e il nome degli infermieri che hanno partecipato soltanto ad interventi di tipo
 * ‘CHIRURGIA GENERALE’ effettuati nella sala 1
*/
select p.cf, p.nome, p.cognome 
from
  persona p join infermiere inf on p.cf = inf.cf
  join assiste a on inf.cf = a.cf_inf
  join intervento i on a.id_int = i.id
where
  i.tipo = 'CHIRURGIA GENERALE'
  and i.sala_op = 'SALA UNO'
  and not exists (
    select *
    from assiste a2 join intervento i2 on a2.id_int = i2.id
    where 
      (i2.tipo <> 'CHIRURGIA GENERALE' or i2.sala_op <> 'SALA UNO')
      and a.cf_inf = a2.cf_inf
  )

/* ************************************************ TRIGGER ********************************************* */
/* 
*  Un medico opera sempre nella stessa sala; se ha più di 10 anni di esperienza oppure ha più di 55 anni d'età, 
*  allora non opera di sabato e non fa interventi di tipo ‘LASER’.
*  Eccezioni: wrong_room, pause_day, wrong_type.
*/
create or replace trigger t3
before insert on effettua
for each row
declare
  wrong_room exception; 
  pause_day exception;
  wrong_type exception; 
  num_op number;
  room intervento.sala_op%type;
  new_room intervento.sala_op%type;
  anni number;
  eta number;
  data_int date;
  giorno varchar(15);
  tipo_int intervento.tipo%type;

begin
  select count(*) into num_op from effettua  where cf_med = :new.cf_med;

  if (num_op <> 0) then

    select i.sala_op into room from effettua e join intervento i on e.id_int = i.id where i.data_e_ora = (
        select max(data_e_ora) from intervento where data_e_ora < (
            select data_e_ora from intervento where id = :new.id_int
          )
        group by data_e_ora
      ) and e.cf_med = :new.cf_med;

    select sala_op into new_room from intervento where id = :new.id_int;

    if(new_room <> room) then
      raise wrong_room;
    end if;
  end if;

  select anni_esp into anni from medico where cf = :new.cf_med;
  select floor((sysdate - data_nascita) / 365) into eta from persona where cf = :new.cf_med;

  if(anni > 10 OR eta > 55) then
    select data_e_ora into data_int from intervento where id = :new.id_int;

    select to_char(data_int , 'DAY') into giorno from dual;

    if(giorno = 'SATURDAY') then
      raise pause_day;
    end if;

    select tipo into tipo_int from intervento where id = :new.id_int;

    if(tipo_int = 'LASER') then
        raise wrong_type;
    end if;
  end if;

  exception
    when wrong_room then
      raise_application_error(-20001,'Il medico non può operare in questa sala');

    when pause_day then
      raise_application_error(-20002,'Il medico non può operare di sabato');

    when wrong_type then
      raise_application_error(-20003,'Il medico non può operare questo tipo di intervento');

end;

/*
*	Un infermiere con meno di 5 anni di esperienza non può assistere ad interventi di tipo “ONCOLOGICO” e non può assistere a più di tre interventi consecutivi..
*	Se uno tra questi interventi dura più di tre ore, allora gli interventi massimi nello stesso giorno scendono a due. 
*/
create or replace trigger t1
before insert on assiste
for each row
declare
  wrong_experience exception;
  experience number;
  surger_type intervento.tipo%type;
  num_interventi number;
  surger_duration intervento.durata%type;

begin
  select floor((sysdate - data_ass) / 365) into experience
  from infermiere
  where cf = :NEW.cf_inf;

  if (experience < 5) then
    select tipo into surger_type
    from intervento
    where id = :NEW.id_int;

    if (surger_type = 'ONCOLOGICO') then
      raise wrong_experience;
    end if;

    select max(intervento.durata), count(*) into surger_duration, num_interventi
    from intervento join assiste on :NEW.id_int = intervento.id
    where 
      assiste.cf_inf = :NEW.cf_inf
      and intervento.data_e_ora >= (
        select max(data_e_ora)
        from intervento
        where id = :NEW.id_int
      )
    group by assiste.cf_inf;

    if (num_interventi > 2) then
        raise wrong_experience;
    end if;

    if (surger_duration > 2 and num_interventi > 1) then
      raise wrong_experience;
    end if;
  end if;

exception
    when wrong_experience then
      raise_application_error(-20001, 'Infermiere inesperto');
    
end;

/*
*	Un medico può partecipare al massimo a 10 interventi in una settimana e di al più tre tipi diversi.
*	In ogni intervento almeno due medici devono avere la stessa specializzazione..
*/
create or replace trigger t2
before insert on effettua
for each row
declare
  maxSurgeries exception;
  maxSurgerTypes exception;
  sameSpec exception;
  numSurgeries number;
  numTypes number;
  numSpec number;

begin
  select count(*) into numSurgeries
  from intervento i join effettua e on e.id_int = i.id
  where 
    e.cf_med = :NEW.cf_med
    and i.data_e_ora >= sysdate - 7
    and i.data_e_ora <= sysdate
  group by i.id;

  select count(distinct i.tipo) into numTypes
  from intervento i join effettua e on e.id_int = i.id
  where 
    e.cf_med = :NEW.cf_med
    and i.data_e_ora >= sysdate - 7
    and i.data_e_ora <= sysdate
  group by i.tipo;

  if (numSurgeries > 9) then
    raise maxSurgeries;
  end if;

  if (numTypes > 2) then
    raise maxSurgerTypes;
  end if;

  select count(*) into numSpec
  from 
        medico m1 join medico m2 on m1.cf <> m2.cf
        join effettua e on m2.cf = e.cf_med
        join intervento i on i.id = :NEW.id_int
  where
    m1.specializzazione = m2.specializzazione
    and m1.cf = :NEW.cf_med
  group by i.id, m1.specializzazione;

  if (numSpec < 1) then
    raise sameSpec;
  end if;

  exception
        when maxSurgeries then
          raise_application_error(-200001, 'Numero massimo di interventi raggiunto');

        when maxSurgerTypes then
          raise_application_error(-200002, 'Numero massimo di tipi di intervento raggiunto');

        when sameSpec then
          raise_application_error(-200003, 'Almeno due medici devono avere la stessa specializzazione');

end;

/*
*	Un paziente non può subire più di due interventi in uno stesso ricovero. 
*	Questi devono avvenire a distanza di non più di una settimana uno dall'altro e non possono essere dello stesso tipo.
*/
create or replace trigger t4
before insert on intervento
for each row
declare
  maxSurgeries exception;
  sameType exception;
  longPeriod exception;
  lastDataRic intervento.data_ric%type;
  lastDataSurgery intervento.data_e_ora%type;
  surgerType intervento.tipo%type;

begin
  select max(data_ric) into lastDataRic
  from intervento
  where cf_paz = :NEW.cf_paz;

  if (lastDataRic = :NEW.data_ric) then
    raise maxSurgeries;
  end if;

  select max(data_e_ora) into lastDataSurgery
    from intervento
    where cf_paz = :NEW.cf_paz;

  if (:NEW.data_e_ora <= lastDataSurgery + 7) then
    raise longPeriod;
  end if;

  select tipo into surgerType
    from intervento
    where 
      cf_paz = :NEW.cf_paz
      and data_e_ora = lastDataSurgery;

  if (surgerType = :NEW.tipo) then
    raise sameType;
  end if;

  exception
    when maxSurgeries then
      raise_application_error(-200001, 'Numero massimo di interventi nello stesso ricorvero raggiunto');

    when longPeriod then
      raise_application_error(-200002, 'Periodo tra un intervento e l''altro troppo lungo');
    
    when sameType then
      raise_application_error(-200003, 'Gli interventi non possono essere dello stesso tipo');
end;

/*
*	Un infermiere può partecipare al massimo a quattro interventi in un giorno e solo se questi avvengono nella stessa sala operatoria. 
*	In ogni intervento sono coinvolti al massimo cinque infermeri, tutti assunti da almeno due anni.
*/

create or replace trigger t6
before insert on assiste
for each row
	declare
		numSurgeries number;
		maxSurgeries exception;
		numNurses number;
		maxNurses exception;
		hiredAge number;
		unexperiencedNurse exception;
    
	begin
		select count(*) into numSurgeries
    from intervento i join assiste a on a.id_int = i.id
    where 
      trunc(i.data_e_ora) in (
        select trunc(data_e_ora)
        from intervento
        where id = :NEW.id_int
      )
      and i.sala_op in (
        select sala_op
        from intervento
        where id = :NEW.id_int
        )
      and a.cf_inf = :NEW.cf_inf
    group by i.id;

        if (numSurgeries > 3) then
          raise maxSurgeries;
        end if;

		select count(*) into numNurses
    from intervento i join assiste a on a.id_int = i.id
    where 
        i.id = :NEW.id_int
        and a.cf_inf = :NEW.cf_inf;

		if (numNurses > 4) then
      raise maxNurses;
		end if;

		select floor((trunc(i.data_e_ora) - inf.data_ass) / 365) into hiredAge
    from 
      infermiere inf join assiste a on a.cf_inf = inf.cf
      join intervento i on i.id = a.id_int
    where 
      a.cf_inf = :NEW.cf_inf
      and a.id_int = :NEW.id_int;

		if (hiredAge < 2) then
      raise unexperiencedNurse;
    end if;

		exception
      when maxSurgeries then
        raise_application_error(-20001, 'Numero massimo di interventi raggiunto nella stessa sala');

      when maxNurses then
        raise_application_error(-20002, 'Numero massimo di infermieri raggiunto');

      when unexperiencedNurse then
        raise_application_error(-20003, 'Infermiere inesperto');
	end;

/*
*	In una sala operatoria non si possono effettuare più di cinque interventi nello stesso giorno e devono essere tutti dello stesso tipo.
*	La durata degli interventi per i pazienti di età superiore a 75 anni non può essere superiore a tre ore.
*/
create or replace trigger t10
before insert on intervento
for each row
declare
  numSurgeries number;
  patientAge number;
  surgerType intervento.tipo%type;
  differentSurgerTypes exception;
  maxSurgeries exception;
  wrongSurgery exception;
  
begin
  select count(*) into numSurgeries
  from intervento
  where 
    trunc(data_e_ora) = trunc(:NEW.data_e_ora)
    and sala_op = :NEW.sala_op;

  if (numSurgeries <> 0) then
    select tipo into surgerType
    from intervento
    where 
      data_e_ora = (
        select max(data_e_ora)
        from intervento
        where 
          trunc(data_e_ora) = trunc(:NEW.data_e_ora)
          and sala_op = :NEW.sala_op
      )
      and sala_op = :NEW.sala_op;

    if (:NEW.tipo <> surgerType) then
      raise differentSurgerTypes;
    end if;
  end if;

  if (numSurgeries > 4) then 
    raise maxSurgeries;
  end if;

  select floor((sysdate - p.data_nascita) / 365) into patientAge
  from persona p join paziente paz on p.cf = paz.cf
  where 
    paz.cf = :NEW.cf_paz 
    and paz.data_ric = :NEW.data_ric;

  if (patientAge > 75 and :NEW.durata > 3) then
    raise wrongSurgery;
  end if;
  
  exception
    when differentSurgerTypes then
      raise_application_error(-20001, 'Gli interventi non sono dello stesso tipo');

    when maxSurgeries then
      raise_application_error(-20002, 'Numero massimo di interventi raggiunti');

    when worngSurgery then
      raise_application_error(-20003, 'I pazienti con età superiore a 75 anni non possono subire interventi maggiori di 3 ore');
end;

/*
*	Un medico può partecipare ad un intervento solo se sono già stati assegnati due infermieri a quell'intervento;
*	degli infermieri assegnati, almeno uno deve avere più anni di esperienza di lui;
*	un medico non effettua più di 10 interventi in una settimana.
*/
create or replace trigger t6
before insert on effettua
for each row
	declare
		no_nurse exception;
		unexperienced_nurse exception;
		doctor_overloaded exception;
		assistantExp number;
		doctExp number;
		numSurgeries number;
		numAssistants number;

	begin
		select count(*) into numAssistants
		from assiste
		where id_int = :NEW.id_int;

		if (numAssistants < 2) then
      raise no_nurse;
		end if;

		select floor((sysdate - min(inf.data_ass)) / 365) into assistantExp
		from infermiere inf join assiste a on a.cf_inf = inf.cf
		where a.id_int = :NEW.id_int;

		select anni_esp into doctExp
		from medico
		where cf = :NEW.cf_med;

		if (assistantExp <= doctExp) then
			raise unexperienced_nurse;
		end if;

		select count(*) into numSurgeries
		from intervento i join effettua e on i.id = :NEW.id_int
		where
			i.data_e_ora >= sysdate - 7
			and i.data_e_ora <= sysdate;

		if (numSurgeries > 9) then
			raise doctor_overloaded;
		end if;

    exception
        when unexperienced_nurse then
          raise_application_error(-20001, 'Infermiere inesperto');

        when no_nurse then
          raise_application_error(-20002, 'Non vi sono abbastanza infermieri assegnati a questo intervento');

        when doctor_overloaded then
          raise_application_error(-20002, 'Non possono essere eseguiti più di 10 interventi in una settimana');
	end;

/*
*	Gli infermieri sono tenuti a rispettare una rotazione dei turni rispetto alle sale operatorie:
*	un infermiere non assiste mai due interventi consecutivi nella stessa sala; 
*	Il giorno dopo il decimo intervento assistito, l'infermiere ha diritto ad una pausa; 
*	per assistere ad un intervento l'infermiere deve avere almeno due anni di esperienza.
*/

create or replace trigger t7
before insert on assiste
for each row
	declare
		incorrect_schedule exception;
		pause_day exception;
		unexperienced_nurse exception;
		lastSurgerDate intervento.data_e_ora%type;
		surgerRoom intervento.sala_op%type;
		numSurgeries number;
		numSurgeriesAssistant number;
		assistantExp number;

	begin
		select i.data_e_ora, i.sala_op into lastSurgerDate, surgerRoom
    from intervento i join assiste a on i.id = :NEW.id_int;

    select count(*) into numSurgeries
    from intervento i join assiste a on i.id = a.id_int
    where 
      i.data_e_ora = lastSurgerDate 
      and a.cf_inf = :NEW.cf_inf
      and i.sala_op = surgerRoom;

    if (numSurgeries > 0) then
      raise incorrect_schedule;
		end if;

		select count(*) into numSurgeriesAssistant
    from intervento i join assiste a on a.id_int = i.id
    where
      a.cf_inf = :NEW.cf_inf
      and i.data_e_ora = lastSurgerDate - 1;

		if (numSurgeriesAssistant > 9) then
      raise pause_day;
		end if;

		select floor((sysdate - data_ass) / 365) into assistantExp
    from infermiere
    where cf = :NEW.cf_inf;

    if (assistantExp < 2) then
      raise unexperienced_nurse;
		end if;
        
    exception
			when incorrect_schedule then
        raise_application_error(-20001, 'Infermiere già presente in questa sala');

			when pause_day then
        raise_application_error(-20002, 'Infermiere in pausa');

			when unexperienced_nurse then
        raise_application_error(-20003, 'Infermiere inesperto');
	end;
