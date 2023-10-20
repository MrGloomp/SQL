USE DB142

--(1) Trigger on Transaction

CREATE TRIGGER Purchase_Check
ON Transac FOR INSERT AS
	BEGIN
	SET NOCOUNT ON;

	DECLARE @P_Sum MONEY
	SET @P_Sum = (SELECT inserted.Amount + Card.Balance FROM inserted, Card WHERE inserted.CardID = Card.CardID)

	DECLARE @Check MONEY
	SET @Check = (SELECT Balance FROM Account)

	IF @P_Sum > @Check
	BEGIN
		ROLLBACK TRANSACTION
	END
	END


--(2) Stored Procedure

CREATE PROCEDURE Calculate 
	@card INT,
	@month INT
AS
	BEGIN
	SET NOCOUNT ON;

	DECLARE @Check1 INT
	SET @Check1 = (SELECT CardID FROM Card)
	DECLARE @Check2 INT
	SET @Check2 = (SELECT MONTH(TransDate) FROM Transac) 

	IF @card LIKE @Check1
		IF @month LIKE @Check2
			BEGIN
				DECLARE @P1 INT
				SET @P1 = 1*(SELECT SUM(T.Amount) FROM Transac as T WHERE MONTH(T.TransDate) = @Check2 AND DAY(T.TransDate) <= 10)/100
				PRINT @P1
			END
			BEGIN
				DECLARE @P2 INT
				SET @P2 = 2*(SELECT SUM(T.Amount) FROM Transac as T WHERE MONTH(T.TransDate) = @Check2 AND DAY(T.TransDate) > 10 AND DAY(T.TransDate) <= 20)/100
				PRINT @P2
			END
			BEGIN
				DECLARE @P3 INT
				SET @P3 = 3*(SELECT SUM(T.Amount) FROM Transac as T WHERE MONTH(T.TransDate) = @Check2 AND DAY(T.TransDate) > 20)/100
				PRINT @P3
			END
	END
 

	