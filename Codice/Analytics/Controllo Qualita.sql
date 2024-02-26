DROP PROCEDURE IF EXISTS qualita_lotto;

DELIMITER $$

CREATE PROCEDURE qualita_lotto(IN lotto INTEGER)
BEGIN

WITH dati_produzione AS(
	SELECT 	UP.Codice,
			R.Fase,
			UP.Prodotto,
            UP.Lotto,
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
	WHERE 	UP.Lotto=lotto
		  	AND PP.Fase=R.Fase
	GROUP BY UP.Codice,R.Fase),

	valori_medi AS(
	SELECT 	D.Prodotto,
			D.Fase,
		   	AVG(D.RapportoDurata) AS DurataMedia,
		   	AVG(D.RapportoTemperatura) AS TemperaturaMedia,
		   	AVG(D.RapportoRiposo) AS RiposoMedio
	FROM 	dati_produzione D
    GROUP BY D.Prodotto, D.Fase)

	SELECT 	V.Prodotto,
			V.Fase,		    
		   	(CASE
			WHEN V.DurataMedia<10 THEN "Ottima"
			WHEN V.DurataMedia BETWEEN 10 AND 40 THEN "Normale"
			WHEN V.DurataMedia>40 THEN "Pessima"
		   	END) AS ValutazioneDurata,
		   	(CASE
			WHEN V.TemperaturaMedia<10 THEN "Ottima"
			WHEN V.TemperaturaMedia BETWEEN 10 AND 40 THEN "Normale"
			WHEN V.TemperaturaMedia>40 THEN "Pessima"
		   	END) AS ValutazioneTemperatura,
		   	(CASE
			WHEN V.RiposoMedio<10 THEN "Ottima"
			WHEN V.RiposoMedio BETWEEN 10 AND 40 THEN "Normale"
			WHEN V.RiposoMedio>40 THEN "Pessima"
		   	END) AS ValutazioneRiposo
	FROM 	valori_medi V
    ORDER BY V.Prodotto, V.Fase;

END $$
DELIMITER ;



CALL qualita_lotto(18);