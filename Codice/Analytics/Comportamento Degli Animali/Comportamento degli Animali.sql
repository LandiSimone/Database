DROP PROCEDURE IF EXISTS comportamento_degli_animali;

DELIMITER $$

CREATE PROCEDURE comportamento_degli_animali(IN area INT,
											 IN agriturismo INT)
BEGIN

	CALL posizione_recinzioni(area, agriturismo);
    
    CALL abbeveratoi_mangiatoie(area, agriturismo);
    
    CALL vicinanza_animali(area, agriturismo);
    
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS posizione_recinzioni;

DELIMITER $$

CREATE PROCEDURE posizione_recinzioni(IN area INT,
											 IN agriturismo INT)
BEGIN

	DECLARE orario_rientro1, orario_rientro2, ora_inizio1, ora_inizio2 TIME DEFAULT current_time();
	DECLARE locale1, locale2 INTEGER DEFAULT 0;
	DECLARE longitudineMax DOUBLE DEFAULT NULL;
    DECLARE longitudineMin DOUBLE DEFAULT NULL;
    DECLARE latitudineMax DOUBLE DEFAULT NULL;
    DECLARE latitudineMin DOUBLE DEFAULT NULL;
    DECLARE nord, sud, est, ovest INTEGER DEFAULT 0;
    
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

	SET longitudineMax = 
		(SELECT MAX(P.Longitudine) + 0.0001
		 FROM POSIZIONE P
			  INNER JOIN
			  ANIMALE A ON A.Codice = P.Animale
              INNER JOIN 
              LOCALE L ON L.Codice = A.Locale
              INNER JOIN 
              STALLA S ON S.Codice = L.Stalla
		 WHERE S.Zona = area
			AND S.Agriturismo = agriturismo
            AND ((P.Orario > ora_inizio1 AND P.Orario < orario_rientro1)
				OR (P.Orario > ora_inizio2 AND P.Orario < orario_rientro2))
         );
    
    SET longitudineMin = 
		(SELECT MIN(P.Longitudine) - 0.0001
		 FROM POSIZIONE P
			  INNER JOIN
			  ANIMALE A ON A.Codice = P.Animale
              INNER JOIN 
              LOCALE L ON L.Codice = A.Locale
              INNER JOIN 
              STALLA S ON S.Codice = L.Stalla
		 WHERE S.Zona = area
			AND S.Agriturismo = agriturismo
            AND ((P.Orario > ora_inizio1 AND P.Orario < orario_rientro1)
				OR (P.Orario > ora_inizio2 AND P.Orario < orario_rientro2))
         );
		
	SET latitudineMax = 
		(SELECT MAX(P.Latitudine) + 0.0001
		 FROM POSIZIONE P
			  INNER JOIN
			  ANIMALE A ON A.Codice = P.Animale
              INNER JOIN 
              LOCALE L ON L.Codice = A.Locale
              INNER JOIN 
              STALLA S ON S.Codice = L.Stalla
		 WHERE S.Zona = area
			AND S.Agriturismo = agriturismo
            AND ((P.Orario > ora_inizio1 AND P.Orario < orario_rientro1)
				OR (P.Orario > ora_inizio2 AND P.Orario < orario_rientro2))
         );
		
	SET latitudineMin =
		(SELECT MIN(P.Latitudine) - 0.0001
		 FROM POSIZIONE P
			  INNER JOIN
			  ANIMALE A ON A.Codice = P.Animale
              INNER JOIN 
              LOCALE L ON L.Codice = A.Locale
              INNER JOIN 
              STALLA S ON S.Codice = L.Stalla
		 WHERE S.Zona = area
			AND S.Agriturismo = agriturismo
            AND ((P.Orario > ora_inizio1 AND P.Orario < orario_rientro1)
				OR (P.Orario > ora_inizio2 AND P.Orario < orario_rientro2))
         );
	
	SET nord =
		(SELECT R.Codice
         FROM RECINZIONE R
         WHERE R.LatitudineInizio = R.LatitudineFine
			AND R.LatitudineInizio = (SELECT MAX(R1.LatitudineInizio)
									  FROM RECINZIONE R1
										   INNER JOIN 
                                           DELIMITAZIONE D ON R1.Codice = D.Recinzione
									  WHERE D.Area = area
											AND D.Agriturismo = agriturismo)
	);
    
    SET sud =
		(SELECT R.Codice
         FROM RECINZIONE R
         WHERE R.LatitudineInizio = R.LatitudineFine
			AND R.LatitudineInizio = (SELECT MIN(R1.LatitudineInizio)
									  FROM RECINZIONE R1
										   INNER JOIN
                                           DELIMITAZIONE D ON R1.Codice = D.Recinzione
									  WHERE D.Area = area
											AND D.Agriturismo = agriturismo)
		);
        
	SET est =
		(SELECT R.Codice
         FROM RECINZIONE R
         WHERE R.LongitudineInizio = R.LongitudineFine
			AND R.LongitudineInizio = (SELECT MAX(R1.LongitudineInizio)
									  FROM RECINZIONE R1
										   INNER JOIN
                                           DELIMITAZIONE D ON R1.Codice = D.Recinzione
									  WHERE D.Area = area
											AND D.Agriturismo = agriturismo)
		);
        
	SET ovest =
		(SELECT R.Codice
         FROM RECINZIONE R
         WHERE R.LongitudineInizio = R.LongitudineFine
			AND R.LongitudineInizio = (SELECT MIN(R1.LongitudineInizio)
									  FROM RECINZIONE R1
										   INNER JOIN
                                           DELIMITAZIONE D ON R1.Codice = D.Recinzione
									  WHERE D.Area = area
											AND D.Agriturismo = agriturismo)
		);
	
    
    SELECT est AS Recinzione, longitudineMax AS Longitudine1, longitudineMax AS Longitudine2, latitudineMin AS Latitudine1, latitudineMax as Latitudine2, 'Est' AS Posizione
    
    UNION
    
    SELECT ovest AS Recinzione, longitudineMin AS Longitudine1, longitudineMin as Longitudine2, latitudineMin AS Latitudine1, latitudineMax as Latitudine2, 'Ovest' AS Posizione
    
    UNION
    
    SELECT nord AS Recinzione, longitudineMin AS Longitudine1, longitudineMax as Longitudine2, latitudineMax AS Latitudine1, latitudineMax as Latitudine2, 'Nord' AS Posizione
    
    UNION
    
    SELECT sud AS Recinzione, longitudineMin AS Longitudine1, longitudineMax as Longitudine2, latitudineMin AS Latitudine1, latitudineMin as Latitudine2, 'Sud' AS Posizione
    ORDER BY Recinzione;
    
END $$
DELIMITER ;
         



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




CALL comportamento_degli_animali(001,001);