/*Se una o più patologie non vengono risolte dopo due terapie, 
l’animale viene inserito in quarantena*/
DROP TRIGGER IF EXISTS inserimento_quarantena; 

DELIMITER $$ 

CREATE TRIGGER inserimento_quarantena
AFTER INSERT ON TERAPIA     
FOR EACH ROW                                  
BEGIN 

    DECLARE numero_terapie INTEGER DEFAULT 0;
    DECLARE data_guarigione DATE DEFAULT NULL;
    
    SELECT COUNT(*) INTO numero_terapie
    FROM TERAPIA T
    WHERE T.Esordio=NEW.Esordio;
    
    SELECT E.DataGuarigione INTO data_guarigione
    FROM ESORDIO E
    WHERE E.Codice=NEW.Esordio;
    
    IF(numero_terapie>=2 AND data_guarigione IS NULL) THEN
        INSERT INTO QUARANTENA (Animale,DataInizio) 
        SELECT E.Animale, current_date()
        FROM ESORDIO E
        WHERE E.Codice=NEW.Esordio;
    END IF;

END$$ 
DELIMITER ;


insert into ESORDIO(Patologia, Animale, DataEsordio, Entita, DataGuarigione) values
(18, 33, '2019-05-05', 9, NULL);
insert into TERAPIA(Esordio, DataInizio, Rimedio, Veterinario, Datafine) values
(25, '2019-06-06', 'Curofen', 2, '2019-06-16'),
(25, '2019-07-06', 'Bihor', 2, '2019-07-16'); 