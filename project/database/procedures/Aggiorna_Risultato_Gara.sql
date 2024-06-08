CREATE OR REPLACE PROCEDURE aggiorna_risultato_gara (
    dg Disputa_Gara.data_gara%TYPE,
    np Disputa_Gara.numero_pilota%TYPE,
    pfg Disputa_Gara.posizione_finale_gara%TYPE
)
IS

	gara_count NUMBER;
	pilota_count NUMBER;
	pilota_exists NUMBER;
	pos_exists NUMBER;

BEGIN

    SELECT COUNT(*) INTO gara_count FROM Gara WHERE data_gara = dg;

    IF gara_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20061, 'La data della gara specificata non esiste nella tabella Gara.');
    END IF;

    SELECT COUNT(*) INTO pilota_count FROM Pilota WHERE numero_pilota = np;

    IF pilota_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20062, 'Questo numero pilota non esiste nella tabella Pilota.');
    END IF;
	
	IF pfg < 1 OR pfg > 20 THEN
		RAISE_APPLICATION_ERROR(-20063, 'Questa posizione non può esistere!');
	END IF;

    SELECT COUNT(*) INTO pilota_exists FROM Disputa_Gara WHERE data_gara = dg AND numero_pilota = np;
	SELECT COUNT(*) INTO pos_exists FROM Disputa_Gara WHERE data_gara = dg AND posizione_finale_gara = pfg;

    IF pilota_exists > 0 AND pos_exists > 0 THEN
        DELETE FROM Disputa_Gara WHERE data_gara = dg AND posizione_finale_gara = pfg;
		UPDATE Disputa_Gara SET posizione_finale_gara = pfg WHERE numero_pilota = np AND data_gara = dg;
    ELSIF pilota_exists = 0 AND pos_exists > 0 THEN
		UPDATE Disputa_Gara SET numero_pilota = np WHERE data_gara = dg AND posizione_finale_gara = pfg;
	ELSIF pilota_exists > 0 AND pos_exists = 0 THEN
		UPDATE Disputa_Gara SET posizione_finale_gara = pfg WHERE numero_pilota = np AND data_gara = dg;
	ELSE
		INSERT INTO Disputa_Gara VALUES (dg, np, pfg);
	END IF;

    COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('Aggiornamento completato con successo.');
	
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Errore durante l''aggiornamento del risultato: ' || SQLERRM);
END;