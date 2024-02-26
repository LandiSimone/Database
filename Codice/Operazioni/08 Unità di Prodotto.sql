DROP EVENT IF EXISTS scan_numero_unita;

DELIMITER $$

CREATE EVENT scan_numero_unita
ON SCHEDULE EVERY 1 DAY
DO
BEGIN

	DECLARE agriturismo INTEGER DEFAULT NULL;
	DECLARE finito INTEGER DEFAULT 0;

	DECLARE cursoreAgriturismi CURSOR FOR
		SELECT A.Codice
		FROM AGRITURISMO A;

	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;

	OPEN cursoreAgriturismi;


	scan: LOOP
		FETCH cursoreAgriturismi INTO agriturismo;
		IF finito = 1 THEN
			LEAVE scan;
		END IF;
		CALL numero_unita(agriturismo);
	END LOOP scan;
	CLOSE cursoreAgriturismi;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS numero_unita;

DELIMITER $$

CREATE PROCEDURE numero_unita(IN codice INTEGER)
BEGIN
	
	SELECT M.Codice AS Magazzino, M.Agriturismo AS Agriturismo, COUNT(*) AS Unita
	FROM COLLOCAZIONE_MAGAZZINO CM 
		 INNER JOIN 
		 MAGAZZINO M ON M.Codice = CM.Magazzino
	WHERE M.Agriturismo=codice
	GROUP BY M.Codice, M.Agriturismo;

	SELECT C.Codice AS Cantina, C.Agriturismo AS Agriturismo, COUNT(*) AS Unita
	FROM COLLOCAZIONE_CANTINA CC 
		 INNER JOIN 
		 CANTINA C ON C.Codice = CC.Cantina
	WHERE C.Agriturismo=codice
	GROUP BY C.Codice, C.Agriturismo;

END $$
DELIMITER ;

CALL numero_unita(001);
