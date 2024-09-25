begin transaction;

create type Strutturato as enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');
create type LavoroProgetto as enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management, Altro');
create type LavoroNonProgettuale as enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');
create type CausaAssenza as enum ('Chiusura Universitaria', 'Maternita, Malattia');
create domain PosInteger as integer
    default 0
    CHECK (value>=0);
create domain StringaM as varchar(100);
create domain NumeroOre as integer
    default 0
    CHECK (value >= 0 and value <= 8);
create domain Denaro as real
    default 0
    CHECK (value >= 0);


create table Persona (
  id PosInteger not null,
  nome StringaM not null,
  cognome StringaM not null,
  posizione strutturato not null,
  stipendio Denaro not null,
  PRIMARY KEY (id)
);

create table Progetto (
  id PosInteger not null,
  nome StringaM not null,
  inizio date not null,
  fine date not null,
  budget Denaro not null,
  PRIMARY KEY (id),
  UNIQUE (nome),
  CHECK (inizio < fine)
);

create table WP (
  progetto PosInteger not null,
  id PosInteger not null,  
  nome StringaM not null,
  inizio date not null,
  fine date not null,
  PRIMARY KEY (progetto, id),
  UNIQUE (progetto, nome),
  CHECK (inizio < fine),  
  FOREIGN KEY (progetto) references Progetto(id) 
);

create table AttivitaProgetto (
  id PosInteger not null,
  persona PosInteger not null,
  progetto PosInteger not null,
  wp PosInteger not null,
  giorno date not null,
  tipo LavoroProgetto not null,
  oreDurata NumeroOre not null,
  PRIMARY KEY (id),
  FOREIGN KEY (persona) references Persona(id)  ,
  FOREIGN KEY (progetto, wp) references WP(progetto, id)  
);

create table AttivitaNonProgettuale (
  id PosInteger not null,
  persona PosInteger not null,
  tipo LavoroNonProgettuale not null,
  giorno date not null,
  oreDurata NumeroOre not null,
  PRIMARY KEY (id),
  FOREIGN KEY (persona) references Persona(id)  
);

create table Assenza (
  id PosInteger not null,
  persona PosInteger not null,
  tipo CausaAssenza not null,
  giorno date not null,
  PRIMARY KEY (id),
  UNIQUE (persona, giorno),
  FOREIGN KEY (persona) references Persona(id)  
);




-- Definire in SQL le seguenti interrogazioni, in cui si chiedono tutti risultati distinti:
-- 1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome
-- ‘Pegasus’ ?
SELECT  WP.nome, WP.inizio, WP.fine
from WP, Progetto
where WP.progetto = Progetto.id and Progetto.nome = 'Pegasus'
-- 2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
-- una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
SELECT distinct s.nome, s.cognome, s.posizione
from AttivitaProgetto a, Persona s, Progetto p
where a.persona = s.id 
    and a.progetto = p.id 
    and p.nome = 'Pegasus'
ORDER by s.cognome desc

-- 3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
-- una attività nel progetto ‘Pegasus’ ?
SELECT *
from AttivitaProgetto a1, AttivitaProgetto a2, progetto p,
where a1.id
-- 4. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
-- fatto almeno una assenza per malattia?
SELECT distinct Persona.nome, Persona.cognome, Persona.posizione, Assenza.tipo
from Persona s, Progetto p, Assenza a
where s.posizione = 'Professore Ordinario' and a.tipo = 'Malattia'

-- 5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
-- fatto più di una assenza per malattia?
SELECT Persona.nome, Persona.cognome, Persona.posizione, Assenza.tipo
from Persona, Progetto, Assenza
where posizione = 'Professore Ordinario' and Assenza.tipo = 'Malattia'

-- 6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno
-- un impegno per didattica?
SELECT Persona.nome, Persona.cognome, Persona.posizione
from Persona, Progetto
where posizione = 'Ricercatore' and 

-- 7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un
-- impegno per didattica?
SELECT Persona.nome, Persona.cognome, Persona.posizione
from Persona, Progetto
where posizione = 'Ricercatore' and

-- 8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
-- attività progettuali che attività non progettuali?

-- 9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
-- attività progettuali che attività non progettuali? Si richiede anche di proiettare il
-- giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
-- entrambe le attività.

-- 10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
-- assenti e hanno attività progettuali?

-- 11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
-- assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
-- nome del progetto, la causa di assenza e la durata in ore della attività progettuale.

-- 12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?