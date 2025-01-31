USE MASTER
GO

    -- CREACIÓN DE LA BASE DE DATOS
        IF EXISTS (
            SELECT [name]
                FROM sys.databases
                WHERE [name] = N'PROYECTO_INTERFACES')
                    ALTER DATABASE PROYECTO_INTERFACES SET SINGLE_USER WITH ROLLBACK IMMEDIATE
                            DROP DATABASE IF EXISTS PROYECTO_INTERFACES
                        GO

            CREATE DATABASE PROYECTO_INTERFACES
                COLLATE SQL_Latin1_General_CP1_CI_AI
                GO

            USE PROYECTO_INTERFACES
                GO

    -- ENTIDAD DE HORARIOS
        IF OBJECT_ID('[dbo].[Horarios]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Horarios]
            GO
            CREATE TABLE Horarios(
                [TIPO DE HORARIO] VARCHAR(25) PRIMARY KEY
                , [HORA MINIMA] TIME NOT NULL
                , [HORA MAXIMA] TIME NOT NULL
                , OBSERVACIONES VARCHAR(100)
            )

    -- ENTIDAD DE LOGIN
        IF OBJECT_ID('[dbo].[Administración]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Administración]
            GO
            CREATE TABLE [Administración](
                [CLAVE DE USUARIO] INT PRIMARY KEY
                , NOMBRE VARCHAR(30) NOT NULL
                , [FECHA DE REGISTRO] DATE DEFAULT GETDATE()
                , TOKEN TIME
            )

    -- ENTIDAD DE CREDENCIALES
        IF OBJECT_ID('[dbo].[Credenciales]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Credenciales]
            GO
            CREATE TABLE Credenciales(
                REGIDUUID VARCHAR(60) PRIMARY KEY DEFAULT NEWID()
                , [CLAVE DE USUARIO] INT
                , [CLAVE] VARCHAR(30) NOT NULL
                , [TIPO DE HORARIO] VARCHAR(25)
                , FOREIGN KEY([CLAVE DE USUARIO]) REFERENCES [Administración]([CLAVE DE USUARIO])
                , FOREIGN KEY([TIPO DE HORARIO]) REFERENCES [Horarios]([TIPO DE HORARIO])
            )

        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'Tokenizacion'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.Tokenizacion
                    GO
                -- Create the stored procedure in the specified schema
                CREATE PROCEDURE dbo.Tokenizacion
                        @CLAVE_DE_USUARIO INT
                AS
                    BEGIN
                        UPDATE [Administración] SET TOKEN = CONVERT(TIME, DATEADD(HOUR, 1, GETDATE()))
                            WHERE [CLAVE DE USUARIO] = @CLAVE_DE_USUARIO
                    END
                GO
        GO

    -- PROCEDIMIENTO DE LOGIN
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'Iniciar_sesion'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.Iniciar_sesion
                    GO
                -- Create the stored procedure in the specified schema
                CREATE PROCEDURE dbo.Iniciar_sesion
                    @CLAVE_DE_USUARIO INT
                    , @CLAVE VARCHAR(30)
                AS
                    BEGIN
                        DECLARE @RESULT INT
                        EXECUTE Tokenizacion @CLAVE_DE_USUARIO
                        IF(SELECT [Administración].TOKEN
                            FROM [Administración]
                            LEFT JOIN Credenciales ON [Administración].[CLAVE DE USUARIO] = Credenciales.[CLAVE DE USUARIO]
                            LEFT JOIN Horarios ON Credenciales.[TIPO DE HORARIO] = Horarios.[TIPO DE HORARIO]
                                WHERE [Administración].[CLAVE DE USUARIO] = @CLAVE_DE_USUARIO
                                    AND Credenciales.[CLAVE] = @CLAVE
                                    AND CONVERT(TIME,GETDATE()) BETWEEN(
                                        Horarios.[HORA MINIMA]
                                    ) AND (
                                        Horarios.[HORA MAXIMA]
                                    )) IS NULL
                        BEGIN SET @RESULT = 0 END
                        ELSE
                            BEGIN
                                IF(SELECT [TIPO DE HORARIO] FROM [Credenciales] WHERE [CLAVE DE USUARIO] = @CLAVE_DE_USUARIO)= 'Admin'
                                BEGIN SET @RESULT = 1 END
                                ELSE BEGIN SET @RESULT = 2 END
                            END
                        RETURN @RESULT
                    END
                GO

    -- ENTIDAD DE LIBROS
        IF OBJECT_ID('[dbo].[Libros]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Libros]
            GO
            CREATE TABLE Libros(
                ISBN VARCHAR(100) PRIMARY KEY
                , [STATUS] BIT
                , [TÍTULO] VARCHAR(100) NOT NULL
                , AUTOR VARCHAR(100) NOT NULL
                , [EDICIÓN] VARCHAR(100) NOT NULL
                , [NÚMERO DE IMPRESIÓN] VARCHAR(100) NOT NULL
                , EDITORIAL VARCHAR(100) NOT NULL
                , [AÑO] INT NOT NULL
                , DISPONIBLES INT
            )

    -- ENTIDAD DE USUARIOS FINALES
        IF OBJECT_ID('[dbo].[Usuarios]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Usuarios]
            GO
            CREATE TABLE Usuarios(
                [MATRÍCULA] VARCHAR(30) PRIMARY KEY
                , [STATUS] BIT
                , [TIPO DE USUARIO] VARCHAR(100) NOT NULL
                , NOMBRE VARCHAR(100) NOT NULL
                , [APELLIDO PATERNO] VARCHAR(100) NOT NULL
                , [APELLIDO MATERNO] VARCHAR(100) NOT NULL
                , [NÚMERO DE CELULAR] VARCHAR(100) NOT NULL
                , MAIL VARCHAR(100) NOT NULL
                , CAMPUS VARCHAR(100) NOT NULL
                , EDIFICIO VARCHAR(100) NOT NULL
                , CARRERA VARCHAR(100) NOT NULL
                , [LIBROS EN PODER] INT NOT NULL
            )

    -- ENTIDAD DE PRÉSTAMOS
        IF OBJECT_ID('[dbo].[Préstamos]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Préstamos]
            GO
            CREATE TABLE [Préstamos](
                REGIDUUID VARCHAR(60) PRIMARY KEY DEFAULT NEWID()
                , [MATRÍCULA] VARCHAR(30)
                , ISBN VARCHAR(100)
                , [FECHA DE EMISIÓN] DATETIME
                , [STATUS] VARCHAR(60) NOT NULL DEFAULT 'Activo'
                , FOREIGN KEY(MATRÍCULA) REFERENCES Usuarios(MATRÍCULA)
                , FOREIGN KEY(ISBN) REFERENCES Libros(ISBN)
            )

    -- ENTIDAD DE REGISTRO DE FECHAS Y EFECTIVO DE PRÉSTAMOS
        IF OBJECT_ID('[dbo].[Registros]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Registros]
            GO
            CREATE TABLE Registros(
                [No.Reg] INT IDENTITY PRIMARY KEY
                , REGIDUUID VARCHAR(60)
                , [FECHA DE EMISIÓN] DATE DEFAULT CONVERT(DATE, GETDATE())
                , [FECHA PROMESA DE ENTREGA] DATE DEFAULT CONVERT(DATE, (GETDATE() + 3))
                , [FECHA DE ENTREGA] DATE
                , [EFECTIVO GENERADO] MONEY DEFAULT 30
                , [STATUS] VARCHAR(60) NOT NULL DEFAULT 'En tiempo'
                , FOREIGN KEY(REGIDUUID) REFERENCES [Préstamos](REGIDUUID)
            )

    -- PROCEDIMIENTO PARA AGREGAR NUEVO PRÉSTAMO DE LIBRO
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
                    WHERE SPECIFIC_SCHEMA = N'dbo'
                    AND SPECIFIC_NAME = N'[Nuevo Préstamo]'
                    AND ROUTINE_TYPE = N'PROCEDURE'
            )
            DROP PROCEDURE dbo.[Nuevo Préstamo]
            GO
                CREATE PROCEDURE dbo.[Nuevo Préstamo]
                    @matricula VARCHAR(30)
                    , @isbn VARCHAR(100)
                    , @cantidad INT
                    AS
                BEGIN
                    DECLARE @libros_disponibles INT = (SELECT DISPONIBLES FROM Libros WHERE ISBN = @isbn)
                    DECLARE @libros_usuario INT = (SELECT [LIBROS EN PODER] FROM Usuarios WHERE [MATRÍCULA] = @matricula)
                    DECLARE @fecha DATETIME = GETDATE()
                    DECLARE @RESULT INT = 0
                    BEGIN TRANSACTION __nuevo_prestamo
                        INSERT INTO [Préstamos]([MATRÍCULA], ISBN, [FECHA DE EMISIÓN]) VALUES
                        (@matricula, @isbn, @fecha)
                        INSERT INTO Registros(REGIDUUID) VALUES
                        ((SELECT REGIDUUID FROM [Préstamos] WHERE [MATRÍCULA] = @matricula AND [ISBN] = @isbn AND [FECHA DE EMISIÓN] = @fecha))
                        UPDATE Libros SET DISPONIBLES = (DISPONIBLES - @cantidad) WHERE ISBN = @isbn
                        UPDATE Usuarios SET [LIBROS EN PODER] = ([LIBROS EN PODER] + @cantidad) WHERE MATRÍCULA = @matricula
                    IF (@libros_disponibles >= @cantidad)
                        IF (@libros_usuario <= 2)
                            BEGIN SET @RESULT = 1 COMMIT END
                        ELSE BEGIN SET @RESULT = 3 ROLLBACK END
                    ELSE BEGIN SET @RESULT = 2 ROLLBACK END
                    RETURN @RESULT
                END
                GO

    -- PROCEDIMIENTO PARA CALCULAR COSTOS DE RETRASO DE PRÉSTAMOS
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
                    WHERE SPECIFIC_SCHEMA = N'dbo'
                    AND SPECIFIC_NAME = N'[Calcular Costo de préstamo]'
                    AND ROUTINE_TYPE = N'PROCEDURE'
            )
            DROP PROCEDURE dbo.[Calcular Costo de préstamo]
            GO
                CREATE PROCEDURE dbo.[Calcular Costo de préstamo]
                    AS
                BEGIN
                    BEGIN TRANSACTION __calculo_de_costo_de_préstamo
                    UPDATE Registros SET [STATUS] = 'Retraso' WHERE (DATEDIFF(DAY, [FECHA DE EMISIÓN], GETDATE()) > 2)
                    UPDATE Registros SET [EFECTIVO GENERADO] = (DATEDIFF(DAY, [FECHA DE EMISIÓN], GETDATE()) * 10) WHERE (DATEDIFF(DAY, [FECHA DE EMISIÓN], GETDATE()) > 2)
                    COMMIT
                END
                GO




----------------------
SELECT 'OK' AS 'RESULT'
----------------------