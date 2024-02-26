/*Se durante una gravidanza un animale ha 3 visite 
di seguito con esito negativo questa viene interrotta*/
DROP TRIGGER IF EXISTS gravidanza_interrotta; 

DELIMITER $$ 

CREATE TRIGGER gravidanza_interrotta
AFTER INSERT ON CONTROLLO     
FOR EACH ROW 						          
BEGIN 

	DECLARE stato CHAR(50) DEFAULT 'In corso';
    DECLARE finito INTEGER DEFAULT 0;
    DECLARE contatore INTEGER DEFAULT 0;
    DECLARE risultato CHAR(10) DEFAULT NULL;

	DECLARE cursoreControlli CURSOR FOR
		SELECT C.Esito
		FROM CONTROLLO C
        WHERE C.SchedaGestazione=NEW.SchedaGestazione
		ORDER BY C.DataEffettiva;

	DECLARE CONTINUE HANDLER 
		FOR NOT FOUND SET finito = 1;

	OPEN cursoreControlli;

	scan: LOOP
		FETCH cursoreControlli INTO risultato;

        IF (finito=1) THEN
			LEAVE scan;
		END IF;
		
        IF (risultato='Negativo') THEN
			SET contatore=contatore+1;
		ELSE
			SET contatore=0;
		END IF;
		
		IF (contatore=3) THEN
			SET stato='Interrotta';
            LEAVE scan;
		END IF;
		
	END LOOP scan;
	CLOSE cursoreControlli;
	
	UPDATE SCHEDA_GESTAZIONE SG
	SET SG.StatoGravidanza = stato
	WHERE SG.Codice=NEW.SchedaGestazione;
	
END$$ 
DELIMITER ;


-- caso interrotto
insert into RIPRODUZIONE(Stato,Orario,Veterinario) values
('Successo','2019-08-25 00:00:00',1);
insert into SCHEDA_GESTAZIONE(CodiceRiproduzione, Veterinario, StatoGravidanza) values
(8, 1, 'In corso');
insert into CONTROLLO(SchedaGestazione, Veterinario, DataProgrammata, DataEffettiva, Esito) values
(5, 2, '2019-09-25', '2019-09-25', 'Negativo'),
(5, 2, '2019-10-25', '2019-10-25', 'Negativo'),
(5, 2, '2019-11-25', '2019-11-25', 'Negativo');

-- caso in corso
insert into RIPRODUZIONE(Stato,Orario,Veterinario) values
('Successo','2019-08-25 00:00:00',1);
insert into SCHEDA_GESTAZIONE(CodiceRiproduzione, Veterinario, StatoGravidanza) values
(9, 1, 'In corso');
insert into CONTROLLO(SchedaGestazione, Veterinario, DataProgrammata, DataEffettiva, Esito) values
(6, 2, '2019-08-25', '2019-08-25', 'Negativo'),
(6, 2, '2019-09-25', '2019-09-25', 'Positivo'),
(6, 2, '2019-10-25', '2019-10-25', 'Negativo'),
(6, 2, '2019-11-25', '2019-11-25', 'Negativo');
