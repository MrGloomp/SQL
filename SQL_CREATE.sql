
USE "DB142";
	

CREATE TABLE Customer (
	ID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(50),
	StAddress VARCHAR(100),
	VAT INT,
	PhoneNumber INT
	)

CREATE TABLE Account (
	AccountID INT NOT NULL PRIMARY KEY,
	Balance MONEY,
	DateCreated DATE,
	Department VARCHAR(50),
	)

CREATE TABLE Savings (
	AccountID INT NOT NULL PRIMARY KEY,
	InterestRate DECIMAL
	)

CREATE TABLE Checking (
	AccountID INT NOT NULL PRIMARY KEY,
	Overdraft MONEY
	)

CREATE TABLE Location (
	LocID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(40),
	LocPopulation INT,
	AvgSalary DECIMAL
	)

CREATE TABLE Card (
	CardID INT NOT NULL PRIMARY KEY,
	PrintDate DATE,
	ExpDate DATE,
	CreditCeiling INT,
	Interest DECIMAL,
	Balance MONEY
	)

CREATE TABLE Shop (
	ShopID INT NOT NULL PRIMARY KEY,
	Name VARCHAR(50),
	ServiceType INT CHECK (ServiceType > 0),
	ShopLocation VARCHAR(50)
	)

CREATE TABLE Transac (
	TransID INT NOT NULL PRIMARY KEY,
	Amount MONEY,
	TransDate DATETIME,
	ShopID INT,
	ShopPoS INT
	)

CREATE TABLE Payment (
	PaymentID INT NOT NULL,
	PaymentNumber INT,
	PaymentDate DATETIME,
	Amount MONEY
	PRIMARY KEY(PaymentID, PaymentNumber)
	)

ALTER TABLE Shop
	ALTER COLUMN ShopLocation INT;

ALTER TABLE Shop
	ADD CONSTRAINT Sh_L FOREIGN KEY(ShopLocation) REFERENCES Location(LocID)

ALTER TABLE Account
	ADD CONSTRAINT Bl_P CHECK(Balance>0)
	
ALTER TABLE Card
	ADD CONSTRAINT CC_P CHECK(CreditCeiling>0);
ALTER TABLE Card
	ADD CONSTRAINT In_P CHECK(Interest>0);
ALTER TABLE Card
	ADD CONSTRAINT Bl_P_C CHECK(Balance>0)

ALTER TABLE Payment
	ADD CONSTRAINT Am_P CHECK(Ammount>0)

ALTER TABLE Savings
	ADD CONSTRAINT Sa_Acc FOREIGN KEY(AccountID) REFERENCES Account(AccountID)
ALTER TABLE Checking
	ADD CONSTRAINT Ch_Acc FOREIGN KEY(AccountID) REFERENCES Account(AccountID)

ALTER TABLE Customer
	ADD CONSTRAINT VAT_Un UNIQUE(VAT)

ALTER TABLE Payment
	ADD CONSTRAINT PN_P CHECK(PaymentNumber>0)
ALTER TABLE Payment
	ADD CONSTRAINT Am_P CHECK(Ammount>0)

ALTER TABLE Transac
	ADD CONSTRAINT FK_Sh FOREIGN KEY(ShopID) REFERENCES Shop(ShopID)
