USE DB142

--Query 1

SELECT ID, VAT, Name, StAddress, PhoneNumber 
FROM Customer


--Query 2

SELECT CardID, TransID
FROM Transac as T
WHERE T.TransDate >= '2017-05-12' AND T.TransDate <= '2017-05-18' 


--Query 3

SELECT C.ID, C.Name, AccountID 
FROM Customer as C, Account as A
WHERE C.ID = A.CustID


--Query 4

SELECT C.Name, C.PhoneNumber 
FROM Customer as C, Transac as T, Shop as S, Card as Ca
WHERE T.TransDate >= '2017-06-01' AND T.TransDate <= '2017-06-31' AND S.ShopLocation = '291' AND S.ShopID=T.ShopID AND Ca.CardID=T.CardID AND Ca.CustID = C.ID


--Query 5

SELECT CardID
FROM Card
WHERE ExpDate >= '2022-12-07' AND ExpDate <= '2023-01-07'


--Query 6

SELECT REPLACE(Interest, Interest, Interest-1)
FROM CARD


--Query 7

SELECT C.Name, C.VAT
FROM Customer as C, Account as A
WHERE BALANCE>10000 AND C.ID = A.CustID


--Query 8

SELECT SUM(Amount)
FROM Transac
WHERE YEAR(TransDate)='2017'
GROUP BY MONTH(TransDate)


--Query 9

SELECT C.Name, SUM(T.Amount)
FROM Customer as C, Transac as T, Card as Ca
WHERE YEAR(T.TransDate) = '2017' AND T.CardID = Ca.CardID AND Ca.CustID = C.ID
GROUP BY C.Name, MONTH(TransDate)


--Query 10

SELECT C.Name
FROM Customer as C, Transac as T, Card as Ca, Account as A
WHERE T.Amount > all(SELECT T.Amount FROM Transac) AND T.CardID = Ca.CardID AND Ca.CustID = C.ID


--Query 11

SELECT C.Name
FROM Customer as C, Shop as S, Transac as T, Card as Ca
WHERE T.ShopID = S.ShopID AND T.CardID = Ca.CardID AND Ca.CustID = C.ID
	AND CONTAINS(S.ShopID, '2019 AND 3121 AND 7181');


--Query 12

SELECT C.Name
FROM Transac as T, Customer as C, Card as Ca 
WHERE MONTH(T.TransDate)='06' AND YEAR(T.TransDate)='2017' AND Ca.CardID = T.CardID AND Ca.CustID = C.ID
GROUP BY C.Name
HAVING SUM(T.Amount)>50 AND COUNT(*)>5


--Query 13

SELECT DISTINCT C.ID, SUM(T.Amount)/(SUM(L.AvgSalary)*100) AS Percentage
FROM Customer as C, Location as L, Transac as T, Card as Ca 
WHERE YEAR(T.TransDate)='2017' AND Ca.CardID = T.CardID AND Ca.CustID = C.ID AND C.CustLoc = L.LocID
GROUP BY C.ID

--Query 14

-- Το Μεσο Ποσο αγορων για τον Ιουνιο του 2017
CREATE VIEW MA(MonthAvg) AS
	SELECT AVG(Amount)
	FROM Transac
	WHERE MONTH(TransDate)='06' AND YEAR(TransDate)='2017'

-- Οι αγορες του πελατη για τον Ιουνιο του 2017
CREATE VIEW CP(Name, CustPurch, Purchases) AS
	SELECT C.Name, SUM(T.Amount), COUNT(*)
	FROM Transac as T, Customer as C, Card as Ca
	WHERE T.CardID = Ca.CardID AND Ca.CustID=C.ID AND MONTH(TransDate)='06' AND YEAR(TransDate)='2017'
	GROUP BY C.Name 

SELECT CP.Name
FROM CP, MA
WHERE CP.CustPurch/CP.Purchases > MA.MonthAvg*3


--Query 15

-- Για καθε πελατη, οι συνολικες αγορες τον Ιουνιο του 2017
CREATE VIEW PJ17(CustID, Total) AS
	SELECT C.ID, SUM(T.Amount)
	FROM Customer as C, Transac as T, Card as Ca
	WHERE MONTH(T.TransDate)='06' AND YEAR(T.TransDate)='2017' AND Ca.CardID=T.CardID AND Ca.CustID=C.ID
	GROUP BY C.ID

-- Για καθε πελατη, οι συνολικες αγορες τον Ιουνιο του 2016
CREATE VIEW PJ16(CustID, Total) AS
	SELECT C.ID, SUM(T.Amount)
	FROM Customer as C, Transac as T, Card as Ca
	WHERE MONTH(T.TransDate)='06' AND YEAR(T.TransDate)='2016' AND Ca.CardID=T.CardID AND Ca.CustID=C.ID
	GROUP BY C.ID

SELECT PJ17.CustID
FROM PJ16, PJ17
WHERE PJ17.Total>PJ16.Total+(PJ16.Total*0.5)


--Query 16

-- Μεση Αγορα Πελατη πριν τον Μηνα 'x'
CREATE VIEW PreM17(Name, Average, Before) AS 
	SELECT C.Name, AVG(T.Amount), MONTH(T.TransDate)
	FROM Customer as C, Transac as T, Card as Ca
	WHERE MONTH(T.TransDate)<=MONTH(T.TransDate) AND Ca.CardID=T.CardID AND Ca.CustID=C.ID
	GROUP BY C.Name, MONTH(T.TransDate)

-- Μεση Αγορα Πελατη μετα τον Μηνα 'x'
CREATE VIEW PostM17(Name, Average, After) AS 
	SELECT C.Name, AVG(T.Amount), MONTH(T.TransDate)
	FROM Customer as C, Transac as T, Card as Ca
	WHERE MONTH(T.TransDate)>=MONTH(T.TransDate) AND Ca.CardID=T.CardID AND Ca.CustID=C.ID
	GROUP BY C.Name, MONTH(T.TransDate)

SELECT PreM17.Name
FROM PreM17
INNER JOIN PostM17 ON PostM17.Name=PreM17.Name
WHERE PostM17.Average>PreM17.Average AND PostM17.After=PreM17.Before


--Query 17

CREATE VIEW P1(CustID, Purch2017, Pay2017) AS
	SELECT C.ID, SUM(T.Amount), SUM(P.Ammount)
	FROM Customer as C, Transac as T, Payment as P, Card as Ca
	WHERE P.PaymentID=C.ID AND T.CardID=Ca.CardID AND Ca.CustID=C.ID
	GROUP BY C.ID
	HAVING SUM(T.Amount)<SUM(P.Ammount)

SELECT *
FROM P1