create table Fornitore (
    nome_fornitore varchar(30) primary key,
    nazione_fornitore varchar(30)
);

create table Sponsor (
    nome_sponsor varchar(50) primary key,
    settore_sponsor varchar(30) not null,
    nazione_sponsor varchar(30),
    discriminatore_sponsor varchar(15) not null check (
        discriminatore_sponsor in ('gara', 'scuderia', 'Gara', 'Scuderia','GARA','SCUDERIA')
    )
);

create table Sede (
    email varchar(80) primary key,
    citta_sede varchar(30) not null,
    nazione_sede varchar(30) not null,
    telefono_sede varchar(17) unique
);

create table Circuito (
    nome_circuito varchar(50) primary key,
    nazione_circuito varchar(30) not null,
    localita varchar(30) not null,
    lunghezza varchar(10),
    num_curve number(2,0)
);

create table Vettura (
    modello_vettura varchar(10) primary key,
    power_unit varchar(30) not null,
    cv varchar(10)
);

create table Scuderia (
    nome_scuderia varchar(30) primary key,	
    nome_team_principal varchar(50),
    cognome_team_principal varchar(50),
    email varchar(80) not null unique,
    modello_vettura varchar(10) not null unique,
    constraint fk_sede_scuderia foreign key (email) references Sede (email) on delete cascade,
    constraint fk_vettura_scuderia foreign key (modello_vettura) references Vettura (modello_vettura) on delete cascade
);

create table Pilota (
    numero_pilota number(2,0) primary key check (numero_pilota >= 1 and numero_pilota <= 99),
    nome_pilota varchar(50) not null,
    cognome_pilota varchar(50) not null,
    nazione_pilota varchar(30),
    nome_scuderia varchar(30) not null,
    constraint fk_scuderia_pilota foreign key (nome_scuderia) references Scuderia (nome_scuderia) on delete cascade
);

create table Sponsorizza (
    nome_sponsor varchar(50),
    nome_scuderia varchar(30),
	constraint pk_sponsorizza primary key (nome_sponsor,nome_scuderia),
    constraint fk_sponsor_sponsorizza foreign key (nome_sponsor) references Sponsor (nome_sponsor) on delete cascade,
    constraint fk_scuderia_sponsorizza foreign key (nome_scuderia) references Scuderia (nome_scuderia) on delete cascade
);

create table Rifornisce (
    modello_vettura varchar(10),
    nome_fornitore varchar(30),
    tipo_fornitura varchar(30) not null,
	constraint pk_rifornisce primary key (modello_vettura,nome_fornitore),
    constraint fk_vettura_rifornisce foreign key (modello_vettura) references Vettura (modello_vettura) on delete cascade,
    constraint fk_fornitore_rifornisce foreign key (nome_fornitore) references Fornitore (nome_fornitore) on delete cascade
);

create table Medical_Car (
    marca_MC varchar(30) primary key check (
		marca_MC in ('aston martin','Aston Martin','ASTON MARTIN','mercedes','Mercedes','MERCEDES')
	),
    modello_MC varchar(30) not null unique check (
		modello_MC in ('dbx','DBX','gt 63 s 4matic+','GT 63 S 4MATIC+')
	)
);

create table Safety_Car (
    marca_SC varchar(30) primary key check (
		marca_SC in ('aston martin','Aston Martin','ASTON MARTIN','mercedes','Mercedes','MERCEDES')
	),
    modello_SC varchar(30) not null unique check (
		modello_SC in ('vantage','Vantage','VANTAGE','gt black series','GT Black Series','GT BLACK SERIES')
	)
);

create table Direttore (
    num_tesserino char(10) primary key,
	nome_direttore varchar(30) not null,
    cognome_direttore varchar(30) not null,
    nazione_direttore varchar(30)
);

create table Gara (
    data_gara date primary key,
    nome_gara varchar(80) not null,
    num_giri_previsti number(2,0) not null,
    num_giri_effettuati number(2,0) not null,
    ora_prevista_gara char(5) not null,
    ora_inizio_gara char(5),
    ora_fine_gara char(5),
    discriminatore_gara varchar(15) not null check (
        discriminatore_gara in ('sprint', 'completa', 'Sprint', 'Completa','SPRINT','COMPLETA')
    ),
    marca_MC varchar(30) not null,
    marca_SC varchar(30) not null,
    num_tesserino char(10) not null,
    nome_sponsor varchar(50),
    nome_circuito varchar(50) not null,
	numero_pilota number(2,0),
	constraint check_sprint_giro check ((discriminatore_gara <> 'sprint' and discriminatore_gara <> 'Sprint' and discriminatore_gara <> 'SPRINT') or
	(discriminatore_gara = 'sprint' and numero_pilota is null) or (discriminatore_gara = 'Sprint' and numero_pilota is null) or
	(discriminatore_gara = 'SPRINT' and numero_pilota is null)),
    constraint fk_medical_car_gara foreign key (marca_MC) references Medical_Car (marca_MC) on delete cascade,
	constraint fk_safety_car_gara foreign key (marca_SC) references Safety_Car (marca_SC) on delete cascade,
    constraint fk_direttore_gara foreign key (num_tesserino) references Direttore (num_tesserino) on delete cascade,
    constraint fk_sponsor_gara foreign key (nome_sponsor) references Sponsor (nome_sponsor) on delete set null,
    constraint fk_circuito_gara foreign key (nome_circuito) references Circuito (nome_circuito) on delete cascade,
	constraint fk_pilota_gara foreign key (numero_pilota) references Pilota (numero_pilota) on delete set null
);

