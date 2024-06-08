/* DATABASE STUDENTE */
-- tabella studente
create table Studente ( 
  matricola 				char(10) 		PRIMARY KEY, 
    nome 					varchar(20) 	NOT NULL, 
    codiceFiscale 			char(16) 		UNIQUE NOT NULL, 
    sesso 					char(1) 		CHECK(sesso IN ('M', 'm', 'F', 'f', 'n')), 
    dataNascita				date, 
    codiceCorsoDiLaurea		char(4), 
    constraint fk_CDL foreign key (codiceCorsoDiLaurea) references CorsoDiLaurea(codiceCorsoDiLaurea) 
)

-- tabella corso di laurea
create table CorsoDiLaurea (
    nomeCorsoDiLaurea 		varchar(50)		NOT NULL,
    codiceCorsoDiLaurea		char(4)			PRIMARY KEY,
  durataCorsoDiLaurea		varchar(30)		CHECK(durataCorsoDiLaurea IN ('2 anni', '3 anni', '4 anni', '5 anni')),
    tipoCorsoDiLaurea		varchar(30)		CHECK(tipoCorsoDiLaurea IN ('Triennale', 'triennale', 'Magistrale', 'magistrale', 'Ciclo Unico', 'ciclo unico'))
)

-- tabella esami superati
create table EsamiSuperati (
  numVerbale 				varchar(20) 	PRIMARY KEY,
    dataEsame 				date		 	NOT NULL,
    votoEsame				number(2,0) 	CHECK(votoEsame >= 18 AND votoEsame <= 30) NOT NULL,
    lodeEsame 				BOOLEAN			NOT NULL,
    nomeEsame				varchar(30)		NOT NULL,
    nomeDocenteEsame		varchar(30)		NOT NULL,
    codiceCorsoDiLaurea		char(4),
    candidato				varchar(10)		NOT NULL,
    constraint fk_Studente foreign key (candidato) references Studente(matricola)
)

-- tabella esami
create table Esami (
    nomeDocente 			varchar(20) 	NOT NULL,
    annoDiCorso		        number(1,0)		NOT NULL,
    cfu             		number(2,0),
    nomeEsame				varchar(10)		PRIMARY KEY,
    constraint fk_esameSuperato foreign key (nomeEsame) references EsamiSuperati(nomeEsame)
)

INSERT INTO Studente VALUES ('2592', 'Rocco', 'DLPRCC02D20F839C', 'M', '20-apr-02', '0124')

INSERT INTO Studente VALUES ('2592', 'Rocco', 'DLPRCC02D20F839C', 'M', '20-apr-02', '0124')

-- matricola e nome di studenti che hanno superato almeno un esame del secondo anno
SELECT s.matricola, s.nome
FROM (Studente S join EsamiSuperati E on s.matricola = e.candidato) join Esami on Esami.nomeEsame = EsamiSuperati.nomeEsame
WHERE annoDiCorso = 2

-- matricola e nome di studenti che hanno superato almeno un esame
SELECT s.matricola, s.nome
FROM (Studente S join EsamiSuperati E on s.matricola = e.candidato)

-- matricola e nome di studenti che non hanno superato almeno un esame
SELECT s.matricola, s.nome
FROM (Studente S left outer join EsamiSuperati E)
/* possiamo riscriverla come: */
(SELECT s.matricola, s.nome
FROM (Studente S left outer join EsamiSuperati E)
minus
SELECT s.matricola, s.nome
FROM (Studente S join EsamiSuperati E))

-- matricola e nome di studenti che hanno superato almeno un esame del primo anno e almeno un esame del secondo anno
SELECT s.nome, s.mat
FROM (Studente s join EsamiSuperati e on s.matricola = e.candidato) join Esami on Esami.nomeEsame = e.nomeEsame
WHERE annoDiCorso = 1 intersect 
    SELECT s.nome, s.mat
    FROM (Studente s join EsamiSuperati e on s.matricola = e.candidato) join Esami on Esami.nomeEsame = e.nomeEsame
    WHERE annoDiCorso = 2

-- nome e cognome di tutti gli studenti che hanno un perfetto coetaneo (stessa data di nascita)
select *
from Studente S1
where exists (
    select dataNascita
    from Studente S2
    where S1.matricola <> S2.matricola and S1.dataNascita = S2.dataNascita
)

-- trovare gli studenti che hanno superato gli stessi esami di Mario Rossi (123)
select distinct matricola
from EsamiSuperati E1
where not exists (
    select *
    from EsamiSuperati E2
    where matricola = '123' and not exists (
        select *
        from EsamiSuperati E3
        where E3.matricola <> E1.matricola and E2.nomeEsame <> E3.nomeEsame
    )
)

