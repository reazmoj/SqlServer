USE [hampateam_DB]
GO
------------------------------------------------
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[nodejs_check_token](@token nvarchar(256))
RETURNS nvarchar(256)
AS
BEGIN
DECLARE @UId INT
BEGIN TRY 
	SELECT 
END TRY
BEGIN CATCH
	
END CATCH
END;
GO
