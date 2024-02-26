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
         
