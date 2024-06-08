CREATE OR REPLACE PROCEDURE aggiorna_risultato_quali (
	sq Disputa_Qualifica.sessione_qualifica%TYPE,
    dg Disputa_Qualifica.data_gara%TYPE,
    np Disputa_Qualifica.numero_pilota%TYPE,
    pfq Disputa_Qualifica.posizione_finale_qualifica%TYPE
)
IS

	quali_count NUMBER;
	pilota_count NUMBER;
	pilota_exists NUMBER;
	pos_exists NUMBER;

BEGIN

    SELECT COUNT(*) INTO quali_count FROM Qualifica WHERE data_gara = dg AND sessione_qualifica = sq;

    IF quali_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20081, 'La data della sessione della gara a cui la qualifica fa riferimento non esiste nella tabella Qualifica.');
    END IF;

    SELECT COUNT(*) INTO pilota_count FROM Pilota WHERE numero_pilota = np;

    IF pilota_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20082, 'Questo numero pilota non esiste nella tabella Pilota.');
    END IF;
	
	IF ((pfq < 1 OR pfq > 20) AND sq = 'q1') OR ((pfq < 1 OR pfq > 20) AND sq = 'Q1') OR
	((pfq < 1 OR pfq > 15) AND sq = 'q2') OR ((pfq < 1 OR pfq > 15) AND sq = 'Q2') OR
	((pfq < 1 OR pfq > 10) AND sq = 'q3') OR ((pfq < 1 OR pfq > 10) AND sq = 'Q3') THEN
		RAISE_APPLICATION_ERROR(-20083, 'Questa posizione non può esistere!');
	END IF;

    SELECT COUNT(*) INTO pilota_exists FROM Disputa_Qualifica WHERE data_gara = dg AND sessione_qualifica = sq AND numero_pilota = np;
	SELECT COUNT(*) INTO pos_exists FROM Disputa_Qualifica WHERE data_gara = dg AND sessione_qualifica = sq AND posizione_finale_qualifica = pfq;

    IF pilota_exists > 0 AND pos_exists > 0 THEN
        DELETE FROM Disputa_Qualifica WHERE data_gara = dg AND sessione_qualifica = sq AND posizione_finale_qualifica = pfq;
		UPDATE Disputa_Qualifica SET posizione_finale_qualifica = pfq WHERE numero_pilota = np AND data_gara = dg AND sessione_qualifica = sq;
    ELSIF pilota_exists = 0 AND pos_exists > 0 THEN
		UPDATE Disputa_Qualifica SET numero_pilota = np WHERE data_gara = dg AND sessione_qualifica = sq AND posizione_finale_qualifica = pfq;
	ELSIF pilota_exists > 0 AND pos_exists = 0 THEN
		UPDATE Disputa_Qualifica SET posizione_finale_qualifica = pfq WHERE numero_pilota = np AND data_gara = dg AND sessione_qualifica = sq;
	ELSE
		INSERT INTO Disputa_Qualifica VALUES (sq, dg, np, pfq);
	END IF;

    COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('Aggiornamento completato con successo.');
	
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Errore durante l''aggiornamento del risultato: ' || SQLERRM);
END;