/* DATABASE AZIENDA */
-- nome e cognome degli impiegati che lavorano almeno su un progetto con sede Napoli
select impiegato.nome, impiegato.cognome
from ((impiegato join lavora_su on impiegato.cf = lavora_su.cf_impiegato) join progetto on progetto.numero_progetto = lavora_su.numero_progetto)
where progetto.sede_progetto = 'NAPOLI'

-- nome e cognome degli impiegati che hanno almeno due figli a carico
select impiegato.cf, impiegato.nome, impiegato.cognome
from impiegato join familiare_a_carico fam on impiegato.cf = fam.cf_impiegato
where relazione_parentela = 'FIGLIO'
intersect
select impiegato.cf, impiegato.nome, impiegato.cognome
from impiegato join familiare_a_carico fam on impiegato.cf = fam.cf_impiegato
where relazione_parentela = 'FIGLIA'

-- nome e cognome degli impiegati che hanno almeno due figli a carico
select impiegato.cf, impiegato.nome, impiegato.cognome
from (impiegato join familiare_a_carico fam on impiegato.cf = fam.cf_impiegato)
    join familiare_a_carico fac on impiegato.cf = fac.cf_impiegato and fam.cf_impiegato <> fac.cf_impiegato 
where (fam.relazione_parentela = 'FIGLIO' or fam.relazione_parentela = 'FIGLIA') and (fac.relazione_parentela = 'FIGLIO' or fac.relazione_parentela = 'FIGLIA')

-- nomi dei supervisori che lavorano in un dipartimento con sede a Napoli
select distinct impiegato.nome, impiegato.cognome
from ((impiegato join impiegato imp on impiegato.cf = imp.cf_supervisore) join dipartimento on impiegato.numero_dipartimento = dipartimento.numero_dipartimento)
    join sede_dipartimento on dipartimento.numero_dipartimento = sede_dipartimento.numero_dipartimento
where sede_dipartimento.citta_sede = 'NAPOLI'

-- gerarchia impiegati di ogni livello
select *
from impiegato
connect by prior cf = cf_supervisore
start with cf_supervisore is null

select *
from impiegato
connect by prior cf = cf_supervisore
start with cf_supervisore = '111'

-- print nome dell'impiegato più anziano
declare
  nomeImpiegato	impiegato.nome%type;

begin
    select nome into nomeImpiegato
    from impiegato
    where data_nascita = (select min(data_nascita) from impiegato);
    
  dbms_output.put_line(nomeImpiegato);
end;

-- print nome impiegato più anziano, con controllo se vi sono troppi anziani
declare
  nomeImpiegato	impiegato.nome%type;
  numAnziani		number(2,0);
    troppiAnziani	exception;
  
begin
    select count(*) into numAnziani
    from impiegato
    where data_nascita = (select min(data_nascita) from impiegato);

  if (numAnziani > 1) then
        raise troppiAnziani;
  end if;

  select nome into nomeImpiegato
    from impiegato
    where data_nascita = (select min(data_nascita) from impiegato);
    
  dbms_output.put_line(nomeImpiegato);

exception
  when troppiAnziani then
    raise_application_error(-20001, 'troppi anziani');
end;

-- scrivere un blocco anonimo che sostituisca il direttore del dipartimento numero 50 con l'impiegato più giovane di quel dipartimento con gestione dell'eccezione no_data_found
declare
  director		impiegato.cf%type;

begin
  select cf into director
  from impiegato
  where numero_dipartimento = 50 and data_nascita = (
      select max(data_nascita)
      from impiegato
      where numero_dipartimento = 50
    );

  update dipartimento
  set    cf_direttore = director
  where  numero_dipartimento = 50;

exception
    when no_data_found then
      dbms_output.put_line('dipartimento non esistente');
end;

-- scrivere un blocco anonimo che licenzi (cancelli) in ogni dipartimento l'impiegato che lavora di meno (meno ore lavorate)
declare
  workHours		lavora_su.ore%type;
  employee		impiegato.cf;

begin
    select min(ore), numero_dipartimento
    from impiegato imp join (
      select cf_impiegato, sum(ore)
      from lavora_su
      group by cf
    ) t on t.cf_impiegato = imp.cf
    group by imp.numero_dipartimento
end;

/* da continuare */

-- scrivere un blocco anonimo che promuova come direttore in ogni dipartimento l'impiegato che lavora di meno

