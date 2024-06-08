CREATE OR REPLACE PROCEDURE aggiorna_risultato_prove (
	sp Disputa_Prove.sessione_prove%TYPE,
    dg Disputa_Prove.data_gara%TYPE,
    np Disputa_Prove.numero_pilota%TYPE,
    pfp Disputa_Prove.posizione_finale_prove%TYPE,
	dp Prove_Libere.data_prove%TYPE
)
IS

	prova_count NUMBER;
	pilota_count NUMBER;
	pilota_exists NUMBER;
	pos_exists NUMBER;

BEGIN

    SELECT COUNT(*) INTO prova_count FROM Prove_Libere WHERE data_gara = dg AND sessione_prove = sp AND data_prove = dp;

    IF prova_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20071, 'La data della sessione di prove libere, o della gara a cui fanno riferimento, non esiste nella tabella Prove Libere.');
    END IF;

    SELECT COUNT(*) INTO pilota_count FROM Pilota WHERE numero_pilota = np;

    IF pilota_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20072, 'Questo numero pilota non esiste nella tabella Pilota.');
    END IF;
	
	IF pfp < 1 OR pfp > 20 THEN
		RAISE_APPLICATION_ERROR(-20073, 'Questa posizione non può esistere!');
	END IF;

    SELECT COUNT(*) INTO pilota_exists FROM Disputa_Prove WHERE data_gara = dg AND sessione_prove = sp AND numero_pilota = np;
	SELECT COUNT(*) INTO pos_exists FROM Disputa_Prove WHERE data_gara = dg AND sessione_prove = sp AND posizione_finale_prove = pfp;

    IF pilota_exists > 0 AND pos_exists > 0 THEN
        DELETE FROM Disputa_Prove WHERE data_gara = dg AND sessione_prove = sp AND posizione_finale_prove = pfp;
		UPDATE Disputa_Prove SET posizione_finale_prove = pfp WHERE numero_pilota = np AND data_gara = dg AND sessione_prove = sp;
    ELSIF pilota_exists = 0 AND pos_exists > 0 THEN
		UPDATE Disputa_Prove SET numero_pilota = np WHERE data_gara = dg AND sessione_prove = sp AND posizione_finale_prove = pfp;
	ELSIF pilota_exists > 0 AND pos_exists = 0 THEN
		UPDATE Disputa_Prove SET posizione_finale_prove = pfp WHERE numero_pilota = np AND data_gara = dg AND sessione_prove = sp;
	ELSE
		INSERT INTO Disputa_Prove VALUES (sp, dg, np, pfp);
	END IF;

    COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('Aggiornamento completato con successo.');
	
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Errore durante l''aggiornamento del risultato: ' || SQLERRM);
END;