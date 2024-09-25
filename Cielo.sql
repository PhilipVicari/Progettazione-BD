begin transaction;

create domain PosInteger as integer
    default 0
    CHECK (value>=0);
create domain StringaM as varchar(100);
create domain CodiATA as char(3);

create table Volo(
    codice PosInteger not null,
    comp StringaM not null,
    durataMinuti PosInteger not null,
    PRIMARY KEY (codice),
    FOREIGN KEY comp references Compagnia(nome),
    FOREIGN KEY (codice, comp)references ArrPart(codice, comp)
);
create table ArrPart(
    codice PosInteger not null,
    comp StringaM not null,
    arrivo CodiATA not null,
    partenza CodiATA not null,
    PRIMARY KEY (codice),
    FOREIGN KEY (codice, comp)references Volo(codice, comp),
    FOREIGN KEY (arrivo) references Aereoporto(codice),
    FOREIGN KEY (partenza) references Aereoporto(codice)
);
create table Aereoporto(
    codice CodiATA not null,
    nome StringaM not null,
    PRIMARY KEY (codice),
    FOREIGN KEY (codice) references LuogoAereoporto(Aereoporto)
);
create table LuogoAereoporto(
    aereoporto CodiATA not null,
    citta StringaM not null,
    nazione StringaM not null,
    PRIMARY KEY (aereoporto),
    FOREIGN KEY (aereoporto) references Aereoporto(codice)
);
create table Compagnia(
    nome StringaM not null,
    annoFondazione PosInteger null,
    PRIMARY KEY(nome)
);


commit

-- Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?
select V.codice, V.comp
from Volo v
where v.durataMinuti >= '180'
-- Quali sono le compagnie che hanno voli che superano le 3 ore?
select distinct c.nome
from Compagnia c, Volo v
where v.durataMinuti > '180'
-- Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto con
-- codice ‘CIA’ ?
select distinct ar.comp, ar.codice
from ArrPart ar
where ar.partenza = 'CIA'

-- Quali sono le compagnie che hanno voli che arrivano all’aeroporto con codice
-- ‘FCO’ ?
select distinct v.comp
from volo v, ArrPart ar
where ar.arrivo = 'FCO'
-- Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto ‘FCO’
-- e arrivano all’aeroporto ‘JFK’ 
select distinct ar.comp, ar.codice
from ArrPart ar
where ar.partenza = 'FCO'
    and ar.arrivo = 'JFK'

-- Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’ e atter-
-- rano all’aeroporto ‘JFK’?
select distinct ar.comp
from ArrPart ar
where ar.partenza = 'FCO'
    and ar.arrivo = 'JFK'

-- Quali sono i nomi delle compagnie che hanno voli diretti dalla città di ‘Roma’ alla
-- città di ‘New York’ ?
select distinct ar.comp
from ArrPart ar
where ar.partenza = 'FCO' 
	or ar.partenza = 'CIA'
    and ar.arrivo = 'JFK'
-- Quali sono gli aeroporti (con codice IATA, nome e luogo) nei quali partono voli
-- della compagnia di nome ‘MagicFly’ ?