-- un direttore di dipartimento deve avere almeno 30 anni
create or replace trigger nDir
before insert or update on dipartimento
for each row
    declare
        etaNuovoDirettore       number(2,0)
        direttoreInesperto      exception

    begin
        select (sysdate - data_nascita) / 365 into etaNuovoDirettore
        from impiegato
        where :NEW.cf_direttore = cf

        if etaNuovoDirettore < 30 then
            raise direttoreInesperto;          
        end if;

    exception
        when direttoreInesperto then
            raise_application_error(-20001, 'Direttore inesperto');

        when no_data_found then
            dbms_output.put_line('codice fiscale inesistente');

    end;

-- no bigamia: un impiegato può avere una sola moglie come familiare a carico o un solo marito
create or replace trigger noBigamia
before insert or update on familiare_a_carico
for each row
    declare
        sposi number(10);

    begin
        if :NEW.relazione_parentela = 'moglie' then
            select count(*) into sposi
            from familiare_a_carico
            where :NEW.cf_impiegato = cf_impiegato and relazione_parentela in ('MOGLIE','MARITO');
        end if;

        if sposi > 1 then
            raise_application_error(-20001, 'Ogni impiegato può avere solo una moglie o marito');          
        end if;

    end;

-- se un supervisore lavora per un dipartimento allora tutti gli impiegati che sono supervisionati da lui lavorano per lo stesso dipartimento
create or replace trigger lavoraSulloStessoDipartimento
before insert or update on impiegato
for each row
    declare
        counter number(1,0);

    begin
        select count(*) into counter
        from impiegato
        where impiegato.numero_dipartimento = :NEW.numero_dipartimento and  impiegato.cf = :NEW.cf_supervisore;

        if counter = 0 then
            raise_application_error(-20001, 'Dipartimento non coerente');
        end if;

    end;

-- un impiegato lavora massimo 200 ore su ciascun progetto diretto dal dipartimento a cui afferisce. In ogni caso, l'impiegato non supera le 800 ore totali.
create or replace trigger maxOre
before insert or update on lavora_su
for each row
    begin
        -- 1: query su progetto per ottenere il dipartimento che controlla quel progetto TODO: da inserire in una variabile
        /*
        * 2: query su impiegato per ottenere il dipartimento a cui afferisce 
        TODO: da inserire in una variabile e controllare con quella precedente: se diverse errore.
        TODO: se :NEW.ore > 200, errore
        */
        -- 3: query su lavora_su che calcola il totale delle ore che lavora l'impiegato :NEW.cf_impiegato


    end;

/* PROCEDURE */
create or replace procedure bilancia
is
    v1 lavora_su.cf_impiegato%type;
    v2 lavora_su.numero_progetto%type;

begin
    select cf_impiegato into v1
    from lavora_su
    group by cf_impiegato
    having sum(ore) =  (select min(sum(ore)) from lavora_su group by cf_impiegato);
    
    select numero_progetto into v2
    from lavora_su
    group by numero_progetto
    having sum(ore) = (select min(sum(ore)) from lavora_su group by numero_progetto);

    insert into lavora_su values (v1,v2,200);

    exception
        when others then
            raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

end bilancia;

-- cambio direttore: il nuovo deve lavorare più ore, deve non essere direttore di un'altro dipartimento e a parità di ore si preferisce il più giovane
create or replace procedure changeDirector(newCf char, numeroDipartimento number)
is
    alredyDir number;
    numOre number;
    oldNumOre number;
    oldCf char;
    date1, date2 date;
    aggiorna boolean := false;

begin
    select 1 into alredyDir
    from dipartimento
    where cf_direttore = newCf;

    select sum(ore) into numOre from lavora_su where cf = newCf
    
    select sum(ore), max(cf_direttore) into numOre, oldCf
    from dipartimento d join lavora_su l on d.cf_direttore = l.cf_impiegato
    where numero_dipartimento = numeroDipartimento;

    if (alredyDir or numOre < oldNumOre)
        dbms_output.put_line('non aggiornabile');
    elsif (numOre = oldNumOre) THEN
        select data_nascita into date1 from impiegato where cf = newcf;
        select data_nascita into date2 from impiegato where cf = oldcf;
        
		if ( d2 < d1 ) then
            dbms_output.put_line('non aggiornabile');
    	else
            aggiorna := true;
		end if;
	else
        aggiorna := true;
	end if;
	
	if (aggiorna) then
		update lavora_su set cf_direttore = cf_new where numero_dipartimento = num_dip;
		commit;
    end if;
    

    exception
        when others then
            raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

end bilancia;

/* FUNZIONI */
-- quante ore un impiegato lavora mediamente su un progetto
create or replace function mediaOre(
    taxCode char
)
return number
is
    hoursSum number;
    project number;

begin
    select sum(ore), count(numero_progetto) into hoursSum, project
    from lavora_su
    where cf_impiegato = taxCode;

    return hoursSum / project;

end mediaOre;