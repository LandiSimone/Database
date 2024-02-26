
insert into MUNGITURA values
(6, '2019-11-25 12:00:00', 5, 01, 01, 01),
(7, '2019-11-25 12:05:00', 5, 01, 01, 01),
(8, '2019-11-25 12:10:00', 5, 01, 01, 01),
(9, '2019-11-25 12:15:00', 5, 01, 01, 01),
(10, '2019-11-25 12:20:00', 5, 01, 01, 01);

insert into COMPOSIZIONE values
(01, 13, '2019-11-22');



DROP PROCEDURE IF EXISTS inserimento_contribuzione;

DELIMITER $$

CREATE PROCEDURE inserimento_contribuzione (IN lotto INT,
											IN silos INT,
											IN invio DATETIME,
                                            IN invioPrec DATETIME)
BEGIN

    
	DECLARE finito INTEGER DEFAULT 0;
    DECLARE animale INTEGER DEFAULT NULL;
    
    DECLARE cursoreAnimali CURSOR FOR
		SELECT DISTINCT M.Animale
        FROM MUNGITURA M
			 NATURAL JOIN
             COMPOSIZIONE C
		WHERE M.Silos = silos
			AND M.Orario BETWEEN invioPrec AND invio;
            
	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;
        
        
	OPEN cursoreAnimali;
    
    preleva: LOOP
		FETCH cursoreAnimali INTO animale;
		IF (finito = 1) THEN
			LEAVE preleva;
		END IF;
        INSERT INTO CONTRIBUZIONE VALUES (lotto, animale);
	 END LOOP preleva;
	 CLOSE cursoreAnimali;
     
END $$
DELIMITER ;
    
    
DROP TRIGGER IF EXISTS ridondanza_contribuzione;

DELIMITER $$

CREATE TRIGGER ridondanza_contribuzione
BEFORE INSERT ON COMPOSIZIONE
FOR EACH ROW
BEGIN

    DECLARE dataInvioPrec DATETIME DEFAULT NULL;
    
	SET dataInvioPrec = 
		(SELECT C.DataInvio
         FROM COMPOSIZIONE C
         WHERE C.Silos = NEW.Silos
			AND C.DataInvio < NEW.DataInvio
			AND NOT EXISTS (SELECT*
							FROM COMPOSIZIONE C1
                            WHERE C1.DataInvio > C.DataInvio
								AND C1.DataInvio < NEW.DataInvio
								AND C1.Silos = C.Silos)
		);
        
	CALL inserimento_contribuzione (NEW.Lotto, NEW.Silos, NEW.DataInvio, dataInvioPrec);
    
END $$
DELIMITER ;


insert into COMPOSIZIONE values
(01, 14, '2019-11-26');
    
    

	

