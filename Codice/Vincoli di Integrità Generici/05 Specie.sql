DROP TRIGGER IF EXISTS vincolo_specie;

DELIMITER $$

CREATE TRIGGER vincolo_specie
BEFORE INSERT ON ANIMALE
FOR EACH ROW
BEGIN

	DECLARE specie_locale CHAR(50) DEFAULT ' ';

	SELECT L.Specie INTO specie_locale
	FROM LOCALE L
	WHERE L.Codice = NEW.Locale;

	IF specie_locale <> NEW.Specie THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = "Impossibile inserire due specie diverse in un locale";
	END IF;

END $$
DELIMITER ;



insert into ANIMALE(Sesso, Specie, Famiglia, Razza, DataNascita, Altezza, Peso, Locale, Padre, Madre) values
('M', 'Caprino', 'Bovidi', 'Caprone', '2019-10-10', 60, 70, 1, NULL, NULL);