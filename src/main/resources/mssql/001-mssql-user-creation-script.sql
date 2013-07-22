/****** Object:  Login [apiary]    Script Date: 07/19/2013 17:17:08 ******/
IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'apiary')
DROP LOGIN [apiary]
GO

/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [apiary]    Script Date: 07/19/2013 17:17:08 ******/
CREATE LOGIN [apiary] WITH PASSWORD=N'?��?e��5)�?1J�x�?�u�C''�3�\E�', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

EXEC sys.sp_addsrvrolemember @loginame = N'apiary', @rolename = N'dbcreator'
GO

ALTER LOGIN [apiary] DISABLE
GO

