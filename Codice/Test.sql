### OPERAZIONE 1: PRENOTAZIONE_CNR

CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Suite')
CALL soggiorno_cnr('1234567812345678', '2019-12-01', '2019-12-05', 001, 'Semplice')

### OPERAZIONE 2: NUOVO ANIMALE
# a buon fine
CALL gravidanza (7, 'F', "Frisona", current_date(), 100, 50, current_date(), 1, 5, 25, 7, NULL, 4, 2, 7, 8);
#riproduzione = insuccesso
CALL gravidanza (2, 'F', "Frisona", current_date(), 100, 50, current_date(), 1, 5, 25, 7, NULL, 4, 2, 7, 8);
#gravidanza = interrotta
CALL gravidanza (4, 'F', "Frisona", current_date(), 100, 50, current_date(), 1, 5, 25, 7, NULL, 4, 2, 7, 8);

### OPERAZIONE 3: SCHEDA MEDICA

CALL scheda_medica (002);

### OPERAZIONE 4: CONTROLLO ATTIVITA

CALL controllo_attivita(001);
CALL controllo_attivita(002);

### OPERAZIONE 5: STATO LOCALI

CALL stato_locale(001);

### OPERAZIONE 6: RITIRO PRODOTTI

CALL animali_quarantena(001);

### OPERAZIONE 7: PRODOTTI STAGIONATI

CALL prodotti_stagionati(001);

### OPERAZIONE 8: 

CALL numero_unita(001);


######## ANALYTICS #########

### ANALYTIC 1: COMPORTAMENTO ANIMALI

CALL comportamento_degli_animali(001,001);

### ANALITYC 2: CONTROLLO QUALITA PROCESSO

CALL qualita_lotto(18);

### ANALYTIC 3: TRACCIABILITA DI FILIERA

CALL qualita_prodotto (3);

######## RIDONDANZE ########

### NUMERO UNITA

SELECT*
FROM CANTINA

SELECT* 
FROM MAGAZZINO

### CONTRIBUZIONE

insert into MUNGITURA values
(6, '2019-11-25 12:00:00', 5, 01, 01, 01),
(7, '2019-11-25 12:05:00', 5, 01, 01, 01),
(8, '2019-11-25 12:10:00', 5, 01, 01, 01),
(9, '2019-11-25 12:15:00', 5, 01, 01, 01),
(10, '2019-11-25 12:20:00', 5, 01, 01, 01);

insert into COMPOSIZIONE values
(01, 13, '2019-11-22');

-- ATTIVARE TRIGGER

insert into COMPOSIZIONE values
(01, 14, '2019-11-26');


######## VINCOLI ########

### VINCOLO 1: INTERVENTO PULIZIA

insert into SENSORI(Orario,Locale,Azoto,Metano,LivelloSporcizia) values
('2019-11-25 00:00:00',2,85,50,'Basso'),
('2019-11-25 00:00:00',3,50,80,'Basso'),
('2019-11-25 00:00:00',4,50,50,'Alto');

### VINCOLO 2: GRAVIDANZA INTERROTTA

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

### VINCOLO 3: INSERIMENTO QUARANTENA
insert into ESORDIO(Patologia, Animale, DataEsordio, Entita, DataGuarigione) values
(18, 33, '2019-05-05', 9, NULL);
insert into TERAPIA(Esordio, DataInizio, Rimedio, Veterinario, Datafine) values
(25, '2019-06-06', 'Curofen', 2, '2019-06-16'),
(25, '2019-07-06', 'Bihor', 2, '2019-07-16'); 

### VINCOLO 4: COLLOCAZIONE MAGAZZINO
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

### VINCOLO 5: SPECIE LOCALE
insert into ANIMALE(Sesso, Specie, Famiglia, Razza, DataNascita, Altezza, Peso, Locale, Padre, Madre) values
('M', 'Caprino', 'Bovidi', 'Caprone', '2019-10-10', 60, 70, 1, NULL, NULL);










