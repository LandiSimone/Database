DROP EVENT IF EXISTS scan_agriturismi;

DELIMITER $$ 

CREATE EVENT scan_agriturismi
ON SCHEDULE EVERY 1 WEEK
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
        CALL prodotti_stagionati(agriturismo);
    END LOOP scan;
    CLOSE cursoreAgriturismi;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS prodotti_stagionati;

DELIMITER $$

CREATE PROCEDURE prodotti_stagionati(IN codice INT)
BEGIN
	
    SELECT CC.Unita, UP.Prodotto, CC.DataCollocazione
    FROM CANTINA C
		 INNER JOIN
         COLLOCAZIONE_CANTINA CC
         ON C.Codice=CC.Cantina
         INNER JOIN
         UNITA_PRODOTTO UP
         ON CC.Unita=UP.Codice
         INNER JOIN
         PRODOTTO P
         ON UP.Prodotto=P.Nome
	WHERE C.Agriturismo=codice
		  AND CURRENT_DATE>=DATE_ADD(CC.DataCollocazione, INTERVAL P.Stagionatura MONTH);

END $$
DELIMITER ;

CALL prodotti_stagionati(001);