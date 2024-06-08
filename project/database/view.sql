-- classifica piloti
CREATE VIEW Vista_Punteggio AS
SELECT a.numero_pilota, MIN(p.nome_pilota) AS nome_pilota, MIN(p.cognome_pilota) AS cognome_pilota, MIN(p.nome_scuderia) nome_scuderia, SUM(punti) AS punteggio_totale
FROM (SELECT DISTINCT g.data_gara, g.numero_pilota, dg.posizione_finale_gara, 'giro veloce' AS discriminatore_gara, 1 AS punti
FROM Gara g JOIN Si_Ritira sr ON g.data_gara = sr.data_gara AND g.numero_pilota <> sr.numero_pilota
JOIN Disputa_Gara dg ON g.data_gara = dg.data_gara AND g.numero_pilota = dg.numero_pilota
WHERE dg.posizione_finale_gara <= 10

UNION

SELECT dg.data_gara, dg.numero_pilota, dg.posizione_finale_gara, g.discriminatore_gara, CASE
    WHEN dg.posizione_finale_gara <= 8 THEN
    DECODE (
    dg.posizione_finale_gara,
    1, 8,
    2, 7,
    3, 6,
    4, 5,
    5, 4,
    6, 3,
    7, 2,
    8, 1
)
    ELSE 0
	END
    AS punti
FROM Disputa_Gara dg JOIN Gara g ON dg.data_gara = g.data_gara
WHERE discriminatore_gara = 'Sprint'
    
UNION
    
SELECT dg.data_gara, dg.numero_pilota, dg.posizione_finale_gara, g.discriminatore_gara, CASE
    WHEN dg.posizione_finale_gara <= 10 THEN
    DECODE (
    dg.posizione_finale_gara,
    1, 25,
    2, 18,
    3, 15,
    4, 12,
    5, 10,
    6, 8,
    7, 6,
    8, 4,
    9, 2,
    10, 1
)
    ELSE 0
	END
    AS punti
FROM Disputa_Gara dg JOIN Gara g ON dg.data_gara = g.data_gara
WHERE discriminatore_gara = 'Completa') a
JOIN Pilota p ON a.numero_pilota = p.numero_pilota
GROUP BY a.numero_pilota
ORDER BY punteggio_totale DESC;


-- classifica costruttori a partire dalla vista della classifica dei piloti
SELECT nome_scuderia, SUM(punteggio_totale) AS punteggio_totale FROM Vista_Punteggio
GROUP BY nome_scuderia
ORDER BY punteggio_totale DESC;
