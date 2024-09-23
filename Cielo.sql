begin transaction;

create domain PosInteger as integer
    default 0
    CHECK (value>=0);
create domain StringaM as varchar(100);
create domain CodiATA as char(3);

create table Volo(
    codice: PosInteger,
    comp: StringaM,
    durataMinuti: PosInteger,
    PRIMARY KEY (codice)
    FOREIGN KEY comp references Compagnia(nome)
    FOREIGN KEY (codice, comp)references ArrPart(codice, comp)
);
create table ArrPart(
    codice: PosInteger,
    comp: StringaM,
    arrivo: CodiATA,
    partenza: CodiATA,
    PRIMARY KEY (codice)
    FOREIGN KEY (codice, comp)references Volo(codice, comp)
    FOREIGN KEY arrivo references Aereoporto(codice)
    FOREIGN KEY partenza references Aereoporto(codice)
);
create table Aereoporto(
    codice: CodiATA,
    nome: StringaM,
    PRIMARY KEY (codice)
    FOREIGN KEY codice references LuogoAereoporto(Aereoporto)
);
create table LuogoAereoporto(
    aereoporto: CodiATA, 
    citta: StringaM,
    nazione: StringaM,
    PRIMARY KEY (aereoporto)
    FOREIGN KEY aereoporto references Aereoporto(codice)
);
create table Compagnia(
    nome: StringaM,
    annoFondazione: PosInteger,
    PRIMARY KEY(nome)
);