DROP PROCEDURE IF EXISTS vicinanza_animali;

DELIMITER $$

CREATE PROCEDURE vicinanza_animali(IN area INT,
								   IN agriturismo INT)
BEGIN

	DECLARE orario_rientro1, orario_rientro2, ora_inizio1, ora_inizio2 TIME DEFAULT current_time();
	
    # mi ricavo gli orari delle attività degli animali
    
    SET orario_rientro1 = 
		(SELECT MIN(A.OrarioRientro)
		 FROM ATTIVITA A
         WHERE A.Area = area
			AND A.Agriturismo = agriturismo);
	
    SET orario_rientro2 =
		(SELECT MAX(A.OrarioRientro)
         FROM ATTIVITA A
         WHERE A.Area = area
			AND A.Agriturismo = agriturismo);
	
    SET ora_inizio1 =
		(SELECT MIN(A.OraInizio)
         FROM ATTIVITA A
         WHERE A.Area = area
			AND A.Agriturismo = agriturismo);
	
    SET ora_inizio2 = 
		(SELECT MAX(A.OraInizio)
         FROM ATTIVITA A
         WHERE A.Area = area
			AND A.Agriturismo = agriturismo);
										
                                        
# query

# creo una CTE contenente le posizioni degli animali appartenenti all'area e all'agriturismo selezionati
WITH posizioni_animali AS
(
SELECT P.*
FROM ANIMALE A
	 INNER JOIN
	 POSIZIONE P ON P.Animale = A.Codice
     INNER JOIN 
     LOCALE L ON A.Locale = L.Codice
     INNER JOIN 
     STALLA S ON S.Codice = L.Stalla
WHERE S.Zona = 001
	AND S.Agriturismo = 001
    # considero solamente le posizioni rilevate durante le attività, altrimenti il risultato non avrebbe senso
    AND ((P.Orario > ora_inizio1 AND P.Orario < orario_rientro1)
		OR (P.Orario > ora_inizio2 AND P.Orario < orario_rientro2))
)
SELECT PA1.Animale AS Animale1, PA2.Animale AS Animale2, ROUND((AVG(SQRT((POWER((PA1.Latitudine - PA2.Latitudine), 2)*10000000000) + (POWER((PA1.Longitudine - PA2.Longitudine), 2))*10000000000))), 4) AS DistanzaMedia
FROM posizioni_animali PA1
	 INNER JOIN
     posizioni_animali PA2 ON (PA1.Orario = PA2.Orario
								AND PA1.Animale <> PA2.Animale)
GROUP BY PA1.Animale, PA2.Animale
# per ogni animale trovo gli animali a cui sta più vicino
HAVING DistanzaMedia <= ALL (SELECT ROUND((AVG(SQRT((POWER((PA3.Latitudine - PA4.Latitudine), 2)*10000000000) + (POWER((PA3.Longitudine - PA4.Longitudine), 2))*10000000000))), 4)
												FROM posizioni_animali PA3
													 INNER JOIN
                                                     posizioni_animali PA4 ON (PA3.Orario = PA4.Orario
																				AND PA3.Animale <> PA4.Animale)
												WHERE PA3.Animale = PA1.Animale
												GROUP BY PA4.Animale)
ORDER BY DistanzaMedia DESC;
                                                
END $$
DELIMITER ;