USE master
GO

ALTER DATABASE Filmy SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

DROP DATABASE IF EXISTS Filmy
GO


CREATE DATABASE Filmy
GO

USE Filmy

DROP TABLE IF EXISTS FilmWytwornia
DROP TABLE IF EXISTS FilmAktor
DROP TABLE IF EXISTS FilmGatunek
DROP TABLE IF EXISTS FilmKraj
DROP TABLE IF EXISTS Gatunek
DROP TABLE IF EXISTS Film
DROP TABLE IF EXISTS Wytwornia
DROP TABLE IF EXISTS Aktor
DROP TABLE IF EXISTS Rezyser
DROP TABLE IF EXISTS Osoba
DROP TABLE IF EXISTS Kraj
GO

CREATE TABLE dbo.Gatunek(
	GatunekID int NOT NULL CONSTRAINT PK_Gatunek PRIMARY KEY IDENTITY,
	Gatunek nvarchar(100) NULL,
	GatunekEN nvarchar(100) NULL	
)
GO


CREATE TABLE dbo.Kraj(
	KrajID int NOT NULL CONSTRAINT PK_Kraj PRIMARY KEY IDENTITY,
	Kraj nvarchar(100) NOT NULL
)
GO




CREATE TABLE dbo.Wytwornia(
	WytworniaID int NOT NULL CONSTRAINT PK_Wytwornia PRIMARY KEY IDENTITY,
	Wytwornia nvarchar(150) NOT NULL
)
GO



CREATE TABLE dbo.Osoba(
	OsobaID int NOT NULL CONSTRAINT PK_Osoba  PRIMARY KEY IDENTITY,
	Imie nvarchar(100) NULL,
	Nazwisko nvarchar(100) NULL,
	ImieNazwisko nvarchar(200) NULL,
	KrajID int NULL  CONSTRAINT FK_Osoba_KrajID FOREIGN KEY REFERENCES Kraj(KrajID),
	DataUrodzenia datetime NULL,
	Zdjecie varbinary(50) NULL,
	Plec char(1) NULL,
	Wiek AS DATEDIFF(year, DataUrodzenia, GETDATE())
)
GO

CREATE TABLE dbo.Rezyser(
	RezyserID int NOT NULL CONSTRAINT PK_Rezyser  PRIMARY KEY IDENTITY,
	OsobaID int NULL  CONSTRAINT FK_Rezyser_OsobaID FOREIGN KEY REFERENCES Osoba(OsobaID)
)
GO


CREATE TABLE dbo.Aktor(
	AktorID int NOT NULL CONSTRAINT PK_Aktor PRIMARY KEY IDENTITY,
	OsobaID int NOT NULL CONSTRAINT FK_Aktor_OsobaID FOREIGN KEY REFERENCES Osoba(OsobaID)
)
GO


CREATE TABLE Film (
	FilmID int NOT NULL PRIMARY KEY IDENTITY,
	Tytul nvarchar(200) NULL,
	TytulOryginalny nvarchar(200) NULL,
	JezykOryginalny char(2),
	CzasTrwaniaMin int NULL,
	Opis nvarchar(max) NULL,
	Premiera date NULL,
	RezyseriaID int NULL CONSTRAINT FK_Film_ResyseriaID FOREIGN KEY REFERENCES Rezyser(RezyserID),
	Budzet int NULL,
	StronaWWW varchar(500),
	imoDBID varchar(15),
	imoDBVoteAvg decimal(5,1),
	imoDBVoteCount int,
	LatOdPremiery AS DATEDIFF(year, Premiera, GETDATE())
)
GO




CREATE TABLE FilmGatunek (
	FilmID int NOT NULL, 
	GatunekID int NOT NULL,
	CONSTRAINT PK_FilmGatunek PRIMARY KEY (FilmID, GatunekID),
	CONSTRAINT FK_FilmGatunek_FilmID FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
	CONSTRAINT FK_FilmGatunek_GatunekID FOREIGN KEY (GatunekID) REFERENCES Gatunek(GatunekID)
)




CREATE TABLE FilmAktor(
	ID int NOT NULL PRIMARY KEY IDENTITY, 
	FilmID int NOT NULL,
	AktorID int NOT NULL,
	NazwaRoli varchar(50) NOT NULL CONSTRAINT DF_FilmAktor_NazwaRoli DEFAULT '',
	CONSTRAINT FK_FilmAktor_Aktor FOREIGN KEY(AktorID) REFERENCES dbo.Aktor (AktorID),
	CONSTRAINT FK_FilmAktor_Film FOREIGN KEY(FilmID) REFERENCES dbo.Film (FilmID))
GO





CREATE TABLE FilmWytwornia (
	FilmID int NOT NULL, 
	WytworniaID int NOT NULL,
	CONSTRAINT PK_FilmWytwornia PRIMARY KEY (FilmID, WytworniaID),
	CONSTRAINT FK_FilmWytwornia_FilmID FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
	CONSTRAINT FK_FilmWytwornia_WytworniaID FOREIGN KEY (WytworniaID) REFERENCES Wytwornia(WytworniaID)
)




CREATE TABLE FilmKraj (
	FilmID int NOT NULL, 
	KrajID int NOT NULL,
	CONSTRAINT PK_FilmKraj PRIMARY KEY (FilmID, KrajID),
	CONSTRAINT FK_FilmKraj_FilmID FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
	CONSTRAINT FK_FilmKraj_KrajID FOREIGN KEY (KrajID) REFERENCES Kraj(KrajID)
)



ALTER DATABASE Filmy SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO

