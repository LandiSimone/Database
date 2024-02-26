SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

### TABELLE DATABASE ###33

-- DROP DATABASE Farmhouse;
-- CREATE DATABASE Farmhouse;

### Creazione Tabella Acqua ###

DROP TABLE IF EXISTS ACQUA;
CREATE TABLE ACQUA (
    Codice INT NOT NULL AUTO_INCREMENT,
    VitaminaB DOUBLE DEFAULT '0.0',
    VitaminaC DOUBLE DEFAULT '0.0',
    VitaminaH DOUBLE DEFAULT '0.0',
    Ferro DOUBLE DEFAULT '0.0',
    Calcio DOUBLE DEFAULT '0.0',
    Magnesio DOUBLE DEFAULT '0.0',
    Potassio DOUBLE DEFAULT '0.0',

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione tabella AGGIUNTA ###

DROP TABLE IF EXISTS AGGIUNTA;
CREATE TABLE AGGIUNTA (
    ServizioAggiuntivo CHAR(50) NOT NULL,
    Prenotazione INT NOT NULL,
    NumeroGiorni INT DEFAULT 1,

    PRIMARY KEY(ServizioAggiuntivo, Prenotazione),

    CONSTRAINT FK_ServizioAggiuntivo_Aggiunta
        FOREIGN KEY(ServizioAggiuntivo)
        REFERENCES SERVIZIO_AGGIUNTIVO(Nome)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Prenotazione_Aggiunta
        FOREIGN KEY(Prenotazione)
        REFERENCES PRENOTAZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

##### Creazione tabella AGRITURISMO #####
DROP TABLE IF EXISTS AGRITURISMO;
CREATE TABLE AGRITURISMO (
    Codice INT NOT NULL AUTO_INCREMENT,
    Citta CHAR(50) NOT NULL,
    NumeroTelefono VARCHAR(50) UNIQUE NOT NULL,
    Via CHAR(50) NOT NULL,
    
    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

##### Creazione Tabella ALLESTIMENTO ####
DROP TABLE IF EXISTS ALLESTIMENTO;
CREATE TABLE ALLESTIMENTO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Tipologia ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    NumeroCondizionatori INT NOT NULL,
    NumeroDispositiviIlluminazione INT NOT NULL,
    NumeroMangiatoie INT NOT NULL,
    NumeroAbbeveratoi INT NOT NULL,
    
    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella LOC ####
DROP TABLE IF EXISTS AREA;
CREATE TABLE AREA(
    Zona INT NOT NULL,
    Agriturismo INT NOT NULL,
    
    PRIMARY KEY(Zona,Agriturismo), 
    
    CONSTRAINT FK_Agriturismo_Area
        FOREIGN KEY (Agriturismo)
        REFERENCES AGRITURISMO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE=InnoDB       DEFAULT CHARSET = latin1;

#### Creazione tabella ATTIVITA ####
DROP TABLE IF EXISTS ATTIVITA;
CREATE TABLE ATTIVITA(
    Codice INT NOT NULL AUTO_INCREMENT,
    OraInizio TIME NOT NULL,
    Area INT NOT NULL,
    Agriturismo INT NOT NULL,
    OrarioRientro TIME NOT NULL,
    
    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Area_Attivita
        FOREIGN KEY(Area, Agriturismo)
        REFERENCES AREA(Zona, Agriturismo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
        
)   Engine=InnoDB   default charset = latin1;

#### Creazione tabella CANTINA ####
DROP TABLE IF EXISTS CANTINA;
CREATE TABLE CANTINA(
    Codice INT NOT NULL AUTO_INCREMENT,
    NumeroUnita INT DEFAULT 0,
    Agriturismo INT NOT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Agriturismo_Cantina
        FOREIGN KEY(Agriturismo)
            REFERENCES AGRITURISMO(Codice)
            ON UPDATE CASCADE
            ON DELETE CASCADE

)Engine=InnoDB default charset = latin1;

#### Creazione tabella DIPENDENTE ####
DROP TABLE IF EXISTS DIPENDENTE;
CREATE TABLE DIPENDENTE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Nome CHAR(50) NOT NULL,
    Cognome CHAR(50) NOT NULL,
        
    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella ESAME ####
DROP TABLE IF EXISTS ESAME;
CREATE TABLE ESAME(
    Codice INT NOT NULL AUTO_INCREMENT,
    Macchinario CHAR(50),
    Descrizione CHAR(200) NOT NULL,

    PRIMARY KEY(Codice) 

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella FORNITORE####
DROP TABLE IF EXISTS FORNITORE;
CREATE TABLE FORNITORE(
    PartitaIVA VARCHAR(50) NOT NULL,
    Indirizzo CHAR(50) NOT NULL,
    RagioneSociale CHAR(50) NOT NULL,
    Nome CHAR(50) NOT NULL,
    Cognome CHAR(50) NOT NULL,
    
    PRIMARY KEY(PartitaIVA)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella GUIDA #### 
DROP TABLE IF EXISTS GUIDA;
CREATE TABLE GUIDA(
    Codice VARCHAR(50) NOT NULL,
    Nome CHAR(100) NOT NULL,
    Cognome CHAR(100) NOT NULL,
    
    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione Tabella ESCURSIONE ####
DROP TABLE IF EXISTS ESCURSIONE;
CREATE TABLE ESCURSIONE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Guida VARCHAR(50) NOT NULL,
    Giorno ENUM ('Lunedi', 'Martedi', 'Mercoledi', 'Giovedi', 'Venerdi', 'Sabato', 'Domenica'),
    OraInizio TIME NOT NULL,
    Costo INT NOT NULL,
    
    PRIMARY KEY(Codice),

    CONSTRAINT FK_Guida_Escursione
        FOREIGN KEY(Guida)
        REFERENCES GUIDA(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella IMPIANTOCONDIZIONAMENTO ####
DROP TABLE IF EXISTS IMPIANTO_CONDIZIONAMENTO;
CREATE TABLE IMPIANTO_CONDIZIONAMENTO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Cantina INT NOT NULL,
    
    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Cantina_ImpiantoCondizionamento
        FOREIGN KEY (Cantina)
        REFERENCES CANTINA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione tabella Laboratorio ###
DROP TABLE IF EXISTS LABORATORIO;
CREATE TABLE LABORATORIO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Agriturismo INT NOT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Agriturismo_Laboratiorio
        FOREIGN KEY(Agriturismo)
        REFERENCES AGRITURISMO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella LATTE ####
DROP TABLE IF EXISTS LATTE;
CREATE TABLE LATTE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Grassi DOUBLE NOT NULL,
    Carboidrati DOUBLE NOT NULL,
    Proteine DOUBLE NOT NULL,
    Energia INT NOT NULL,
    
    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;
        
#### Creazione tabella LOCAZIONE ####
DROP TABLE IF EXISTS LOCAZIONE;
CREATE TABLE LOCAZIONE(
    Escursione INT NOT NULL,
    Area INT NOT NULL,
    Agriturismo INT NOT NULL,
    PeriodoSosta TIME DEFAULT NULL,
    
    PRIMARY KEY (Escursione, Area, Agriturismo),
    
    CONSTRAINT FK_Escursione_Locazione
        FOREIGN KEY(Escursione)
        REFERENCES ESCURSIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    
    CONSTRAINT FK_Area_Agriturismo_Locazione
        FOREIGN KEY(Area, Agriturismo)
        REFERENCES AREA(Zona, Agriturismo)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella LOTTO ####
DROP TABLE IF EXISTS LOTTO;
CREATE TABLE LOTTO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Data DATE NOT NULL,
    Scadenza DATE NOT NULL,
    Laboratorio INT NOT NULL,
    
    PRIMARY KEY(Codice),

    CONSTRAINT FK_Laboratorio_Lotto
        FOREIGN KEY(Laboratorio)
        REFERENCES LABORATORIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella LAVORATORE ####
DROP TABLE IF EXISTS LAVORATORE;
CREATE TABLE LAVORATORE(
    Dipendente INT NOT NULL,
    Lotto INT NOT NULL,

    PRIMARY KEY(Dipendente, Lotto),

    CONSTRAINT FK_Dipendente_Lavoratore
        FOREIGN KEY(Dipendente)
        REFERENCES DIPENDENTE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Lotto_Lavoratore
        FOREIGN KEY(Lotto)
        REFERENCES LOTTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella MAGAZZINO ####
DROP TABLE IF EXISTS MAGAZZINO;
CREATE TABLE MAGAZZINO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Agriturismo INT NOT NULL,
    NumeroUnita INT DEFAULT 0,
    
    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Agriturismo_Magazzino
        FOREIGN KEY(Agriturismo)
        REFERENCES AGRITURISMO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella MUNGITRICE ####
DROP TABLE IF EXISTS MUNGITRICE;
CREATE TABLE MUNGITRICE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Area INT NOT NULL,
    Agriturismo INT NOT NULL,
    Modello VARCHAR(50) NOT NULL,
    Marca CHAR(50),
    
    PRIMARY KEY(Codice),

    CONSTRAINT FK_Area_Agriturismo_Mungitrice
        FOREIGN KEY(Area,Agriturismo)
        REFERENCES AREA(Zona,Agriturismo)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;


### Creazione Tabella Foraggio ###
DROP TABLE IF EXISTS FORAGGIO;
CREATE TABLE FORAGGIO (
    Codice INT NOT NULL AUTO_INCREMENT,
    Fibre INT DEFAULT NULL,
    Energia INT DEFAULT NULL,
    Proteine INT DEFAULT NULL,
    Glucidi INT DEFAULT NULL,
    ErbaMedica INT DEFAULT 0,
    Lupinella INT DEFAULT 0,
    FruttaVaria INT DEFAULT 0,
    Avena INT DEFAULT 0,
    Tipo ENUM ('Fresco', 'Fieno', 'Insilato'),

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella ClienteRegistrato ###
DROP TABLE IF EXISTS CLIENTE_REGISTRATO;
CREATE TABLE CLIENTE_REGISTRATO (
    Codice INT NOT NULL AUTO_INCREMENT,
    Nome CHAR(50) NOT NULL,
    Cognome CHAR(50) NOT NULL,
    Indirizzo CHAR(50) NOT NULL,
    CodiceDocumento CHAR(50) UNIQUE NOT NULL,
    CodiceCartaCredito CHAR(50) UNIQUE NOT NULL,
    AccountPayPal CHAR(50) DEFAULT NULL,

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella ClienteNonRegistrato ###
DROP TABLE IF EXISTS CLIENTE_NON_REGISTRATO;
CREATE TABLE CLIENTE_NON_REGISTRATO (
    Codice INT NOT NULL AUTO_INCREMENT,
    CodiceCartaCredito CHAR(50) DEFAULT NULL,
    AccountPayPal CHAR(50) DEFAULT NULL,

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Patologia ###
DROP TABLE IF EXISTS PATOLOGIA;
CREATE TABLE PATOLOGIA (
    Codice INT NOT NULL,
    
    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella CARENZA ###
DROP TABLE IF EXISTS CARENZA;
CREATE TABLE CARENZA (
    Patologia INT NOT NULL,
    Elemento CHAR(50) UNIQUE NOT NULL,

    PRIMARY KEY (Patologia),

    CONSTRAINT FK_Patologia_Carenza
        FOREIGN KEY(Patologia)
        REFERENCES PATOLOGIA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Prenotazione ###
DROP TABLE IF EXISTS PRENOTAZIONE;
CREATE TABLE PRENOTAZIONE (
    Codice INT NOT NULL AUTO_INCREMENT,
    Data DATETIME NOT NULL,

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella PrenotazioneAttivitÃ  ###
DROP TABLE IF EXISTS PRENOTAZIONE_ATTIVITA;
CREATE TABLE PRENOTAZIONE_ATTIVITA (
    Prenotazione INT NOT NULL,
    Escursione INT NOT NULL,

    PRIMARY KEY(Prenotazione, Escursione),

    CONSTRAINT FK_Prenotazione_PrenotazioneAttivita
        FOREIGN KEY(Prenotazione)
        REFERENCES PRENOTAZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Escursione_PrenotazioneAttivita
        FOREIGN KEY(Escursione)
        REFERENCES ESCURSIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella PrenotazioneCR ###
DROP TABLE IF EXISTS PRENOTAZIONE_CR; 
CREATE TABLE PRENOTAZIONE_CR (
    Prenotazione INT NOT NULL,
    Cliente INT NOT NULL,

    PRIMARY KEY(Prenotazione, Cliente),

    CONSTRAINT FK_Prenotazione_PrenotazioneCR
        FOREIGN KEY(Prenotazione)
        REFERENCES PRENOTAZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Cliente_PrenotazioneCR
        FOREIGN KEY(Cliente)
        REFERENCES CLIENTE_REGISTRATO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella PrenotazioneCNR ###
DROP TABLE IF EXISTS PRENOTAZIONE_CNR; 
CREATE TABLE PRENOTAZIONE_CNR (
    Prenotazione INT NOT NULL,
    Cliente INT NOT NULL,

    PRIMARY KEY(Prenotazione, Cliente),

    CONSTRAINT FK_Prenotazione_PrenotazioneCNR
        FOREIGN KEY(Prenotazione)
        REFERENCES PRENOTAZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Cliente_PrenotazioneCNR
        FOREIGN KEY(Cliente)
        REFERENCES CLIENTE_NON_REGISTRATO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Prodotto ###
DROP TABLE IF EXISTS PRODOTTO;
CREATE TABLE PRODOTTO (
    Nome CHAR(50) NOT NULL,
    TipoPasta ENUM ('Molle', 'Dura'),
    Deperibilita  INT NOT NULL,
    ZonaOrigine CHAR(50) DEFAULT NULL,
    Stagionatura INT DEFAULT NULL,

    PRIMARY KEY(Nome)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Recinzione ###
DROP TABLE IF EXISTS RECINZIONE;
CREATE TABLE RECINZIONE (
    Codice INT NOT NULL AUTO_INCREMENT,
    LatitudineInizio DOUBLE(7,5) NOT NULL,
    LatitudineFine DOUBLE(7,5) NOT NULL,
    LongitudineInizio DOUBLE(7,5) NOT NULL,
    LongitudineFine DOUBLE(7,5) NOT NULL,
    Tipo ENUM ('Mobile', 'Fissa') DEFAULT NULL,

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella DELIMITAZIONE ####
DROP TABLE IF EXISTS DELIMITAZIONE;
CREATE TABLE DELIMITAZIONE (
    Area INT NOT NULL,
    Agriturismo INT NOT NULL,
    Recinzione INT NOT NULL,
    PRIMARY KEY(Area, Agriturismo, Recinzione),
    
    CONSTRAINT FK_Area_Agriturismo_Delimitazione
        FOREIGN KEY(Area, Agriturismo)
        REFERENCES AREA(Zona, Agriturismo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Recinzione_Delimitazione
        FOREIGN KEY(Recinzione)
        REFERENCES RECINZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Ricetta ###
DROP TABLE IF EXISTS RICETTA;
CREATE TABLE RICETTA (
    Fase INT NOT NULL,
    Prodotto CHAR(50) NOT NULL,
    DurataIdeale INT NOT NULL,
    TemperaturaIdeale INT NOT NULL,
    TempoRiposoIdeale INT NOT NULL,
    Descrizione CHAR(200) DEFAULT ' ',

    PRIMARY KEY(Fase, Prodotto),

    CONSTRAINT FK_Prodotto_Ricetta
        FOREIGN KEY(Prodotto)
        REFERENCES PRODOTTO(Nome)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Rimedio ###
DROP TABLE IF EXISTS RIMEDIO;
CREATE TABLE RIMEDIO (
    Nome CHAR(50) NOT NULL,
    Tipo ENUM ('Farmaco', 'Integratore'),
    Posologia FLOAT NOT NULL,
    Descrizione CHAR(200) DEFAULT ' ',
    Durata INT DEFAULT NULL,
    
    PRIMARY KEY(Nome)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella ScaffaleCantina ###
DROP TABLE IF EXISTS SCAFFALE_CANTINA;
CREATE TABLE SCAFFALE_CANTINA (
    Codice INT NOT NULL,
    Cantina INT NOT NULL,
    Capacita INT NOT NULL,

    PRIMARY KEY(Codice, Cantina),

    CONSTRAINT FK_Cantina_SscaffaleCantina
        FOREIGN KEY(Cantina)
        REFERENCES CANTINA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella ScaffaleMagazzino ###
DROP TABLE IF EXISTS SCAFFALE_MAGAZZINO;
CREATE TABLE SCAFFALE_MAGAZZINO (
    Codice INT NOT NULL ,
    Magazzino INT NOT NULL,
    Capacita INT NOT NULL,

    PRIMARY KEY(Codice, Magazzino),

    CONSTRAINT FK_Magazzino_ScaffaleMagazzino
        FOREIGN KEY(Magazzino)
        REFERENCES MAGAZZINO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella ServizioAggiuntivo ###
DROP TABLE IF EXISTS SERVIZIO_AGGIUNTIVO;
CREATE TABLE SERVIZIO_AGGIUNTIVO (
    Nome CHAR(50) NOT NULL,
    Costo INT NOT NULL,
    Descrizione CHAR(200) DEFAULT ' ',

    PRIMARY KEY(Nome)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;


### Creazione Tabella Silos ###
DROP TABLE IF EXISTS SILOS;
CREATE TABLE SILOS (
    Codice INT NOT NULL AUTO_INCREMENT,
    QuantitaMax INT NOT NULL,
    Agriturismo INT NOT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Agriturismo_Silos
        FOREIGN KEY(Agriturismo)
        REFERENCES AGRITURISMO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione Tabella COMPOSIZIONE ####
DROP TABLE IF EXISTS COMPOSIZIONE;
CREATE TABLE COMPOSIZIONE(
    Silos INT NOT NULL,
    Lotto INT NOT NULL,
    DataInvio DATETIME NOT NULL,
    
    PRIMARY KEY(Silos, Lotto),
    
    CONSTRAINT FK_Silos_Composizione
        FOREIGN KEY(Silos)
        REFERENCES SILOS(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Lotto_Composizione
        FOREIGN KEY(Lotto)
        REFERENCES LOTTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB default charset = latin1;

### Creazione Tabella Stalla ###
DROP TABLE IF EXISTS STALLA;
CREATE TABLE STALLA (
    Codice INT NOT NULL AUTO_INCREMENT,
    Zona INT NOT NULL,
    Agriturismo INT NOT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Zona_Stalla
        FOREIGN KEY(Zona)
        REFERENCES AREA(Zona)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Agriturismo_Stalla
        FOREIGN KEY(Agriturismo)
        REFERENCES AGRITURISMO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Stanza ###
DROP TABLE IF EXISTS STANZA;
CREATE TABLE STANZA (
    Codice INT NOT NULL,
    Agriturismo INT NOT NULL,
    LettiSingoli INT NOT NULL,
    LettiMatrimoniali INT NOT NULL,
    Tipo ENUM ('Semplice', 'Suite'),
    Costo INT NOT NULL,

    PRIMARY KEY(Codice, Agriturismo),

    CONSTRAINT FK_Agriturismo_Stanza
        FOREIGN KEY(Agriturismo)
        REFERENCES AGRITURISMO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella PrenotazioneStanza ###
DROP TABLE IF EXISTS PRENOTAZIONE_STANZA;
CREATE TABLE PRENOTAZIONE_STANZA (
    Prenotazione INT NOT NULL,
    Stanza INT NOT NULL,
    Agriturismo INT NOT NULL,
    DataArrivo DATE NOT NULL,
    DataPartenza DATE NOT NULL,

    PRIMARY KEY(Prenotazione, Stanza, Agriturismo),

    CONSTRAINT FK_Prenotazione_PrenotazioneStanza
        FOREIGN KEY(Prenotazione)
        REFERENCES PRENOTAZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Stanza_PrenotazioneStanza
        FOREIGN KEY(Stanza)
        REFERENCES STANZA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Agriturismo_PrenotazioneStanza
        FOREIGN KEY(Agriturismo)
        REFERENCES STANZA(Agriturismo)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella StatoImpianto ###
DROP TABLE IF EXISTS STATO_IMPIANTO;
CREATE TABLE STATO_IMPIANTO (
    Orario DATETIME,
    Impianto INT NOT NULL,
    Ventilazione INT NOT NULL,
    Temperatura INT NOT NULL,
    Umidita INT NOT NULL,

    PRIMARY KEY(Orario, Impianto),

    CONSTRAINT FK_ImpiantoCondizionamento_StatoImpianto
        FOREIGN KEY(Impianto)
        REFERENCES IMPIANTO_CONDIZIONAMENTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella StatoSilos ###
DROP TABLE IF EXISTS STATO_SILOS;
CREATE TABLE STATO_SILOS (
    Orario DATETIME,
    Silos INT NOT NULL,
    LivelloRiempimento INT DEFAULT NULL,

    PRIMARY KEY(Orario, Silos),

    CONSTRAINT FK_Silos_StatoSilos
        FOREIGN KEY(Silos)
        REFERENCES SILOS(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione tabella Unità di Prodotto ###
DROP TABLE IF EXISTS UNITA_PRODOTTO;
CREATE TABLE UNITA_PRODOTTO (
    Codice INT NOT NULL AUTO_INCREMENT,
    Prodotto CHAR(50) NOT NULL,
    Lotto INT NOT NULL,
    Peso FLOAT DEFAULT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Lotto_UnitaDiProdotto
        FOREIGN KEY(Lotto)
        REFERENCES LOTTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT KF_Prodotto_UnitaDiProdotto
        FOREIGN KEY(Prodotto)
        REFERENCES PRODOTTO(Nome)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella ProcessoProduttivo ###
DROP TABLE IF EXISTS PROCESSO_PRODUTTIVO; 
CREATE TABLE PROCESSO_PRODUTTIVO (
    Unita INT NOT NULL,
    Fase INT NOT NULL,
    DurataEffettiva INT NOT NULL,
    TemperaturaEffettiva INT NOT NULL,
    TempoRiposoEffettivo INT NOT NULL,

    PRIMARY KEY(Unita, Fase),

    CONSTRAINT FK_Unita_ProcessoProduttivo
        FOREIGN KEY(Unita)
        REFERENCES UNITA_PRODOTTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Veterinario ###
DROP TABLE IF EXISTS VETERINARIO;
CREATE TABLE VETERINARIO (
    Codice INT NOT NULL AUTO_INCREMENT,
    Nome CHAR(50) NOT NULL,
    Cognome CHAR(50) NOT NULL,

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Riproduzione ###
DROP TABLE IF EXISTS RIPRODUZIONE;
CREATE TABLE RIPRODUZIONE (
    Codice INT NOT NULL AUTO_INCREMENT,
    Stato ENUM ('Successo', 'Insuccesso'),
    Orario DATETIME,
    Veterinario INT NOT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Veterinario_Riproduzione
        FOREIGN KEY(Veterinario)
        REFERENCES VETERINARIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
    
)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella SchedaGestazione ###
DROP TABLE IF EXISTS SCHEDA_GESTAZIONE;
CREATE TABLE SCHEDA_GESTAZIONE (
    Codice INT NOT NULL AUTO_INCREMENT,
    CodiceRiproduzione INT NOT NULL,
    Veterinario INT NOT NULL,
    StatoGravidanza ENUM ('In corso', 'Terminata', 'Interrotta'),

    PRIMARY KEY(Codice),

    CONSTRAINT FK_CodiceRiproduzione_SchedaGestazione
        FOREIGN KEY(CodiceRiproduzione)
        REFERENCES RIPRODUZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Veterinario_SchedaGestazione
        FOREIGN KEY(Veterinario)
        REFERENCES VETERINARIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione tabella Controllo ###
DROP TABLE IF EXISTS CONTROLLO;
CREATE TABLE CONTROLLO (
    Codice INT NOT NULL AUTO_INCREMENT,
    SchedaGestazione INT NOT NULL,
    Veterinario INT NOT NULL,
    DataProgrammata DATE NOT NULL,
    DataEffettiva DATE DEFAULT NULL,
    Esito ENUM ('Positivo', 'Negativo') DEFAULT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_SchedaGestazione_Controllo
        FOREIGN KEY(SchedaGestazione)
        REFERENCES SCHEDA_GESTAZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Veterinario_Controllo
        FOREIGN KEY(Veterinario)
        REFERENCES VETERINARIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella ESAMEDIAGNOSTICO ####
DROP TABLE IF EXISTS ESAME_DIAGNOSTICO;
CREATE TABLE ESAME_DIAGNOSTICO(
    Esame INT NOT NULL,
    Controllo INT NOT NULL,
    Data DATE NOT NULL,
    
    PRIMARY KEY(Esame, Controllo),
    
    CONSTRAINT FK_Controllo_EsameDiagnostico
        FOREIGN KEY(Controllo)
        REFERENCES CONTROLLO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Esame_EsameDiagnostico
        FOREIGN KEY(Esame)
        REFERENCES ESAME(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Dimensione ###
DROP TABLE IF EXISTS DIMENSIONE;
CREATE TABLE DIMENSIONE (
    Specie ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    NumeroAnimali INT NOT NULL,
    Larghezza INT NOT NULL,
    Lunghezza INT NOT NULL,
    Altezza INT NOT NULL,

    PRIMARY KEY(Specie, NumeroAnimali)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella DisturboComportamentale ###
DROP TABLE IF EXISTS DISTURBO_COMPORTAMENTALE;
CREATE TABLE DISTURBO_COMPORTAMENTALE (
    Patologia INT NOT NULL,
    Nome CHAR(50) NOT NULL,

    PRIMARY KEY(Patologia),

    CONSTRAINT FK_Patologia_DisturboComportamentale
        FOREIGN KEY(Patologia)
        REFERENCES PATOLOGIA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Lesione ###
DROP TABLE IF EXISTS LESIONE;
CREATE TABLE LESIONE (
    Patologia INT NOT NULL,
    ParteCorpo CHAR(50) NOT NULL,
    Tipologia ENUM ('Cutanea', 'Strappo', 'Stiramento', 'Frattura') NOT NULL,

    PRIMARY KEY(Patologia),

    CONSTRAINT FK_Patologia_Lesione
        FOREIGN KEY(Patologia)
        REFERENCES PATOLOGIA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella OrarioPasti ###
DROP TABLE IF EXISTS ORARIO_PASTI;
CREATE TABLE ORARIO_PASTI (
    Codice INT NOT NULL AUTO_INCREMENT,
    PrimoPasto INT NOT NULL,
    SecondoPasto INT NOT NULL,
    TerzoPasto INT NOT NULL,

    PRIMARY KEY(Codice)

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella LOCALE ####
DROP TABLE IF EXISTS LOCALE;
CREATE TABLE LOCALE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Pavimentazione CHAR(50),
    OrientazioneFinestre ENUM('N','S','O','E') NOT NULL,
    Larghezza INT NOT NULL,
    Altezza INT NOT NULL,
    Lunghezza INT NOT NULL,
    Allestimento INT NOT NULL,
    Stalla INT NOT NULL,
    Specie ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    AnimaliMax INT NOT NULL,
    OrarioPasti INT NOT NULL,
    
    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Allestimento_Locale
        FOREIGN KEY(Allestimento)
        REFERENCES ALLESTIMENTO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
        
    CONSTRAINT FK_Stalla_Locale
        FOREIGN KEY(Stalla)
        REFERENCES STALLA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Specie_Locale
        FOREIGN KEY(Specie)
        REFERENCES DIMENSIONE(Specie)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_AnimaliMax_Locale_Specie
        FOREIGN KEY(Specie, AnimaliMax)
        REFERENCES DIMENSIONE(Specie, NumeroAnimali)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    
    CONSTRAINT FK_OrarioPasti_Locale
        FOREIGN KEY(OrarioPasti)
        REFERENCES ORARIO_PASTI(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella DISPOSITIVOILLUMINAZIONE ###
DROP TABLE IF EXISTS DISPOSITIVO_ILLUMINAZIONE;
CREATE TABLE DISPOSITIVO_ILLUMINAZIONE (
    Codice INT NOT NULL AUTO_INCREMENT,
    Tipologia ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    Locale INT NOT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Locale_DispositivoIlluminazione
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE 
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Sensori ###
DROP TABLE IF EXISTS SENSORI;
CREATE TABLE SENSORI (
    Orario DATETIME,
    Locale INT NOT NULL,
    Azoto INT DEFAULT NULL,
    Metano INT DEFAULT NULL,
    LivelloSporcizia ENUM ('Pulito', 'Basso', 'Medio', 'Alto'),
    Intervento ENUM ('Richiesto', 'Effettuato'),

    PRIMARY KEY(Orario, Locale),

    CONSTRAINT FK_Locale_Sensori
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella MANGIATOIA ####
DROP TABLE IF EXISTS MANGIATOIA;
CREATE TABLE MANGIATOIA(
    Codice INT NOT NULL AUTO_INCREMENT,
    Tipologia ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    Foraggio INT NOT NULL,
    Locale INT NOT NULL,
    
    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Foraggio_Mangiatoia
        FOREIGN KEY(Foraggio)
        REFERENCES FORAGGIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    
    CONSTRAINT FK_Locale_Mangiatoia
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella StatoMangiatoia ###
DROP TABLE IF EXISTS STATO_MANGIATOIA;
CREATE TABLE STATO_MANGIATOIA (
    Orario DATETIME,
    Mangiatoia INT NOT NULL,
    ForaggioResiduo INT DEFAULT NULL,

    PRIMARY KEY(Orario, Mangiatoia),

    CONSTRAINT FK_Mangiatoia_StatoMangiatoia
        FOREIGN KEY(Mangiatoia)
        REFERENCES MANGIATOIA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella MISURA ####
DROP TABLE IF EXISTS MISURA;
CREATE TABLE MISURA(
    Orario DATETIME,
    Locale INT NOT NULL,
    Temperatura DOUBLE NOT NULL,
    Umidita DOUBLE NOT NULL,
    
    PRIMARY KEY(Orario, Locale),
    
    CONSTRAINT FK_Locale_Misura
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione Tabella CONDIZIONATORE ####
DROP TABLE IF EXISTS CONDIZIONATORE;
CREATE TABLE CONDIZIONATORE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Tipologia ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    Locale INT NOT NULL,
   
    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Locale_Condizionatore
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE 
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella ANIMALE #####
DROP TABLE IF EXISTS ANIMALE; 
CREATE TABLE ANIMALE(
    Codice INT NOT NULL AUTO_INCREMENT,
    Sesso ENUM('M','F') NOT NULL,
    Specie ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    Famiglia CHAR(50) NOT NULL,
    Razza CHAR(50) NOT NULL,
    DataNascita DATE NOT NULL,
    Altezza INT NOT NULL,
    Peso INT NOT NULL,
    Locale INT NOT NULL,
    Padre INT DEFAULT NULL,
    Madre INT DEFAULT NULL,


    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Locale_Animale
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Padre_Animale
        FOREIGN KEY(Padre)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT FK_Madre_Animale
        FOREIGN KEY(Madre)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE SET NULL

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Visita ###
DROP TABLE IF EXISTS VISITA;
CREATE TABLE VISITA (
    Codice INT NOT NULL AUTO_INCREMENT,
    Animale INT NOT NULL,
    Data DATE NOT NULL,
    Veterinario INT NOT NULL,
    MassaMagra INT DEFAULT NULL, 
    MassaGrassa INT DEFAULT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Animale_Visita
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_Veterinario_Visita
        FOREIGN KEY(Veterinario)
        REFERENCES VETERINARIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella INDICATORIOGGETTIVI ####
DROP TABLE IF EXISTS INDICATORI_OGGETTIVI;
CREATE TABLE INDICATORI_OGGETTIVI(
    Visita INT NOT NULL,
    SpessoreZoccolo DOUBLE DEFAULT NULL,
    PressioneIntraoculare DOUBLE DEFAULT NULL,
    GlobuliBianchi INT DEFAULT NULL,
    GlobuliRossi DOUBLE DEFAULT NULL,
    Emoglobina DOUBLE DEFAULT NULL,
    Piastrine INT DEFAULT NULL,
    Lipasi DOUBLE DEFAULT NULL,
    Amilasi DOUBLE DEFAULT NULL,
    PressioneMinima INT DEFAULT NULL,
    PressioneMassima INT DEFAULT NULL,
    Colesterolo DOUBLE DEFAULT NULL,
    ALP DOUBLE DEFAULT NULL,
    AST DOUBLE DEFAULT NULL,

    PRIMARY KEY(Visita),
    
    CONSTRAINT FK_Visita_IndicatoriOggettivi
        FOREIGN KEY(Visita)
        REFERENCES VISITA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella INDICISALUTE ####
DROP TABLE IF EXISTS INDICI_SALUTE;
CREATE TABLE INDICI_SALUTE(
    Visita INT NOT NULL,
    LivelloRespirazione INT,
    TipologiaRespirazione CHAR(50),
    LucentezzaPelo INT,
    LivelloDeambulazione INT,
    LivelloVigilanza INT,
    LivelloIdratazione INT,
    
    PRIMARY KEY(Visita),
    
    CONSTRAINT FK_Visita_IndiciSalute
        FOREIGN KEY(Visita)
        REFERENCES VISITA(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Vendita ###
DROP TABLE IF EXISTS VENDITA;
CREATE TABLE VENDITA (
    Animale INT NOT NULL,
    PartitaIVA VARCHAR(50) NOT NULL,
    DataArrivo DATE DEFAULT NULL,
    DataAcquisto DATE NOT NULL,

    PRIMARY KEY(Animale, PartitaIVA),

    CONSTRAINT FK_Animale_Vendita
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_PartitaIVA_Vendita
        FOREIGN KEY(PartitaIVA)
        REFERENCES FORNITORE(PartitaIVA)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Tentativo
DROP TABLE IF EXISTS TENTATIVO;
CREATE TABLE TENTATIVO (
    Animale INT NOT NULL,
    CodiceRiproduzione INT NOT NULL,

    PRIMARY KEY(Animale, CodiceRiproduzione),

    CONSTRAINT FK_Animale_Tentativo
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_CodiceRiproduzione_Tentativo
        FOREIGN KEY(CodiceRiproduzione)
        REFERENCES RIPRODUZIONE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Svolgimento ###
DROP TABLE IF EXISTS SVOLGIMENTO;
CREATE TABLE SVOLGIMENTO (
    Attivita INT NOT NULL,
    Locale INT NOT NULL,

    PRIMARY KEY(Attivita, Locale),

    CONSTRAINT FK_Attivita_Svolgimento
        FOREIGN KEY(Attivita)
        REFERENCES ATTIVITA(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Locale_Svolgimento
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Quarantena ###
DROP TABLE IF EXISTS QUARANTENA;
CREATE TABLE QUARANTENA (
    Codice INT NOT NULL AUTO_INCREMENT,
    Animale INT NOT NULL,
    DataInizio DATE NOT NULL,
    DataFine DATE DEFAULT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Animale_Quarantena
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Posizione ###
DROP TABLE IF EXISTS POSIZIONE;
CREATE TABLE POSIZIONE (
    Animale INT NOT NULL,
    Orario TIME,
    Latitudine DOUBLE(7,5) NOT NULL,
    Longitudine DOUBLE(7,5) NOT NULL,

    PRIMARY KEY(Animale, Orario),

    CONSTRAINT FK_Animale_Posizione
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella ESORDIO ####
DROP TABLE IF EXISTS ESORDIO;
CREATE TABLE ESORDIO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Patologia INT NOT NULL,
    Animale INT NOT NULL,
    DataEsordio DATE NOT NULL,
    Entita INT DEFAULT 0,
    DataGuarigione DATE DEFAULT NULL,
    
    PRIMARY KEY(Codice),

    CONSTRAINT FK_Patologia_Esordio
        FOREIGN KEY(Patologia)
        REFERENCES PATOLOGIA(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Animale_Esordio
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella Terapia ###
DROP TABLE IF EXISTS TERAPIA;
CREATE TABLE TERAPIA (
    Codice INT NOT NULL AUTO_INCREMENT,
    Esordio INT NOT NULL,
    DataInizio DATE NOT NULL,
    Rimedio CHAR(50) NOT NULL,
    Veterinario INT NOT NULL,
    DataFine DATE DEFAULT NULL,

    PRIMARY KEY(Codice),

    CONSTRAINT FK_Esordio_Terapia
        FOREIGN KEY(Esordio)
        REFERENCES ESORDIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Rimedio_Terapia
        FOREIGN KEY(Rimedio)
        REFERENCES RIMEDIO(Nome)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Veterinario_Terapia
        FOREIGN KEY(Veterinario)
        REFERENCES VETERINARIO(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella MUNGITURA ####
DROP TABLE IF EXISTS MUNGITURA;
CREATE TABLE MUNGITURA(
    Animale INT NOT NULL,
    Orario DATETIME,
    Quantita INT NOT NULL,
    Mungitrice INT NOT NULL,
    Latte INT NOT NULL,
    Silos INT NOT NULL,
    
    PRIMARY KEY(Animale, Orario),
    
    CONSTRAINT FK_Animale_Mungitura
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Mungitrice_Mungitura
        FOREIGN KEY(Mungitrice)
        REFERENCES MUNGITRICE(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Latte_Mungitura
        FOREIGN KEY(Latte)
        REFERENCES LATTE(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    
    CONSTRAINT FK_Silos_Mungitura
        FOREIGN KEY(Silos)
        REFERENCES SILOS(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella CONTRIBUZIONE ####
DROP TABLE IF EXISTS CONTRIBUZIONE;
CREATE TABLE CONTRIBUZIONE(
    Lotto INT NOT NULL,
    Animale INT NOT NULL,
    
    PRIMARY KEY(Lotto, Animale),
    
    CONSTRAINT FK_Lotto_Contribuzione
        FOREIGN KEY(Lotto)
        REFERENCES LOTTO(Codice)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,

    CONSTRAINT FK_Animale_Contribuzione
        FOREIGN KEY(Animale)
        REFERENCES ANIMALE(Codice)
        ON UPDATE NO ACTION 
        ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione Tabella ABBEVERATOIO ####
DROP TABLE IF EXISTS ABBEVERATOIO; 
CREATE TABLE ABBEVERATOIO (
    Codice INT NOT NULL AUTO_INCREMENT,
    Tipologia ENUM('Bovino', 'Ovino', 'Caprino') NOT NULL,
    Locale INT NOT NULL,
    Acqua INT NOT NULL, 

    PRIMARY KEY(Codice),
    
    CONSTRAINT FK_Locale_Abbeveratoio
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    CONSTRAINT FK_Acqua_Abbeveratoio
        FOREIGN KEY(Acqua)
        REFERENCES ACQUA(Codice)
        ON UPDATE CASCADE
        ON DELETE NO ACTION #Un tipo di acqua non può essere rimosso mentre è sempre in un abbeveratoio
        
)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella StatoAbbeveratoio ###
DROP TABLE IF EXISTS STATO_ABBEVERATOIO;
CREATE TABLE STATO_ABBEVERATOIO (
    Orario DATETIME,
    Abbeveratoio INT NOT NULL,
    AcquaResidua INT DEFAULT NULL,

    PRIMARY KEY(Orario, Abbeveratoio),

    CONSTRAINT FK_Abbeveratoio_StatoAbbeveratoio
        FOREIGN KEY(Abbeveratoio)
        REFERENCES ABBEVERATOIO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

### Creazione Tabella COORDINATE ###
DROP TABLE IF EXISTS COORDINATE;
CREATE TABLE COORDINATE (
    Locale INT NOT NULL,
    LatitudineMin DOUBLE NOT NULL,
    LongitudineMin DOUBLE NOT NULL,
    LatitudineMax DOUBLE NOT NULL,
    LongitudineMax DOUBLE NOT NULL,

    PRIMARY KEY(Locale),

    CONSTRAINT FK_Locale_Coordinate
        FOREIGN KEY(Locale)
        REFERENCES LOCALE(Codice)
        ON UPDATE CASCADE 
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione Tabella COLLOCAZIONECANTINA ####
DROP TABLE IF EXISTS COLLOCAZIONE_CANTINA;
CREATE TABLE COLLOCAZIONE_CANTINA(
    Scaffale INT NOT NULL,
    Cantina INT NOT NULL,
    Unita INT NOT NULL,
    DataCollocazione DATE NOT NULL,
    
    PRIMARY KEY(Scaffale, Cantina, Unita),
    
    CONSTRAINT FK_Scaffale_CollocazioneCantina
        FOREIGN KEY(Scaffale)
        REFERENCES SCAFFALE_CANTINA(Codice)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,
        
    CONSTRAINT FK_Cantina_CollocazioneCantina
        FOREIGN KEY(Cantina)
        REFERENCES SCAFFALE_CANTINA(Cantina)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Unita_CollocazioneCantina
        FOREIGN KEY(Unita)
        REFERENCES UNITA_PRODOTTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella COLLOCAZIONEMAGAZZINO ####
DROP TABLE IF EXISTS COLLOCAZIONE_MAGAZZINO;
CREATE TABLE COLLOCAZIONE_MAGAZZINO(
    Scaffale INT NOT NULL,
    Magazzino INT NOT NULL,
    Unita INT NOT NULL,

    PRIMARY KEY(Scaffale, Magazzino, Unita),
    
    CONSTRAINT FK_Scaffale_CollocazioneMagazzino
        FOREIGN KEY(Scaffale)
        REFERENCES SCAFFALE_MAGAZZINO(Codice)
        ON UPDATE CASCADE 
        ON DELETE NO ACTION,
        
    CONSTRAINT FK_Cantina_CollocazioneMagazzino
        FOREIGN KEY(Magazzino)
        REFERENCES SCAFFALE_MAGAZZINO(Magazzino)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,

    CONSTRAINT FK_Unita_CollocazioneMagazzino
        FOREIGN KEY(Unita)
        REFERENCES UNITA_PRODOTTO(Codice)
        ON UPDATE CASCADE
        ON DELETE CASCADE

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;

#### Creazione tabella PAGAMENTO ####
DROP TABLE IF EXISTS PAGAMENTO;
CREATE TABLE PAGAMENTO(
    Codice INT NOT NULL AUTO_INCREMENT,
    Prenotazione INT NOT NULL,
    TipoPagamento ENUM('Carta', 'Contanti', 'PayPal'),
    Orario DATETIME,
    Importo DOUBLE NOT NULL,
    
    PRIMARY KEY(Codice),

    CONSTRAINT FK_Prenotazione_Pagamento
    	FOREIGN KEY(Codice)
    	REFERENCES PRENOTAZIONE(Codice)
    	ON UPDATE NO ACTION
    	ON DELETE NO ACTION

)   ENGINE = InnoDB     DEFAULT CHARSET = latin1;