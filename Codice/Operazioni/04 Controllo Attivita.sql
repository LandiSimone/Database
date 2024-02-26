
DROP PROCEDURE IF EXISTS scan_locali;
DROP PROCEDURE IF EXISTS controllo_attivita;

DELIMITER $$

CREATE PROCEDURE scan_locali()

BEGIN

	DECLARE finito INTEGER DEFAULT 0;
	DECLARE locale INTEGER;

	DECLARE cursoreLocali CURSOR FOR
		SELECT L.Codice
		FROM LOCALE L;

	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;

	OPEN cursoreLocali;

	scan: LOOP
		FETCH cursoreLocali INTO locale;
		IF finito = 1 THEN
			LEAVE scan;
		END IF;
		CALL controllo_attivita(locale);
	END LOOP scan;
	CLOSE cursoreLocali;

END $$
DELIMITER;


DELIMITER $$

CREATE PROCEDURE controllo_attivita(IN Locale INT)
BEGIN
	
	DECLARE finito INTEGER DEFAULT 0;
	DECLARE attivita INTEGER DEFAULT 0;
	DECLARE ora_rientro TIME DEFAULT '00:00:00';

	DECLARE cursoreAttivita CURSOR FOR 
		SELECT S.Attivita
		FROM SVOLGIMENTO S
		WHERE S.Locale = Locale;

	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;

	OPEN cursoreAttivita;

	scan: LOOP
		FETCH cursoreAttivita INTO attivita;
		IF finito = 1 THEN
			LEAVE scan;
		END IF;
    
    	SELECT A.OrarioRientro INTO ora_rientro 
		FROM ATTIVITA A
		 	 INNER JOIN
			 SVOLGIMENTO S
			 ON A.Codice=S.Attivita 
		WHERE S.Locale = Locale
			AND A.Codice = attivita;

		SELECT P.Animale As Animale_ribelle, A.Locale, ora_rientro
		FROM ANIMALE A 
		 	 INNER JOIN
			 POSIZIONE P
			 ON A.Codice=P.Animale
			 INNER JOIN
			 COORDINATE C 
			 ON C.Locale = A.Locale
		WHERE P.Orario >= ora_rientro
			AND A.Locale = Locale
			AND NOT EXISTS (SELECT*
							FROM POSIZIONE P1
							WHERE P1.Animale = P.Animale
								AND P1.Orario >= ora_rientro
								AND P1.Orario < P.Orario)
			AND (P.Latitudine >= C.LatitudineMax
				OR P.Latitudine <= C.LatitudineMin
				OR P.Longitudine >= C.LongitudineMax
				OR P.Longitudine <= C.LongitudineMin)
		GROUP BY P.Animale, A.Locale;

	END LOOP scan;
	CLOSE cursoreAttivita;
	
END $$
DELIMITER ;


CALL controllo_attivita(001);
CALL controllo_attivita(002);
