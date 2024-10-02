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
select distinct pe.id, pe.nome, pe.cognome
from Persona pe
join Assenza a ON pe.id = a.persona
where pe.posizione= 'Professore Ordinario'
	and a.tipo = 'Malattia'

-- 5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
-- fatto più di una assenza per malattia?
SELECT p.nome, p.cognome, p.posizione
FROM Persona p
JOIN Assenza a ON p.id = a.persona
WHERE p.posizione = 'Professore Ordinario' AND a.tipo = 'Malattia'
GROUP BY p.id, p.nome, p.cognome, p.posizione
HAVING COUNT(*) > 1;
-- 6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno
-- un impegno per didattica?
select distinct pe.id, pe.nome, pe.cognome
from Persona pe
join AttivitaNonProgettuale atn ON pe.id = atn.persona
where pe.posizione= 'Ricercatore'
	and atn.tipo = 'Didattica'
-- 7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un
-- impegno per didattica?
SELECT p.nome, p.cognome, p.posizione
FROM Persona p
JOIN AttivitaNonProgettuale atn ON p.id = atn.persona
WHERE p.posizione = 'Ricercatore' AND atn.tipo = 'Didattica'
GROUP BY p.id, p.nome, p.cognome, p.posizione
HAVING COUNT(*) > 1;
-- 8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
-- attività progettuali che attività non progettuali?
SELECT DISTINCT pe id, pe.nome, pe.cognome
FROM Persona pe
JOIN AttivitaProgetto atp ON pe.id = ap.persona
JOIN AttivitaNonProgettuale atn ON pe.id = atn.persona AND atp.giorno = atn.giorno;

-- 9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
-- attività progettuali che attività non progettuali? Si richiede anche di proiettare il
-- giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
-- entrambe le attività.

SELECT p.nome, p.cognome, ap.giorno, pr.nome, anp.tipo, ap.oreDurata, anp.oreDurata
FROM Persona p
JOIN AttivitaProgetto ap ON p.id = ap.persona
JOIN AttivitaNonProgettuale anp ON p.id = anp.persona AND ap.giorno = anp.giorno
JOIN Progetto pr ON ap.progetto = pr.id

-- 10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
-- assenti e hanno attività progettuali?
SELECT DISTINCT pe.id, pe.nome, pe.cognome
FROM Persona pe
JOIN AttivitaProgetto atp ON pe.id = atp.persona
join Assenza a on pe.id = a.persona and atp.giorno = a.giorno

-- 11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
-- assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
-- nome del progetto, la causa di assenza e la durata in ore della attività progettuale.
SELECT pe.nome, pe.cognome, atp.giorno, pr.nome, a.tipo, atp.oreDurata
FROM Persona pe
JOIN AttivitaProgetto atp ON pe.id = atp.persona
JOIN Progetto pr ON atp.progetto = pr.id
join Assenza a on pe.id = a.persona and atp.giorno = a.giorno
-- 12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?
select WP.nome
from WP
join Progetto pr on pr.id = WP.progetto
where WP.nome =


--Accademia6

-- 1. Quanti sono gli strutturati di ogni fascia?
SELECT posizione, count(*)
FROM persona
GROUP by posizione
-- 2. Quanti sono gli strutturati con stipendio ≥ 40000?
SELECT count(*) as numero
from persona p
where p.stipendio >= 40000
-- 3. Quanti sono i progetti già finiti che superano il budget di 50000? ****
select count(*)
from progetto pr, persona p
where p.stipendio >= 50000
  and pr.fine = "Current Date"
-- 4. Qual è la media, il massimo e il minimo delle ore delle attività relative al progetto
-- ‘Pegasus’ ?
select avg(oreDurata), max(oreDurata), min(oreDurata)
from progetto p, AttivitaProgetto ap
where ap.progetto = p.id
  and p.nome = 'Pegasus'
-- 5. Quali sono le medie, i massimi e i minimi delle ore giornaliere dedicate al progetto
-- ‘Pegasus’ da ogni singolo docente?
select p.id, p.nome, p.cognome, atp.persona, avg(oreDurata), max(oreDurata), min(oreDurata)
from AttivitaProgetto atp
join Persona p on atp.persona = p.id
where atp.progetto = '1'
GROUP by p.id, p.nome, p.cognome, atp.persona
-- 6. Qual è il numero totale di ore dedicate alla didattica da ogni docente?
select p.id, p.nome, p.cognome, SUM(anp.oreDurata) AS ore_didattica_totali
from AttivitaNonProgettuale anp
join Persona p on anp.persona = p.id
where anp.tipo = 'Didattica'
GROUP by p.id, p.nome, p.cognome, anp.oreDurata
-- 7. Qual è la media, il massimo e il minimo degli stipendi dei ricercatori?
select avg(stipendio), max(stipendio), min(stipendio)
from Persona p
where p.posizione = 'Ricercatore'
-- associati e dei professori ordinari?
select avg(stipendio), max(stipendio), min(stipendio)
from Persona p
group by posizione
-- 9. Quante ore ‘Ginevra Riva’ ha dedicato ad ogni progetto nel quale ha lavorato?
-- 10. Qual è il nome dei progetti su cui lavorano più di due strutturati?
-- 11. Quali sono i professori associati che hanno lavorato su più di un progetto?