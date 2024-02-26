
DROP PROCEDURE IF EXISTS abbeveratoi_mangiatoie;

DELIMITER $$

CREATE PROCEDURE abbeveratoi_mangiatoie(IN area INT,
										IN agriturismo INT)
BEGIN

	DECLARE orario_rientro1, orario_rientro2, ora_inizio1, ora_inizio2 TIME DEFAULT current_time();
	
    # mi ricavo gli orari delle attività relative all'area e all'agriturismo 
    
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

WITH posizioneAnimali AS
(SELECT P.*
 FROM POSIZIONE P 
	  INNER JOIN
      ANIMALE A ON P.Animale = A.Codice
      INNER JOIN 
      LOCALE L ON L.Codice = A.Codice
      INNER JOIN 
      STALLA S ON S.Codice = L.Stalla
 WHERE S.zona = area
	AND S.Agriturismo = agriturismo
    # considero solamente le posizioni rilevate durante le attività, altrimenti il risultato non avrebbe senso
	AND ((P.Orario > ora_inizio1 AND P.Orario < orario_rientro1)
			OR (P.Orario > ora_inizio2 AND P.Orario < orario_rientro2)))
SELECT PA.Longitudine, PA.Latitudine, (COUNT(*)*COUNT(DISTINCT PA.Animale))AS Frequenza
    FROM posizioneAnimali PA
	WHERE NOT EXISTS (SELECT PA1.Longitudine, PA1.Latitudine			# se ci sono più punti molto vicini considero solo quelli con frequenza maggiore
						FROM posizioneAnimali PA1
						WHERE (PA1.Latitudine <> PA.Latitudine
								OR PA1.Longitudine <> PA.Longitudine)
                            AND ABS(PA1.Latitudine - PA.Latitudine) <= 0.0001
                            AND ABS(PA1.Longitudine - PA.Longitudine) <= 0.0001
						GROUP BY PA1.Longitudine, PA1.Latitudine
                        HAVING (COUNT(*)*COUNT(DISTINCT PA1.Animale)) >(SELECT (COUNT(*)*COUNT(DISTINCT PA2.Animale))
																	 FROM posizioneAnimali PA2
																	 WHERE PA2.Longitudine = PA.Longitudine
                                                                         AND PA2.Latitudine = PA.Latitudine
																	 GROUP BY PA2.Longitudine, PA2.Latitudine))
GROUP BY PA.Longitudine, PA.Latitudine
ORDER BY Frequenza DESC;

END $$
DELIMITER ;
