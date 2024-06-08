CREATE OR REPLACE PROCEDURE inserisci_scuderia (
    nome_s Scuderia.nome_scuderia%TYPE,
    ntp Scuderia.nome_team_principal%TYPE,
    ctp Scuderia.cognome_team_principal%TYPE,
    es Sede.email%TYPE,
    cs Sede.citta_sede%TYPE,
    naz_s Sede.nazione_sede%TYPE,
    ts Sede.telefono_sede%TYPE,
    mv Vettura.modello_vettura%TYPE,
    pu Vettura.power_unit%TYPE,
    cvv Vettura.cv%TYPE
)
IS

    email_count NUMBER;
    modello_count NUMBER;
	scud_count NUMBER;
	
BEGIN
	
    SELECT COUNT(*) INTO email_count FROM Sede WHERE email = es;

    IF email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20050, 'L''email della sede specificata esiste già nella tabella Sede.');
    END IF;

    SELECT COUNT(*) INTO modello_count FROM Vettura WHERE modello_vettura = mv;

    IF modello_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20051, 'Il modello della vettura specificato esiste già nella tabella Vettura.');
    END IF;
	
	SELECT COUNT(*) INTO scud_count FROM Scuderia WHERE nome_scuderia = nome_s;
	
	IF scud_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20052, 'Esiste già una scuderia con questo nome nella tabella Scuderia.');
    END IF;

    INSERT INTO Sede VALUES (es, cs, naz_s, ts);

    INSERT INTO Vettura VALUES (mv, pu, cvv);

    INSERT INTO Scuderia VALUES (nome_s, ntp, ctp, es, mv);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Inserimento completato con successo.');
	
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Errore durante l''inserimento della scuderia: ' || SQLERRM);
END;