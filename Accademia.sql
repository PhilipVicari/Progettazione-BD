create database Accademia

create type Strutturato as enum ('Ricercatore, Professore Associato, Professore Ordinario')
create type LavoroProgetto as enum ('Ricerca e Sviluppo, Dimostrazione, Management, Altro')
create type LavoroNonProgettuale as enum ('Didattica, Ricerca, Missione, Incontro Dipartimentale, Incontro Accademico, Altro')
create type CausaAssenza as enum ('Chiusura Universitaria, Maternita, Malattia')
create domain PosInteger as integer 
    default 0
    CHECK (value>=0)
create domain StringaM as varchar(100)
create domain NumeroOre as integer 
    default 0
    CHECK (value >= 0 and value <= 8)
create domain Denaro as real 
    default 0
    CHECK (value >= 0)


create table Persona (
  id PosInteger not null,
  nome StringaM not null,
  cognome StringaM not null,
  pos_strutturato not null,
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

--Quali sono i cognomi distinti di tutti gli strutturati?
SELECT distinct Persona.cognome
from Persona
where Persona.pos_strutturato = 'Strutturato'
--Quali sono i Ricercatori (con nome e cognome)?
SELECT Persona.nome, Persona.cognome
from Persona
where Persona.pos_strutturato = 'Ricercatore'
--Quali sono i Professori Associati il cui cognome comincia con la lettera ‘V’ ?
SELECT Persona.nome, Persona.cognome
from Persona
where Persona.pos_strutturato = 'Professore Associato' and cognome like 'V%'
--Quali sono i Professori (sia Associati che Ordinari) il cui cognome comincia con la lettera ‘V’ ?
SELECT Persona.nome, Persona.cognome
from Persona
where Persona.pos_strutturato = 'Professore' and cognome like 'V%'
--Quali sono i Progetti già terminati alla data odierna?

--Quali sono i nomi di tutti i Progetti ordinati in ordine crescente di data di inizio?
SELECT Progetto.nome
from Progetto
ORDER BY inizio ASC
--Quali sono i nomi dei WP ordinati in ordine crescente (per nome)?
SELECT WP.nome
from WP
ORDER BY nome ASC
--Quali sono (distinte) le cause di assenza di tutti gli strutturati?

--Quali sono (distinte) le tipologie di attività di progetto di tutti gli strutturati?

-- Quali sono i giorni distinti nei quali del personale ha effettuato attività non progettuali di tipo ‘Didattica’ ? Dare il risultato in ordine crescente.
SELECT distinct AttivitaNonProgettuale.giorno
from AttivitaNonProgettuale
where AttivitaNonProgettuale.tipo = 'Didattica'
ORDER BY giorno ASC