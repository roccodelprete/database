CREATE OR REPLACE PROCEDURE inserisci_ritiro (
	dg Si_Ritira.data_gara%TYPE,
	np Si_Ritira.numero_pilota%TYPE,
	ng Si_Ritira.num_giro%TYPE,
	c Si_Ritira.causa%TYPE
)
IS
 
    gara_count NUMBER;
    pilota_count NUMBER;
	disputa_count NUMBER;
	
BEGIN
    SELECT COUNT(*) INTO gara_count FROM Gara WHERE data_gara = dg;
    
    IF gara_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20030, 'La data di gara specificata non esiste nella tabella Gara.');
    END IF;
    
    SELECT COUNT(*) INTO pilota_count FROM Pilota WHERE numero_pilota = np;
    
    IF pilota_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20031, 'Il numero di pilota specificato non esiste nella tabella Pilota.');
    END IF;
	
	SELECT COUNT(*) INTO disputa_count FROM Disputa_Gara WHERE data_gara = dg AND numero_pilota = np;
    
    IF disputa_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20032, 'Il numero di pilota specificato non partecipa alla gara specificata.');
    END IF;
    
    INSERT INTO Si_Ritira VALUES(dg, np, ng, c);
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Ritiro inserito correttamente.');
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Errore durante l''inserimento del ritiro: ' || SQLERRM);
END;