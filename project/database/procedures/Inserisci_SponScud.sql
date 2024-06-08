CREATE OR REPLACE PROCEDURE inserisci_SponScud (
	nome_spon Sponsor.nome_sponsor%TYPE,
	sett_s Sponsor.settore_sponsor%TYPE,
	naz_s Sponsor.nazione_sponsor%TYPE,
	disc_s Sponsor.discriminatore_sponsor%TYPE,
	nome_scud Scuderia.nome_scuderia%TYPE
)
IS

	scud_count NUMBER;
    spon_count NUMBER;
	
BEGIN
	
    SELECT COUNT(*) INTO scud_count FROM Scuderia WHERE nome_scuderia = nome_scud;
    IF scud_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20040, 'La scuderia specificata non esiste.');
    END IF;

    SELECT COUNT(*) INTO spon_count FROM Sponsor WHERE nome_sponsor = nome_spon;
    IF spon_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20041, 'Esiste già una tupla nella tabella Sponsor con il nome specificato.');
    END IF;
	
    IF disc_s <> 'scuderia' AND disc_s <> 'Scuderia' AND disc_s <> 'SCUDERIA' THEN
        RAISE_APPLICATION_ERROR(-20042, 'Non si tratta di uno sponsor Scuderia');
    END IF;
	
    INSERT INTO Sponsor VALUES (nome_spon, sett_s, naz_s, disc_s);

    INSERT INTO Sponsorizza VALUES (nome_spon, nome_scud);
	
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('Sponsor inserito e associato ad una scuderia correttamente.');
	
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Errore: ' || SQLERRM);

END;