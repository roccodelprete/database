------------------------
-- ripulitura db
------------------------
--
DROP TABLE ASSISTE;
--
DROP TABLE EFFETTUA;
--
DROP TABLE INFERMIERE;
--
DROP TABLE MEDICO;
--
DROP TABLE INTERVENTO;
--
DROP TABLE PAZIENTE;
--
DROP TABLE PERSONA;
-------------------------
-- creazione tabelle db
-------------------------
CREATE TABLE PERSONA(
CF                CHAR(16) PRIMARY KEY,
NOME              VARCHAR2(30),
COGNOME           VARCHAR2(30),
DATA_NASCITA      DATE,
SESSO             CHAR(1));
--
CREATE TABLE PAZIENTE(
DATA_RIC          DATE,
DATA_DIM          DATE,
CF                CHAR(16),
CONSTRAINT PK_PAZ PRIMARY KEY(CF,DATA_RIC),
CONSTRAINT FK_CF1 FOREIGN KEY (CF) REFERENCES PERSONA(CF));
--
CREATE TABLE INTERVENTO(
ID                NUMBER PRIMARY KEY,
TIPO              VARCHAR2(30),
DATA_E_ORA        DATE,
DURATA            NUMBER,
SALA_OP           VARCHAR2(30),
CF_PAZ            CHAR(16),
DATA_RIC          DATE,
CONSTRAINT FK_CF_PAZ FOREIGN KEY (CF_PAZ,DATA_RIC) REFERENCES PAZIENTE(CF,DATA_RIC));
--
CREATE TABLE MEDICO(
SPECIALIZZAZIONE  VARCHAR2(50),
ANNI_ESP          NUMBER,
CF                CHAR(16) PRIMARY KEY,
CONSTRAINT FK_CF2 FOREIGN KEY (CF) REFERENCES PERSONA(CF));
--
CREATE TABLE INFERMIERE(
DATA_ASS          DATE,
QUALIFICA         VARCHAR2(100),
CF                CHAR(16) PRIMARY KEY,
CONSTRAINT FK_CF3 FOREIGN KEY (CF) REFERENCES PERSONA(CF));
--
CREATE TABLE EFFETTUA(
CF_MED            CHAR(16),
ID_INT            NUMBER,
CONSTRAINT EFFETTUA_PK PRIMARY KEY(CF_MED,ID_INT),
CONSTRAINT FK_CF_MED FOREIGN KEY (CF_MED) REFERENCES MEDICO(CF),
CONSTRAINT FK_ID_INT1 FOREIGN KEY (ID_INT) REFERENCES INTERVENTO(ID));
--
CREATE TABLE ASSISTE(
CF_INF            CHAR(16),
ID_INT            NUMBER,
CONSTRAINT ASSISTE_PK PRIMARY KEY(CF_INF,ID_INT),
CONSTRAINT FK_CF_INF FOREIGN KEY (CF_INF) REFERENCES INFERMIERE(CF),
CONSTRAINT FK_ID_INT2 FOREIGN KEY (ID_INT) REFERENCES INTERVENTO(ID));