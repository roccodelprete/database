--PERSONA
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000001','ALBERTO','RUSSO',to_date('12/07/1974','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000002','NICOLA','AMATO',to_date('11/01/1964','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000003','MICHELE','AMABILE',to_date('22/03/1955','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000004','LUIGI','ALBERO',to_date('18/07/1957','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000005','ALFONSO','LIGUORI',to_date('11/05/1961','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000006','ROBERTO','DORATO',to_date('12/09/1962','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000007','RODOLFO','GALEOTAFIORE',to_date('13/01/1964','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000008','ANGELA','CURTIS',to_date('14/10/1978','dd/mm/yyyy'),'F');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000009','SILVIA','DINAPOLI',to_date('16/10/1960','dd/mm/yyyy'),'F');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000010','RENATO','APRILE',to_date('18/11/1958','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000011','CLAUDIO','CONTE',to_date('17/12/1959','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000012','CARLO','BRUCO',to_date('11/09/1971','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000013','CARMINE','RUOCCO',to_date('11/08/1972','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000014','ANTONIO','MAROTTA',to_date('15/11/1963','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000015','LEOPOLDO','ACAMPORA',to_date('15/02/1963','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000016','UMBERTO','SAVARESE',to_date('12/09/1989','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000017','ANTONIO','FORMISANO',to_date('13/01/1984','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000018','PATRIZIA','LAFEROLA',to_date('14/10/1981','dd/mm/yyyy'),'F');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000019','ANNA','GALLO',to_date('16/10/1978','dd/mm/yyyy'),'F');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000020','ROBERTA','CONTINIELLO',to_date('18/11/1979','dd/mm/yyyy'),'F');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000100','GIANFRANCO','CONTINIELLO',to_date('18/11/1970','dd/mm/yyyy'),'M');
insert into PERSONA(CF,NOME,COGNOME,DATA_NASCITA,SESSO) values('AAA0000000000101','GIOVANNI','SCARPATO',to_date('18/10/1980','dd/mm/yyyy'),'M');

--PAZIENTE
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('01/01/2009','dd/mm/yyyy'),to_date('05/01/2009','dd/mm/yyyy'),'AAA0000000000001');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('01/05/2009','dd/mm/yyyy'),NULL,'AAA0000000000002');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('25/04/2009','dd/mm/yyyy'),NULL,'AAA0000000000003');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('01/04/2009','dd/mm/yyyy'),NULL,'AAA0000000000004');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('12/03/2009','dd/mm/yyyy'),to_date('05/04/2009','dd/mm/yyyy'),'AAA0000000000005');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('19/04/2009','dd/mm/yyyy'),NULL,'AAA0000000000016');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('01/05/2009','dd/mm/yyyy'),NULL,'AAA0000000000017');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('02/05/2009','dd/mm/yyyy'),NULL,'AAA0000000000018');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('05/03/2009','dd/mm/yyyy'),NULL,'AAA0000000000019');
insert into PAZIENTE(DATA_RIC,DATA_DIM,CF) values(to_date('27/04/2009','dd/mm/yyyy'),NULL,'AAA0000000000020');

