DROP PROCEDURE IF EXISTS comportamento_degli_animali;

DELIMITER $$

CREATE PROCEDURE comportamento_degli_animali(IN area INT,
											 IN agriturismo INT)
BEGIN

	CALL posizione_recinzioni(area, agriturismo);
    
    CALL abbeveratoi_mangiatoie(area, agriturismo);
    
    CALL vicinanza_animali(area, agriturismo);
    
END $$
DELIMITER ;

