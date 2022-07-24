USE [AdventureWorks2017]
GO
------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------------------------------------
IF OBJECT_ID('User') IS NOT NULL
BEGIN 
DROP TABLE [dbo].[User]
END
GO
CREATE TABLE [dbo].[User](
       [UserID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	   [Username] [varchar](20) NULL,
       [Password] [varchar](20) NULL,
       [Email] [varchar](20) NULL,
       [PhoneNumber] [varchar](256) NULL,
	   [FirstName] [varchar](20) NULL,
	   [LastName] [varchar](20) NULL,
	   [Status] [int] NULL,
	   [RememberToken] [varchar](256) NULL,
	   [TokenExpireTime] [Datetime] NULL
 
); 

---------------------------------------
IF OBJECT_ID('DbLogs') IS NOT NULL
BEGIN 
DROP TABLE [dbo].[DbLogs]
END 
GO 
CREATE TABLE [dbo].[DbLogs](
	[LogID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[CmdText] [varchar](2000) NULL,
	[UserID] [int] NULL,
	[LogTime] [Datetime] NULL

);

----------------------------------------
IF OBJECT_ID('AddLogs') IS NOT NULL
BEGIN 
DROP PROC AddLogs
END
GO

CREATE PROCEDURE AddLogs
	@CmdText nvarchar(2000),
	@UserID int
AS
BEGIN 
	BEGIN TRY
		INSERT INTO [dbo].[DbLogs] (UserID, CmdText, LogTime) VALUES (@UserID, @CmdText, GETUTCDATE())
		RETURN 'OK'
	END TRY
	BEGIN CATCH
		SELECT MESSAGE = ERROR_MESSAGE()
	END CATCH
END 

----------------------------------------
IF OBJECT_ID('UserLogin') IS NOT NULL
BEGIN 
DROP PROC UserLogin
END
GO

CREATE PROCEDURE UserLogin
	@PhoneNumber nvarchar(256),
	@Password	nvarchar(256)
AS
BEGIN
	DECLARE @TempHashText varchar(256), @CmdText nvarchar(500), @HashText varchar(256), @Expired nvarchar(256), @UserID int;
	SET NOCOUNT ON;

	BEGIN TRY
		IF (@PhoneNumber='' OR @Password='')
			BEGIN
				Select status = 0 FOR JSON PATH			--MESSAGE='Username Or Password Cannot Be Blank';
			END 
		ELSE
			BEGIN
				IF EXISTS (SELECT TOP 1 1 FROM [dbo].[User] WHERE PhoneNumber=@PhoneNumber AND Password=@Password)
					BEGIN
						SET @TempHashText = CONCAT_WS('|', @PhoneNumber, @Password, CONVERT(VARCHAR, GETUTCDATE(), 21));
						SET @HashText =  CONVERT(NVARCHAR,HASHBYTES('SHA2_256', @TempHashText),1);
						SET @Expired = CONVERT(NVARCHAR, DATEADD(day, 30, GETUTCDATE()), 0);
						SET @CmdText = 'UPDATE [dbo].[User] SET RememberToken= ''' + @HashText +''', TokenExpireTime= ''' + @Expired +'''' +  ' WHERE PhoneNumber= '''+ @PhoneNumber + ''''
						SET @UserID = (SELECT UserID from [dbo].[User] WHERE PhoneNumber=@PhoneNumber AND Password=@Password)
						EXEC(@CmdText)
						SELECT UserID, Username, PhoneNumber, RememberToken ,status = 1  from [dbo].[User] WHERE PhoneNumber=@PhoneNumber AND Password=@Password FOR JSON AUTO 
						EXEC [dbo].[AddLogs] @CmdText, @UserID
					END
				ELSE
					Select status = 2 FOR JSON PATH		--MESSAGE= INVALID USERNAME AND PASSWORD';
			END
	END TRY
	BEGIN CATCH 
		SELECT MESSAGE = ERROR_MESSAGE() FOR JSON PATH;
	END CATCH
END


------------------------------------------------------------------------------------
CREATE PROCEDURE checkToken
	@token nvarchar(256)
AS
BEGIN 
	DECLARE @UId
	BEGIN TRY
		SELECT MAX(User_ID) INTO @UId FROM Tbl_User WHERE Last_Token = @token AND CONVERT(Datetime, Expired_Token, 120) > current_timestamp 
		IF @UId IS NULL
			RETURN -1;
		ELSE
			UPDATE Tbl_User SET Expired_Token = convert(varchar, DATEADD(day, 30, GETUTCDATE()), 0) WHERE User_ID = @UId
		RETURN @UId
	END TRY
	BEGIN CATCH
		RETURN -1;
	END CATCH
END

--------------------------------------------test------------------------------------

INSERT INTO [dbo].[User] (Username, Password, Email, PhoneNumber, FirstName, LastName)
VALUES ('reazmoj', 'm.h4400255761', 'reazmoj.h@gmail.com', '09226687123', 'Mojtaba', 'Hashemi')

EXEC [dbo].[UserLogin] '09226687123', 'm.h4400255761'