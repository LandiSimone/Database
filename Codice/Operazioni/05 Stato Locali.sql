DROP EVENT IF EXISTS ciclo_locali;

DELIMITER $$

CREATE EVENT ciclo_locali
ON SCHEDULE EVERY 8 HOUR
## STARTS '2019-10-28 15:00:00'
DO
BEGIN 

	DECLARE finito INTEGER DEFAULT 0;
	DECLARE locale CHAR DEFAULT '';

	DECLARE cursoreLocali CURSOR FOR
		SELECT L.Codice
		FROM LOCALE L;

	DECLARE CONTINUE HANDLER
		FOR NOT FOUND SET finito = 1;

	OPEN cursoreLocali;

	scan: LOOP
		FETCH cursoreLocali INTO locale;
		IF (finito = 1) THEN
			LEAVE scan;
		END IF;
		CALL stato_locale(locale);
	END LOOP scan;
	CLOSE cursoreLocali;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS stato_locale;

DELIMITER $$

CREATE PROCEDURE stato_locale(IN codice CHAR)

BEGIN
	
	SELECT A.Locale, AC.*
	FROM ABBEVERATOIO A
		 INNER JOIN 
         ACQUA AC ON A.Acqua = AC.Codice
	WHERE A.Locale = codice
	LIMIT 1;

	SELECT SA.*
	FROM STATO_ABBEVERATOIO SA
		 INNER JOIN
		 ABBEVERATOIO A ON A.Codice = SA.Abbeveratoio
	WHERE A.Locale = codice
		  AND SA.Orario BETWEEN NOW() - INTERVAL 8 HOUR AND NOW()
	ORDER BY SA.Abbeveratoio;

	SELECT M.Locale, F.*
	FROM MANGIATOIA M
		 INNER JOIN
         FORAGGIO F ON M.Foraggio = F.Codice
	WHERE M.Locale = codice
	LIMIT 1;

	SELECT SM.*
	FROM STATO_MANGIATOIA SM
		 INNER JOIN
		 MANGIATOIA M ON M.Codice = SM.Mangiatoia
	WHERE M.Locale = codice
		  AND SM.Orario BETWEEN NOW() - INTERVAL 8 HOUR AND NOW()
	ORDER BY SM.Mangiatoia;

	SELECT M.*
	FROM MISURA M
	WHERE M.Locale = codice
		AND M.Orario = (SELECT MAX(M1.Orario)
						FROM MISURA M1
						WHERE M1.Locale = codice);

	SELECT S.*
	FROM SENSORI S
	WHERE S.Locale = codice
		AND S.Orario = (SELECT MAX(S1.Orario)
						FROM SENSORI S1
						WHERE S1.Locale = codice);

END $$
DELIMITER ;



CALL stato_locale(001);