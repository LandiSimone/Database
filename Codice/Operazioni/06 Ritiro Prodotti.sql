DROP PROCEDURE IF EXISTS animali_quarantena;

DELIMITER $$

CREATE PROCEDURE animali_quarantena(IN codice INT)
BEGIN 

	DECLARE data_esordio DATE DEFAULT NULL;
    
    SELECT MAX(E.DataEsordio) INTO data_esordio
    FROM ESORDIO E
		 INNER JOIN
         TERAPIA T
         ON E.Codice=T.Esordio
    WHERE E.Animale=codice
		  AND E.DataGuarigione IS NULL
    GROUP BY E.Codice, E.DataEsordio
    HAVING COUNT(T.Codice)=2;
    
    CALL ritiro_prodotti(codice, data_esordio);

END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS ritiro_prodotti;

DELIMITER $$

CREATE PROCEDURE ritiro_prodotti(IN codice INT,
								 IN	esordio DATE)
BEGIN
	
	DECLARE lotto INTEGER DEFAULT NULL;
	DECLARE finito INTEGER DEFAULT 0;


    DECLARE cursoreLotti CURSOR FOR
    
    	WITH date_invii AS
    		(SELECT C.DataInvio AS Invio,
    				LAG(C.DataInvio, 1) OVER (PARTITION BY C.Silos
    										  ORDER BY C.DataInvio) AS InvioPrecedente, 
    				C.Silos,
    				C.Lotto
	    	 FROM COMPOSIZIONE C
    		 )
   		SELECT DISTINCT DI.Lotto
    	FROM date_invii DI
    	 	INNER JOIN
    	 	MUNGITURA M ON DI.Silos = M.Silos
    	WHERE M.Animale = codice
    		AND DATE(M.Orario) >= esordio
    		AND M.Orario < DI.Invio
    		AND M.Orario > DI.InvioPrecedente;

    DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finito = 1;

    OPEN cursoreLotti;


    preleva: LOOP
    	FETCH cursoreLotti INTO lotto;
    	IF finito = 1 THEN
    		LEAVE preleva;
    	END IF;

    	DELETE 
    	FROM LOTTO L
    	WHERE L.Codice = lotto;
        
        DELETE FROM COLLOCAZIONE_CANTINA CC
        WHERE CC.Unita IN (SELECT UP.Codice
						   FROM UNITA_PRODOTTO UP
                           WHERE UP.Lotto = lotto);

        DELETE FROM COLLOCAZIONE_MAGAZZINO CM
        WHERE CM.Unita IN (SELECT UP.Codice
                           FROM UNITA_PRODOTTO UP
                           WHERE UP.Lotto = lotto);
                           
        DELETE FROM UNITA_PRODOTTO UP
        WHERE UP.Lotto = lotto;

    END LOOP preleva;
    CLOSE cursoreLotti;

END $$
DELIMITER ;


CALL animali_quarantena(001);