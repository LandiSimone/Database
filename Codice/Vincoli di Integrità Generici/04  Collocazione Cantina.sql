/*Le unità di uno stesso lotto vengono collocate su scaffali vicini tra loro*/
DROP TRIGGER IF EXISTS collocazione_cantina; 

DELIMITER $$ 
CREATE TRIGGER collocazione_cantina
BEFORE INSERT ON COLLOCAZIONE_CANTINA
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
    FROM COLLOCAZIONE_CANTINA CC
    WHERE CC.Scaffale=NEW.Scaffale
          AND CC.Cantina=NEW.Cantina;
    
    -- salvo la capacità dello scaffale

    SELECT SC.Capacita INTO capacita
    FROM SCAFFALE_CANTINA SC
    WHERE SC.Codice=NEW.Scaffale
          AND SC.Cantina=NEW.Cantina;
    
    -- controllo che lo scaffale non sia completo

    IF numero_unita=capacita THEN
        #scaffale completo
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Scaffale completo';
    END IF;

    -- conto se ho già inserito unità appartenenti al lotto del prodotto in cantina

    SELECT COUNT(*) INTO unita_precedenti
    FROM COLLOCAZIONE_CANTINA CC
         INNER JOIN
         UNITA_PRODOTTO UP
         ON CC.Unita=UP.Codice
    WHERE UP.Lotto=lotto;
    
    -- se ho già dei prodotti

    IF unita_precedenti>0 THEN
        BEGIN

        -- ricavo l'ultimo scaffale in cui ho inserito un prodotto appartenente al lotto

        SELECT MAX(CC.Scaffale) INTO scaffale_precedente
        FROM COLLOCAZIONE_CANTINA CC
             INNER JOIN
             UNITA_PRODOTTO UP
             ON CC.Unita=UP.Codice
        WHERE UP.Lotto=lotto;

        -- se l'ultimo scaffale è subito prima dello scaffale attuale controllo se è pieno

        IF NEW.Scaffale=scaffale_precedente+1 THEN
            BEGIN

            SELECT COUNT(*) INTO numero_unita
            FROM COLLOCAZIONE_CANTINA CC
            WHERE CC.Scaffale=scaffale_precedente
                  AND CC.Cantina=NEW.Cantina;
            
            SELECT Capacita INTO capacita
            FROM SCAFFALE_CANTINA SC
            WHERE SC.Codice=scaffale_precedente
                  AND SC.Cantina=NEW.Cantina;
            
            -- se non è completo non posso inserire il prodotto sul nuovo scaffale

            IF numero_unita<capacita THEN
            #scaffale precedente non ancora completo
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Scaffale precedente non ancora completo';
            END IF;
            END;

        -- se lo scaffale dell'ultimo inserimento non è quello precedente o lo stesso non posso inserire
        
        ELSEIF NEW.Scaffale<>scaffale_precedente THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT='Scaffale non valido';
        END IF;
        END;

    END IF;
END$$ 
DELIMITER ;





