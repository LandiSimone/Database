DROP EVENT IF EXISTS ciclo_animali;

DELIMITER $$

CREATE EVENT ciclo_animali
ON SCHEDULE EVERY 1 DAY
## STARTS '2019-10-28 20:00:00'
DO
BEGIN

	DECLARE finito INTEGER DEFAULT 0;
	DECLARE animale INTEGER;

	-- dichiarazione del cursore

	DECLARE cursoreAnimali CURSOR FOR 
		SELECT A.Codice
		FROM ANIMALE A;

	-- dichiarazione handler
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;

	OPEN cursoreAnimali;

	-- ciclo
	scan: LOOP
		FETCH cursoreAnimali INTO animale;
		IF finito = 1 THEN
			LEAVE scan;
		END IF;
		CALL scheda_medica(animale);
	END LOOP scan;
	CLOSE cursoreAnimali;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS scheda_medica;

DELIMITER $$

CREATE PROCEDURE scheda_medica(IN codice INT)
BEGIN

	-- stampo le visite dell'animale

	SELECT*
	FROM VISITA V
	WHERE V.Animale = codice;

	-- stampo gli indicatori oggettivi

	SELECT IO.*, V.Data, V.Animale
	FROM INDICATORI_OGGETTIVI IO 
		 INNER JOIN
		 VISITA V ON IO.Visita = V.Codice
	WHERE V.Animale = codice;

	-- stampo gli indici salute

	SELECT I.*, V.Data, V.Animale
	FROM INDICI_SALUTE I
		 INNER JOIN
		 VISITA V ON I.Visita = V.Codice
	WHERE V.Animale = codice;

	-- stampo gli esordi dell'animale

	SELECT *
	FROM ESORDIO E
	WHERE E.Animale = codice;

	-- stampo le terapie dell'animale e i rimedi usati
	SELECT T.*, R.*, E.Patologia
	FROM TERAPIA T
		 INNER JOIN
		 ESORDIO E ON T.Esordio = E.Codice
		 INNER JOIN
		 RIMEDIO R ON R.Nome = T.Rimedio
	WHERE E.Animale = codice;

END $$
DELIMITER ;


CALL scheda_medica (002);