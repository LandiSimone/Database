DROP TRIGGER IF EXISTS rid_numero_unita_cantina;

DELIMITER $$

CREATE TRIGGER rid_numero_unita_cantina
AFTER INSERT ON COLLOCAZIONE_CANTINA
FOR EACH ROW
BEGIN 

	UPDATE CANTINA
	SET NumeroUnita = NumeroUnita + 1
	WHERE Codice = NEW.Cantina;

END $$
DELIMITER ;


DROP TRIGGER IF EXISTS rid_numero_unita_magazzino;

DELIMITER $$

CREATE TRIGGER rid_numero_unita_magazzino
AFTER INSERT ON COLLOCAZIONE_MAGAZZINO
FOR EACH ROW
BEGIN

	UPDATE MAGAZZINO
	SET NumeroUnita = NumeroUnita + 1
	WHERE Codice = NEW.Magazzino;

END $$
DELIMITER ;