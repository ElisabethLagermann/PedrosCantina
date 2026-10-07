CREATE TABLE Medarbejder (
[MedarbejderId] INT Identity(1,1) PRIMARY KEY,
[Navn] NVARCHAR(50) NOT NULL,
[Telefon] VARCHAR(15) NOT NULL,
[Email] NVARCHAR(255) NOT NULL,
[Adresse] NVARCHAR(255) NOT NULL, 
[ErLeder] BIT NOT NULL DEFAULT 0
);

CREATE TABLE Maanedsplan (
[MaanedsplanId] INT Identity(10,10) PRIMARY KEY,
[Aar] int NOT NULL,
[Maaned] int NOT NULL,

UNIQUE (Aar, Maaned), -- Dette forhindrer, at der eksisterer to eller flere månedsplaner for samme måned og år.

CHECK (Maaned BETWEEN 1 AND 12) --Sørger for, at der kun bør eksistere 12 måneder op ét kalenderår.

);

CREATE TABLE Vagttype (
[VagttypeId] INT Identity(1,1) PRIMARY KEY,
[Navn] NVARCHAR(50) NOT NULL,
[StartTidspunkt] TIME(0) NOT NULL,
[SlutTidspunkt] TIME(0) NOT NULL
);

CREATE TABLE Vagt (
[VagtId] int Identity(1,1) PRIMARY KEY,
[MaanedsplanId] int FOREIGN KEY REFERENCES Maanedsplan(MaanedsplanId) NOT NULL,
[VagttypeId] int FOREIGN KEY REFERENCES Vagttype(VagttypeId) NOT NULL,
[DagPaaMaaned] int NOT NULL,

UNIQUE (MaanedsplanId, DagPaaMaaned, VagttypeId), --Dette forhindrer, at samme vagttype fx "Formiddag" oprettes to gange på den samme dato.

CHECK (DagPaaMaaned BETWEEN 1 AND 31) --Sørger for, at der kun bør eksistere op til 31 dage på én måned.

);

CREATE TABLE VagtTildeling (
[VagtTildelingId] int Identity(1,1),
[VagtId] int NOT NULL,
[MedarbejderId] int NOT NULL,

PRIMARY KEY (VagtTildelingId),

FOREIGN KEY(VagtId) REFERENCES Vagt(VagtId),
FOREIGN KEY(MedarbejderId) REFERENCES Medarbejder(MedarbejderId)
);

