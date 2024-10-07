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
    FOREIGN KEY (arrivo) references Aeroporto(codice),
    FOREIGN KEY (partenza) references Aeroporto(codice)
);
create table Aeroporto(
    codice CodiATA not null,
    nome StringaM not null,
    PRIMARY KEY (codice),
    FOREIGN KEY (codice) references LuogoAeroporto(Aeroporto)
);
create table LuogoAeroporto(
    Aeroporto CodiATA not null,
    citta StringaM not null,
    nazione StringaM not null,
    PRIMARY KEY (Aeroporto),
    FOREIGN KEY (Aeroporto) references Aeroporto(codice)
);
create table Compagnia(
    nome StringaM not null,
    annoFondazione PosInteger null,
    PRIMARY KEY(nome)
);


commit

--CIELO2
-- 1. Quante sono le compagnie che operano (sia in arrivo che in partenza) nei diversi aeroporti?
SELECT c.nome AS compagnia, COUNT(DISTINCT a.arrivo) + COUNT(DISTINCT a.partenza) AS numero_aeroporti
FROM Compagnia c
JOIN ArrPart a ON c.nome = a.comp
GROUP BY c.nome;
-- 2. Quanti sono i voli che partono dall’aeroporto ‘HTR’ e hanno una durata di almeno 100 minuti?
SELECT COUNT(DISTINCT ar.partenza) as num_voli
FROM ArrPart ar
JOIN Volo v on v.codice = ar.codice
WHERE ar.partenza = 'HTR' and v.durataMinuti >= 100
-- 3. Quanti sono gli aeroporti sui quali opera la compagnia ‘Apitalia’, per ogni nazione nella quale opera?
SELECT la.nazione, COUNT(DISTINCT a.codice) AS numero_aeroporti
FROM Compagnia c
JOIN ArrPart ap ON c.nome = ap.comp
JOIN Aeroporto a ON a.codice = ap.arrivo OR a.codice = ap.partenza
JOIN LuogoAeroporto la ON a.codice = la.aeroporto
WHERE c.nome = 'Apitalia'
GROUP BY la.nazione;
-- 4. Qual è la media, il massimo e il minimo della durata dei voli effettuati dalla compagnia ‘MagicFly’ ?
select avg(durataMinuti), max(durataMinuti), min(durataMinuti)
from Volo v
where v.comp = 'MagicFly'
-- 5. Qual è l’anno di fondazione della compagnia più vecchia che opera in ognuno degli aeroporti?
select c.annofondaz
from Compagnia c, ArrPart ar
join Aeroporto a on a.codice = ar.partenza and a.codice = ar.arrivo

-- 6. Quante sono le nazioni (diverse) raggiungibili da ogni nazione tramite uno o più voli?

-- 7. Qual è la durata media dei voli che partono da ognuno degli aeroporti?
-- 8. Qual è la durata complessiva dei voli operati da ognuna delle compagnie fondate a partire dal 1950?
-- 9. Quali sono gli aeroporti nei quali operano esattamente due compagnie?
-- 10. Quali sono le città con almeno due aeroporti?
-- 11. Qual è il nome delle compagnie i cui voli hanno una durata media maggiore di 6 ore?
-- 12. Qual è il nome delle compagnie i cui voli hanno tutti una durata maggiore di 100 minuti?






--CIELO 1
-- -- Quali sono i voli (codice e nome della compagnia) la cui durata supera le 3 ore?
-- select V.codice, V.comp
-- from Volo v
-- where v.durataMinuti >= '180'
-- -- Quali sono le compagnie che hanno voli che superano le 3 ore?
-- select distinct c.nome
-- from Compagnia c, Volo v
-- where v.durataMinuti > '180'
-- -- Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto con
-- -- codice ‘CIA’ ?
-- select distinct ar.comp, ar.codice
-- from ArrPart ar
-- where ar.partenza = 'CIA'

-- -- Quali sono le compagnie che hanno voli che arrivano all’aeroporto con codice
-- -- ‘FCO’ ?
-- select distinct v.comp
-- from volo v, ArrPart ar
-- where ar.arrivo = 'FCO'
-- -- Quali sono i voli (codice e nome della compagnia) che partono dall’aeroporto ‘FCO’
-- -- e arrivano all’aeroporto ‘JFK’ 
-- select distinct ar.comp, ar.codice
-- from ArrPart ar
-- where ar.partenza = 'FCO'
--     and ar.arrivo = 'JFK'

-- -- Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’ e atter-
-- -- rano all’aeroporto ‘JFK’?
-- select distinct ar.comp
-- from ArrPart ar
-- where ar.partenza = 'FCO'
--     and ar.arrivo = 'JFK'

-- -- Quali sono i nomi delle compagnie che hanno voli diretti dalla città di ‘Roma’ alla
-- -- città di ‘New York’ ?
-- select distinct ar.comp
-- from ArrPart ar
-- where ar.partenza = 'FCO' 
-- 	or ar.partenza = 'CIA'
--     and ar.arrivo = 'JFK'
-- -- Quali sono gli aeroporti (con codice IATA, nome e luogo) nei quali partono voli
-- -- della compagnia di nome ‘MagicFly’ ?
-- SELECT a.codice AS codice_iata, a.nome AS nome_aeroporto, la.citta, la.nazione
-- FROM ArrPart ap
-- JOIN Aeroporto a ON ap.partenza = a.codice
-- JOIN Compagnia c ON ap.comp = c.nome
-- JOIN LuogoAeroporto la ON a.codice = la.aeroporto
-- WHERE c.nome = 'MagicFly';
-- -- Quali sono i voli che partono da un qualunque aeroporto della città di ‘Roma’ e
-- -- atterrano ad un qualunque aeroporto della città di ‘New York’ ? Restituire: codice
-- -- del volo, nome della compagnia, e aeroporti di partenza e arrivo.

-- SELECT v.codice, c.nome AS compagnia, la1.aeroporto AS partenza, la2.aeroporto AS arrivo
-- FROM Volo v
-- JOIN ArrPart ap ON v.codice = ap.codice
-- JOIN Compagnia c ON v.comp = c.nome
-- JOIN LuogoAeroporto la1 ON ap.partenza = la1.aeroporto
-- JOIN LuogoAeroporto la2 ON ap.arrivo = la2.aeroporto
-- WHERE la1.citta = 'Roma' AND la2.citta = 'New York';


-- -- Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’, atter-
-- -- rano all’aeroporto ‘JFK’, e di cui si conosce l’anno di fondazione?
-- SELECT DISTINCT c.nome
-- FROM Compagnia c
-- JOIN Volo v ON c.nome = v.comp
-- JOIN ArrPart ap ON v.codice = ap.codice
-- WHERE ap.partenza = 'FCO' AND ap.arrivo = 'JFK';