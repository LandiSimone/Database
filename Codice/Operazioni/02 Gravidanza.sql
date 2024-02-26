DROP PROCEDURE IF EXISTS nuovo_animale;

DELIMITER $$

CREATE PROCEDURE nuovo_animale(IN sesso CHAR(50),
                               IN specie CHAR(50),
                               IN famiglia CHAR(50),
                               IN razza CHAR(50),
                               IN datanascita DATE, 
                               IN altezza INT,
                               IN peso INT,
                               IN locale INT,
                               IN padre INT,
                               IN madre INT)
BEGIN
	INSERT INTO ANIMALE (Sesso,Specie,Famiglia,Razza,DataNascita,Altezza,Peso,Locale,Padre,Madre) 
	VALUES (sesso,specie,famiglia,razza,datanascita,altezza,peso,locale,padre,madre);

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS nuova_visita;

DELIMITER $$

CREATE PROCEDURE nuova_visita(IN animale INT,
							                IN datavisita DATE,
                              IN veterinario INT,
                              IN massamagra INT,
                              IN massagrassa INT)
BEGIN
	INSERT INTO VISITA (Animale,Data,Veterinario,MassaMagra,MassaGrassa) 
	VALUES (animale,datavisita,veterinario,massamagra,massagrassa);

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS nuova_misurazione;

DELIMITER $$

CREATE PROCEDURE nuova_misurazione(IN visita INT,
								                   IN livellorespiarazione INT,
                                   IN tipologiarespirazione CHAR(50),
                                   IN lucentezzapelo INT,
                                   IN livellodeambulazione INT,
                                   IN livellovigilanza INT,
                                   IN livelloidratazione INT)
BEGIN
	INSERT INTO INDICI_SALUTE (Visita,LivelloRespirazione,TipologiaRespirazione,LucentezzaPelo,LivelloDeambulazione,LivelloVigilanza,LivelloIdratazione) 
	VALUES (visita,livellorespirazione,tipologiarespirazione,lucentezzapelo,livellodeambulazione,livellovigilanza,livelloidratazione);

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS gravidanza;

DELIMITER $$

CREATE PROCEDURE gravidanza(IN codice INT,
							IN sesso CHAR,
							IN razza CHAR(50),
                            IN datanascita DATE,
                            IN altezza INT,
                            IN peso INT,
                            IN datavisita DATE,
                            IN veterinario INT,
                            IN massamagra INT,
                            IN massagrassa INT,
                            IN livellorespirazione INT,
                            IN tipologiarespirazione CHAR(50),
                            IN lucentezzapelo INT,
                            IN livellodeambulazione INT,
                            IN livellovigilanza INT,
                            IN livelloidratazione INT)
BEGIN
	
	  DECLARE esito_riproduzione CHAR(50) DEFAULT 'Insuccesso'; 
    DECLARE esito_gravidanza CHAR(50) DEFAULT 'Interrotta';
	  DECLARE padre INT DEFAULT NULL;
    DECLARE madre INT DEFAULT NULL;
    DECLARE agriturismo INT DEFAULT NULL;
    DECLARE specie INT DEFAULT NULL;
    DECLARE nuovo_locale INT DEFAULT NULL;
    DECLARE famiglia CHAR(50) DEFAULT NULL;

    SELECT R.Stato INTO esito_riproduzione
    FROM RIPRODUZIONE R
    WHERE R.Codice=codice;
    
    SELECT SG.StatoGravidanza INTO esito_gravidanza
    FROM SCHEDA_GESTAZIONE SG
    WHERE SG.CodiceRiproduzione=codice;

    IF esito_riproduzione='Insuccesso' OR esito_gravidanza='Interrotta' THEN 
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = "Impossibile inserire un nuovo animale, la gravidanza non è andata a buon fine";
    END IF;
    
    -- trovo il padre

    SELECT A.Codice INTO padre
    FROM  TENTATIVO T
		      INNER JOIN 
          ANIMALE A
          ON T.Animale=A.Codice
	  WHERE T.CodiceRiproduzione=codice
		    AND A.Sesso='M';
    
    -- trovo la madre

    SELECT A.Codice INTO madre
    FROM  TENTATIVO T
		      INNER JOIN 
          ANIMALE A
          ON T.Animale=A.Codice
	  WHERE T.CodiceRiproduzione=codice
		    AND A.Sesso='F';
    
    -- ricavo la specie dell'animale

    SELECT A.Specie INTO specie
    FROM  ANIMALE A
	  WHERE A.Codice = madre;
       
    -- ricavo la famiglia dell'animale

	  SELECT A.Famiglia INTO famiglia
    FROM  ANIMALE A
    WHERE A.Codice = madre;
    
    -- ricavo l'agriturismo della madre

    SELECT S.Agriturismo INTO agriturismo
    FROM ANIMALE A
		     INNER JOIN
         LOCALE L
         ON A.Locale=L.Codice
         INNER JOIN
         STALLA S
         ON L.Stalla=S.Codice
	WHERE A.Codice=madre;
    

  SELECT L.Codice INTO nuovo_locale
  FROM ANIMALE A
		   INNER JOIN
       LOCALE L
       ON A.Locale=L.Codice
       INNER JOIN
       STALLA S
       ON L.Stalla=S.Codice
	WHERE L.Specie=specie
		  AND S.Agriturismo=agriturismo
	GROUP BY L.Codice
    HAVING COUNT(*) <= ALL(SELECT COUNT(*)
						               FROM ANIMALE A1
							                  INNER JOIN 
							                  LOCALE L1
							                  ON A1.Locale=L1.Codice
							                  INNER JOIN
							                  STALLA S1
							                  ON L1.Stalla=S1.Codice
						               WHERE L1.Specie=specie
								                AND S1.Agriturismo=agriturismo
						               GROUP BY L1.Codice)
	LIMIT 1;
    
    -- inserisco il nuovo animale
		CALL nuovo_animale(sesso,specie,famiglia,razza,datanascita,altezza,peso,nuovo_locale,padre,madre);

    -- inserisco la visita
    CALL nuova_visita(LAST_INSERT_ID(), datavisita, veterinario, massamagra, massagrassa);
        
    -- inserisco la misurazione 
    CALL nuova_misurazione(LAST_INSERT_ID(), livellorespirazione, tipologiarespirazione, lucentezzapelo, livellodeambulazione, livellovigilanza, livelloidratazione);


END $$
DELIMITER ;


# a buon fine
CALL gravidanza (7, 'F', "Frisona", current_date(), 100, 50, current_date(), 1, 5, 25, 7, NULL, 4, 2, 7, 8);
#riproduzione = insuccesso
CALL gravidanza (2, 'F', "Frisona", current_date(), 100, 50, current_date(), 1, 5, 25, 7, NULL, 4, 2, 7, 8);
#gravidanza = interrotta
CALL gravidanza (4, 'F', "Frisona", current_date(), 100, 50, current_date(), 1, 5, 25, 7, NULL, 4, 2, 7, 8);
