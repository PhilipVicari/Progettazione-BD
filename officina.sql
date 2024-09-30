create table Nazione (
    nome: varchar not null,
    primary key nome
);

create table Regione(
    nome: varchar not null,
    Nazione varchar not null,
    primary key(nome, Nazione),
    foreign key (Nazione) references Nazione(nome)
);

create table Citta (
    nome: varchar not null,
    Regione varchar not null,
    Nazione varchar not null,
    primary key(nome, Nazione),
    foreign key (Regione, Nazione) references Regione(nome, Nazione)
);
go
create table Veicolo(
    targa: varchar not null,
    immatricolazione: integer not null,
    primary key (targa)
);

create table Modello(
    nome: varchar not null,
    Veicolo varchar not null,
    primary key (nome, Veicolo),
    foreign key (Veicolo) references Veicolo(nome)
);

create table Marca (
    nome: varchar not null,
    Modello varchar not null,
    Veicolo varchar not null,
    primary key(nome, Veicolo),
    foreign key (Modello, Veicolo) references Modello(nome, Veicolo)
);

create table TipoVeicolo (
    nome: varchar not null,
    Marca varchar not null,
    Modello varchar not null,
    Veicolo varchar not null,
    primary key(nome, Veicolo),
    foreign key (Modello) references Modello(nome, Nazione)
);
create table Riparazione(
    riconsegna 
    codice integer not null
    primary key(codice)
);

create table Officina(
    nome: varchar not null
    indirizzo: Indirizzo
    id: integer not null
    primary key(id)
    foreign key 
);