create table Disputa_Gara (
    data_gara date,
    numero_pilota number(2,0),
    posizione_finale_gara number(2,0) not null check (posizione_finale_gara >= 1 and posizione_finale_gara <= 20),
    constraint pk_disputa_gara primary key (data_gara,numero_pilota),
	constraint uniq_gara_pos unique (data_gara,posizione_finale_gara),
	constraint fk_gara_disputa_gara foreign key (data_gara) references Gara (data_gara) on delete cascade,
    constraint fk_pilota_disputa_gara foreign key (numero_pilota) references Pilota (numero_pilota) on delete cascade
);

create table Si_Ritira (
    data_gara date,
    numero_pilota number(2,0),
    num_giro varchar(2) not null,
    causa varchar(30) not null check (
		causa in ('guasto','Guasto','GUASTO','incidente','Incidente','INCIDENTE')
	),
	constraint pk_ritiro primary key (data_gara,numero_pilota),
    constraint fk_gara_ritiro foreign key (data_gara) references Gara (data_gara) on delete cascade,
    constraint fk_pilota_ritiro foreign key (numero_pilota) references Pilota (numero_pilota) on delete cascade
);

create table Qualifica (
    sessione_qualifica char(2) check(sessione_qualifica in ('Q1', 'Q2', 'Q3','q1','q2','q3')),
    data_gara date,
    data_qualifica date not null,
    ora_prevista_qualifica char(5) not null,
    ora_inizio_qualifica char(5),
    ora_fine_qualifica char(5),
	constraint pk_qualifica primary key (sessione_qualifica,data_gara),
    constraint fk_gara_qualifica foreign key (data_gara) references Gara (data_gara) on delete cascade
);

create table Prove_Libere (
    sessione_prove char(3) check(sessione_prove in ('FP1', 'FP2', 'FP3','fp1','fp2','fp3','Fp1','Fp2','Fp3')),
    data_gara date,
    data_prove date not null,
    ora_prevista_prove char(5) not null,
    ora_inizio_prove char(5),
    ora_fine_prove char(5),
	constraint pk_prove primary key (sessione_prove,data_gara),
    constraint fk_gara_prove foreign key (data_gara) references Gara (data_gara) on delete cascade
);

create table Disputa_Prove (
	sessione_prove char(3),
    data_gara date,
    numero_pilota number(2,0),
    posizione_finale_prove number(2,0) not null check (posizione_finale_prove >= 1 and posizione_finale_prove <= 20),
	constraint pk_disputa_prove primary key (sessione_prove,data_gara,numero_pilota),
    constraint fk_gara_disputa_prove foreign key (data_gara,sessione_prove) references Prove_Libere (data_gara,sessione_prove) on delete cascade,
    constraint fk_pilota_disputa_prove foreign key (numero_pilota) references Pilota (numero_pilota) on delete cascade
);

create table Disputa_Qualifica (
	sessione_qualifica char(2),
    data_gara date,
    numero_pilota number(2,0),
    posizione_finale_qualifica number(2,0),
	constraint pk_disputa_qualifica primary key (sessione_qualifica,data_gara,numero_pilota),
    constraint fk_gara_disputa_qualifica foreign key (data_gara,sessione_qualifica) references Qualifica (data_gara,sessione_qualifica) on delete cascade,
    constraint fk_pilota_disputa_qualifica foreign key (numero_pilota) references Pilota (numero_pilota) on delete cascade,
	constraint check_posizione_finale_qualifica check (
		((sessione_qualifica = 'q1' or sessione_qualifica = 'Q1') and (posizione_finale_qualifica >=1 and posizione_finale_qualifica <=20)) or
		((sessione_qualifica = 'q2' or sessione_qualifica = 'Q2') and (posizione_finale_qualifica >=1 and posizione_finale_qualifica <=15)) or
		((sessione_qualifica = 'q3' or sessione_qualifica = 'Q3') and (posizione_finale_qualifica >=1 and posizione_finale_qualifica <=10))
	)
);
