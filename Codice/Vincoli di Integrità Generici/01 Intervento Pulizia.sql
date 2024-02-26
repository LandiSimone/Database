/*Se l’azoto, il metano o il livello di sporcizia superano una certa soglia 
il sistema inserisce una richiesta di intervento di pulizia*/
DROP TRIGGER IF EXISTS intervento_pulizia; 

DELIMITER $$ 

CREATE TRIGGER intervento_pulizia
BEFORE INSERT ON SENSORI     
FOR EACH ROW 						          
BEGIN

	IF (NEW.Azoto>80) THEN
		SET NEW.Intervento='Richiesto';

	ELSEIF (NEW.Metano>70) THEN
		SET NEW.Intervento='Richiesto';

	ELSEIF (NEW.LivelloSporcizia='Alto') THEN
		SET NEW.Intervento='Richiesto';
		
	ELSE
		SET NEW.Intervento=NULL;
	END IF;

END$$ 
DELIMITER ;


insert into SENSORI(Orario,Locale,Azoto,Metano,LivelloSporcizia) values
('2019-11-25 00:00:00',2,85,50,'Basso'),
('2019-11-25 00:00:00',3,50,80,'Basso'),
('2019-11-25 00:00:00',4,50,50,'Alto');
