USE [hampateam_DB]
GO
/****** Object:  StoredProcedure [dbo].[nodejs_UserLogin4]    Script Date: 9/5/2021 7:29:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[nodejs_AddLogs]
	@cmdtext nvarchar(500),
	@logUserId int,
	@returnText nvarchar(256) OUT
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		INSERT INTO [hampateam_user].[Tbl_UserLogins](cmdtext, Login_UserId, Login_Date) 
		VALUES (@cmdtext, @logUserId, GETUTCDATE());
		SET @returnText = 'ok';
	END TRY
	BEGIN CATCH
		SET @returnText = ERROR_MESSAGE();
	END CATCH
END
