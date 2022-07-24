ALTER TABLE [hampateam_user].[Tbl_UserLogins]
ADD [cmdtext] nvarchar(500);

ALTER TABLE [hampateam_user].[Tbl_UserLogins]
DROP COLUMN [cmdtext]

