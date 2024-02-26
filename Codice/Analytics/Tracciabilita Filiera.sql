DROP PROCEDURE IF EXISTS qualita_prodotto;

DELIMITER $$

CREATE PROCEDURE qualita_prodotto(IN codice INTEGER)
BEGIN

	CALL animali_coinvolti(codice); 

	WITH
	dati_produzione AS(
	SELECT 	R.Fase,
			ABS((PP.DurataEffettiva-R.DurataIdeale)/R.DurataIdeale*100) AS RapportoDurata,
			ABS((PP.TemperaturaEffettiva - R.TemperaturaIdeale)/R.TemperaturaIdeale*100) AS RapportoTemperatura,
			ABS((PP.TempoRiposoEffettivo-R.TempoRiposoIdeale)/R.TempoRiposoIdeale*100) AS RapportoRiposo
	FROM 	PROCESSO_PRODUTTIVO PP
		 	INNER JOIN
		 	UNITA_PRODOTTO UP
		 	ON PP.Unita=UP.Codice
		 	INNER JOIN
		 	RICETTA R
		 	ON UP.Prodotto=R.Prodotto
	WHERE 	UP.Codice=codice
		  	AND PP.Fase=R.Fase)

	SELECT 	D.Fase,
		   	(CASE
			WHEN D.RapportoDurata<10 THEN "Ottima"
			WHEN D.RapportoDurata BETWEEN 10 AND 40 THEN "Normale"
			WHEN D.RapportoDurata>40 THEN "Pessima"
		   	END) AS ValutazioneDurata,
		   	(CASE
			WHEN D.RapportoTemperatura<10 THEN "Ottima"
			WHEN D.RapportoTemperatura BETWEEN 10 AND 40 THEN "Normale"
			WHEN D.RapportoTemperatura>40 THEN "Pessima"
		   	END) AS ValutazioneTemperatura,
		   	(CASE
			WHEN D.RapportoRiposo<10 THEN "Ottima"
			WHEN D.RapportoRiposo BETWEEN 10 AND 40 THEN "Normale"
			WHEN D.RapportoRiposo>40 THEN "Pessima"
		   	END) AS ValutazioneRiposo
	FROM 	dati_produzione D;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS animali_coinvolti;

DELIMITER $$

CREATE PROCEDURE animali_coinvolti(IN codice INTEGER)
BEGIN
	
	DECLARE lotto INT DEFAULT NULL;
    
    SELECT UP.Lotto INTO lotto
    FROM UNITA_PRODOTTO UP
    WHERE UP.Codice=codice;
    
	-- stampo gli indici salute degli animali coinvolti 

	SELECT V.Animale, V.Data, I.*
	FROM INDICI_SALUTE I
		 INNER JOIN
		 VISITA V 
		 ON I.Visita = V.Codice
		 INNER JOIN
         CONTRIBUZIONE C
         ON V.Animale=C.Animale
	WHERE C.Lotto=lotto;

	-- stampo gli esordi degli animali coinvolti

	SELECT E.*
	FROM ESORDIO E
		 INNER JOIN
		 CONTRIBUZIONE C
		 ON E.Animale=C.Animale
	WHERE C.Lotto=lotto;

END $$
DELIMITER ;



CALL qualita_prodotto (3);