--INTERVENTO
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(100,'CHIRURGIA GENERALE',to_date('02/05/2009 12:00:00','dd/mm/yyyy HH24:mi:ss'),2,'SALA UNO','AAA0000000000001',to_date('01/01/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(101,'CHIRURGIA PLASTICA',to_date('07/05/2009 12:00:00','dd/mm/yyyy HH24:mi:ss'),3,'SALA DUE','AAA0000000000002',to_date('01/05/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(102,'CHIRURGIA GENERALE',to_date('08/05/2009 15:00:00','dd/mm/yyyy HH24:mi:ss'),4,'SALA TRE','AAA0000000000003',to_date('25/04/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(103,'LASER',to_date('11/05/2009 09:00:00','dd/mm/yyyy HH24:mi:ss'),1,'SALA UNO','AAA0000000000004',to_date('01/04/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(104,'CHIRURGIA GENERALE',to_date('13/03/2009 13:00:00','dd/mm/yyyy HH24:mi:ss'),2,'SALA DUE','AAA0000000000005',to_date('12/03/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(105,'LASER',to_date('14/04/2009 11:00:00','dd/mm/yyyy HH24:mi:ss'),1,'SALA TRE','AAA0000000000016',to_date('19/04/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(106,'CHIRURGIA GENERALE',to_date('11/05/2009 15:00:00','dd/mm/yyyy HH24:mi:ss'),3,'SALA UNO','AAA0000000000017',to_date('01/05/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(107,'LASER',to_date('17/04/2009 10:00:00','dd/mm/yyyy HH24:mi:ss'),5,'SALA DUE','AAA0000000000018',to_date('02/05/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(108,'CHIRURGIA GENERALE',to_date('17/04/2009 11:00:00','dd/mm/yyyy HH24:mi:ss'),3,'SALA UNO','AAA0000000000019',to_date('05/03/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(109,'CHIRURGIA PLASTICA',to_date('17/04/2009 15:00:00','dd/mm/yyyy HH24:mi:ss'),2,'SALA TRE','AAA0000000000020',to_date('27/04/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(110,'MASTECTOMIA',to_date('10/05/2009 18:00:00','dd/mm/yyyy HH24:mi:ss'),2,'SALA TRE','AAA0000000000020',to_date('27/04/2009','dd/mm/yyyy'));
insert into INTERVENTO(ID, TIPO, DATA_E_ORA, DURATA, SALA_OP, CF_PAZ,DATA_RIC) values(111,'CHIRURGIA GENERALE',to_date('19/03/2009 11:00:00','dd/mm/yyyy HH24:mi:ss'),1,'SALA TRE','AAA0000000000016',to_date('19/04/2009','dd/mm/yyyy'));

--MEDICO
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Medicina Interna',25,'AAA0000000000011');
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Endocrinologia',9,'AAA0000000000012');
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Ematologia',5,'AAA0000000000013');
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Cardiologia',11,'AAA0000000000014');
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Cardiologia',10,'AAA0000000000015');
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Cardiologia',6,'AAA0000000000100');
insert into MEDICO(SPECIALIZZAZIONE, ANNI_ESP, CF) values('Pneumologia',7,'AAA0000000000101');

--INFERMIERE
insert into INFERMIERE(DATA_ASS, QUALIFICA, CF) values(to_date('11/01/1975','dd/mm/yyyy'),'Capo Sala Day Hospital','AAA0000000000006');
insert into INFERMIERE(DATA_ASS, QUALIFICA, CF) values(to_date('05/09/1982','dd/mm/yyyy'),'Caposala Area Critica','AAA0000000000007');
insert into INFERMIERE(DATA_ASS, QUALIFICA, CF) values(to_date('15/01/2002','dd/mm/yyyy'),'Infermiera Professionale Medicina Donne','AAA0000000000008');
insert into INFERMIERE(DATA_ASS, QUALIFICA, CF) values(to_date('01/03/1990','dd/mm/yyyy'),'Infermiera Professionale Centro Antidiabetico Endocrinologia','AAA0000000000009');
insert into INFERMIERE(DATA_ASS, QUALIFICA, CF) values(to_date('07/05/1980','dd/mm/yyyy'),'Infermiere Professionale Medicina Uomini','AAA0000000000010');

--EFFETTUA
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000014',100);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000014',101);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000014',102);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000012',103);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000013',104);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000011',105);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000015',106);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000011',107);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000013',108);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000015',109);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000013',110);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000015',111);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000014',110);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000014',111);
insert into  EFFETTUA(CF_MED,ID_INT) values('AAA0000000000015',110);

--ASSISTE
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000006',100);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000006',101);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000006',102);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000007',103);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000007',102);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000006',103);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000007',104);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000007',105);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000007',106);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000006',107);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000006',108);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000007',109);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000010',100);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000009',101);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000009',102);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000009',103);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000010',104);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000010',105);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000009',106);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000008',107);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000008',108);
insert into ASSISTE(CF_INF, ID_INT) values('AAA0000000000008',109);

COMMIT;