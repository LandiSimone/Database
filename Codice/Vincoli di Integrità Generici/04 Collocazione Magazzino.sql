/*Le unità di uno stesso lotto vengono collocate su scaffali vicini tra loro*/
DROP TRIGGER IF EXISTS collocazione_magazzino;

DELIMITER $$ 
CREATE TRIGGER collocazione_magazzino
BEFORE INSERT ON COLLOCAZIONE_MAGAZZINO
FOR EACH ROW                                  
BEGIN 

    DECLARE unita_precedenti INTEGER DEFAULT 0;
    DECLARE numero_unita INTEGER DEFAULT 0;
    DECLARE capacita INTEGER DEFAULT 0;
    DECLARE lotto INTEGER DEFAULT 0;
    DECLARE scaffale_precedente INTEGER DEFAULT 0;
    
    SELECT UP.Lotto INTO lotto
    FROM UNITA_PRODOTTO UP
    WHERE UP.Codice=NEW.Unita;

    -- conto le unità presenti sullo scaffale in cui voglio inserire il prodotto

    SELECT COUNT(*) INTO numero_unita
    FROM COLLOCAZIONE_MAGAZZINO CC
    WHERE CC.Scaffale=NEW.Scaffale
          AND CC.Magazzino=NEW.Magazzino;
    
    -- salvo la capacità dello scaffale

    SELECT SM.Capacita INTO capacita
    FROM SCAFFALE_MAGAZZINO SM
    WHERE SM.Codice=NEW.Scaffale
          AND SM.Magazzino=NEW.Magazzino;
    
    -- controllo che lo scaffale non sia completo

    IF numero_unita=capacita THEN
        #scaffale completo
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Scaffale completo';
    END IF;

    -- conto se ho già inserito unità appartenenti al lotto del prodotto in cantina

    SELECT COUNT(*) INTO unita_precedenti
    FROM COLLOCAZIONE_MAGAZZINO CM
         INNER JOIN
         UNITA_PRODOTTO UP
         ON CM.Unita=UP.Codice
    WHERE UP.Lotto=lotto;
    
    -- se ho già dei prodotti

    IF unita_precedenti>0 THEN
        BEGIN

        -- ricavo l'ultimo scaffale in cui ho inserito un prodotto appartenente al lotto

        SELECT MAX(CM.Scaffale) INTO scaffale_precedente
        FROM COLLOCAZIONE_MAGAZZINO CM
             INNER JOIN
             UNITA_PRODOTTO UP
             ON CM.Unita=UP.Codice
        WHERE UP.Lotto=lotto;

        -- se l'ultimo scaffale è subito prima dello scaffale attuale controllo se è pieno

        IF NEW.Scaffale=scaffale_precedente+1 THEN
            BEGIN

            SELECT COUNT(*) INTO numero_unita
            FROM COLLOCAZIONE_MAGAZZINO CM
            WHERE CM.Scaffale=scaffale_precedente
                  AND CM.Magazzino=NEW.Magazzino;
            
            SELECT SM.Capacita INTO capacita
            FROM SCAFFALE_MAGAZZINO SM
            WHERE SM.Codice=scaffale_precedente
                  AND SM.Magazzino=NEW.Magazzino;
            
             -- se non è completo non posso inserire il prodotto sul nuovo scaffale

            IF numero_unita<capacita THEN
            #scaffale precedente non ancora completo
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Scaffale precedente non ancora completo';
            END IF;
            END;

            -- se lo scaffale dell'ultimo inserimento non è quello precedente o lo stesso non posso inserire

        ELSEIF NEW.Scaffale<>scaffale_precedente AND NEW.Scaffale<>scaffale_precedente THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Scaffale non valido';
        END IF;
        END;

    END IF;
END$$ 
DELIMITER ;



-- scaffale completo
insert into COLLOCAZIONE_MAGAZZINO values
(1,1,43);
-- inserimento buono
insert into COLLOCAZIONE_MAGAZZINO values
(2,1,43);
-- scaffale precedente non ancora completo
insert into COLLOCAZIONE_MAGAZZINO values
(3,1,44);
-- scaffale non valido
insert into COLLOCAZIONE_MAGAZZINO values
(4,1,44);


