DROP PROCEDURE IF EXISTS soggiorno_cnr;

DELIMITER $$

CREATE PROCEDURE soggiorno_cnr(IN CodiceCarta VARCHAR(50),
							   IN Arrivo DATE,
							   IN Partenza DATE,
							   IN Agriturismo INT,
							   IN TipoStanza CHAR(50))
BEGIN

	DECLARE stanza_libera INT DEFAULT 0;
    DECLARE stanze_libere INT DEFAULT 0;
	DECLARE prenotazione_attuale INT DEFAULT 0;
	DECLARE cnr_attuale INT DEFAULT 0;
	DECLARE pagamento_attuale INT DEFAULT 0;
	DECLARE prezzo INT DEFAULT 0;

	-- cerco una stanza libera nel periodo richiesto

	SET stanze_libere =
		(SELECT COUNT(DISTINCT S.Codice)
		 FROM STANZA S
			  INNER JOIN
		 	  PRENOTAZIONE_STANZA PS ON (S.Codice = PS.Stanza 
									     AND S.Agriturismo = PS.Agriturismo)
		 WHERE S.Agriturismo = Agriturismo
			AND S.Tipo = TipoStanza
			AND NOT EXISTS (SELECT*
							FROM PRENOTAZIONE_STANZA PS1
							WHERE PS1.Stanza = PS.Stanza
								AND PS1.Agriturismo = PS.Agriturismo
								AND ((PS1.DataArrivo < Arrivo
									  AND PS1.DataPartenza > Partenza)
									  OR (PS1.DataArrivo BETWEEN Arrivo AND Partenza - INTERVAL 1 DAY)
                                      OR (PS1.DataPartenza BETWEEN Arrivo + INTERVAL 1 DAY AND Partenza)))
		);
	
    
	IF (stanze_libere = 0) THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Non ci sono stanze disponibili nel periodo selezionato';
	END IF;


	SET stanza_libera = 
		(
		SELECT S.Codice
		FROM STANZA S
		 	INNER JOIN
		 	PRENOTAZIONE_STANZA PS ON (S.Codice = PS.Stanza 
									   AND S.Agriturismo = PS.Agriturismo)
		WHERE S.Agriturismo = Agriturismo
			AND S.Tipo = TipoStanza
			AND NOT EXISTS (SELECT*
							FROM PRENOTAZIONE_STANZA PS1
							WHERE PS1.Stanza = PS.Stanza
								AND PS1.Agriturismo = PS.Agriturismo
								AND ((PS1.DataArrivo < Arrivo
									  AND PS1.DataPartenza > Partenza)
									  OR (PS1.DataArrivo BETWEEN Arrivo AND Partenza - INTERVAL 1 DAY)))
		GROUP BY S.Codice
		LIMIT 1
		);

	-- prezzo della camera

	SET prezzo =
		(SELECT (S.Costo*DATEDIFF(Partenza,Arrivo))
		 FROM STANZA S
		 WHERE S.Agriturismo = Agriturismo
		 	AND S.Codice = stanza_libera
		 );
         
	-- inserisco prenotazione

	INSERT INTO PRENOTAZIONE (Data)
	VALUES (NOW());

	-- salvo il codice della prenotazione appena inserita

	SET prenotazione_attuale =
		(SELECT LAST_INSERT_ID()
		);

	-- inserisco prenotazione della stanza

	INSERT INTO PRENOTAZIONE_STANZA
	VALUES (prenotazione_attuale, stanza_libera, Agriturismo, Arrivo, Partenza);

	-- inserisco cnr

	INSERT INTO CLIENTE_NON_REGISTRATO (CodiceCartaCredito, AccountPayPal)
	VALUES (CodiceCarta, NULL);

	-- salvo il codice del cliente appena inserito

	SET cnr_attuale =
		(SELECT LAST_INSERT_ID()
		);

	-- inserisco prenotazione cnr

	INSERT INTO PRENOTAZIONE_CNR
	VALUES (prenotazione_attuale, cnr_attuale);

	-- inserisco primo pagamento

	INSERT INTO PAGAMENTO (Prenotazione, TipoPagamento, Orario, Importo)
	VALUES (prenotazione_attuale, 'Carta', NOW(), prezzo/2);

END $$
DELIMITER ;


CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Suite');
CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Semplice');
CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Semplice');
CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Suite');
CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Semplice');