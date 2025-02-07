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

    -- ENTIDAD DE ADMINISTRACION (LOGIN)
        IF OBJECT_ID('[dbo].[Administración]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Administración]
            GO
            CREATE TABLE [Administración](
                [MATRICULA] VARCHAR(30) PRIMARY KEY
                , [FECHA DE REGISTRO] DATE DEFAULT GETDATE()
                , TOKEN TIME
            )

    -- ENTIDAD DE CREDENCIALES
        IF OBJECT_ID('[dbo].[Credenciales]', 'U') IS NOT NULL
            DROP TABLE [dbo].[Credenciales]
            GO
            CREATE TABLE Credenciales(
                REGIDUUID VARCHAR(60) PRIMARY KEY DEFAULT NEWID()
                , [MATRICULA] VARCHAR(30)
                , [CLAVE] VARCHAR(30) NOT NULL
                , [TIPO DE HORARIO] VARCHAR(25)
                , FOREIGN KEY([MATRICULA]) REFERENCES [Administración]([MATRICULA])
                , FOREIGN KEY([TIPO DE HORARIO]) REFERENCES [Horarios]([TIPO DE HORARIO])
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

    -- PROCEDIMIENTO PARA AGREGAR NUEVO USUARIO
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'AgregarUsuario'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.AgregarUsuario
                    GO
                CREATE PROCEDURE dbo.AgregarUsuario
                        @MATRICULA VARCHAR(30)
                        , @ESTADO BIT
                        , @TIPO_DE_USUARIO VARCHAR(100)
                        , @NOMBRE VARCHAR(100)
                        , @APELLIDO_PATERNO VARCHAR(100)
                        , @APELLIDO_MATERNO VARCHAR(100)
                        , @NÚMERO_DE_CELULAR VARCHAR(100)
                        , @MAIL VARCHAR(100)
                        , @CAMPUS VARCHAR(100)
                        , @EDIFICIO VARCHAR(100)
                        , @CARRERA VARCHAR(100)
                        , @LIBROS_EN_PODER INT
                        , @CONTRASENA VARCHAR(30)
                    AS
                    BEGIN
                        INSERT INTO Usuarios([MATRÍCULA], [STATUS], [TIPO DE USUARIO], NOMBRE, [APELLIDO PATERNO], [APELLIDO MATERNO], [NÚMERO DE CELULAR], MAIL, CAMPUS, EDIFICIO, CARRERA, [LIBROS EN PODER])
                        VALUES
                        (@MATRICULA, @ESTADO, @TIPO_DE_USUARIO, @NOMBRE, @APELLIDO_PATERNO, @APELLIDO_MATERNO, @NÚMERO_DE_CELULAR, @MAIL, @CAMPUS, @EDIFICIO, @CARRERA, @LIBROS_EN_PODER)

                        INSERT INTO [Administración]([MATRICULA]) VALUES (@MATRICULA)

                        INSERT INTO [Credenciales]([MATRICULA], CLAVE, [TIPO DE HORARIO]) VALUES (@MATRICULA, @CONTRASENA, @TIPO_DE_USUARIO)

                    END
                GO
 
    -- PROCEDIMIENTO PARA AGREGAR NUEVO LIBRO
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'AgregarLibro'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.AgregarLibro
                    GO
                CREATE PROCEDURE dbo.AgregarLibro
                        @ISBN VARCHAR(100)
                        , @ESTADO BIT
                        , @TITULO VARCHAR(100)
                        , @AUTOR VARCHAR(100)
                        , @EDICION VARCHAR(100)
                        , @NUMERO_DE_IMPRESION VARCHAR(100)
                        , @EDITORIAL VARCHAR(100)
                        , @ANIO INT
                        , @DISPONIBLES INT
                    AS
                    BEGIN
                        INSERT INTO Libros VALUES(@ISBN, @ESTADO, @TITULO, @AUTOR, @EDICION, @NUMERO_DE_IMPRESION, @EDITORIAL, @ANIO, @DISPONIBLES)
                    END
                GO

    -- PROCEDIMIENTO PARA CREAR TOKEN (TOKENIZACION)
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'Tokenizacion'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.Tokenizacion
                    GO
                CREATE PROCEDURE dbo.Tokenizacion
                        @CLAVE_DE_USUARIO VARCHAR(30)
                AS
                    BEGIN
                        UPDATE [Administración] SET TOKEN = CONVERT(TIME, DATEADD(HOUR, 1, GETDATE()))
                            WHERE [MATRICULA] = @CLAVE_DE_USUARIO
                    END
                GO
        GO

    -- PROCEDIMIENTO PARA VALIDAR TOKEN (VALIDAR TOKENIZACION)
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'ValidarToken'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.ValidarToken
                    GO
                CREATE PROCEDURE dbo.ValidarToken
                        @CLAVE_DE_USUARIO VARCHAR(30)
                AS
                    BEGIN
                        DECLARE @RESULT INT = 0
                        DECLARE @TOKEN TIME = (SELECT TOKEN FROM [Administración] WHERE [MATRICULA] = @CLAVE_DE_USUARIO)
                        IF(@TOKEN IS NOT NULL)
                        BEGIN
                            IF(ABS(DATEDIFF(MINUTE, @TOKEN, CONVERT(TIME,GETDATE()))) >= 1)
                            BEGIN SET @RESULT = 1 END
                        END
                        RETURN @RESULT
                    END
                GO
        GO

    -- PROCEDIMIENTO DE INICIAR SESION
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
            WHERE SPECIFIC_SCHEMA = N'dbo'
                AND SPECIFIC_NAME = N'Iniciar_sesion'
                AND ROUTINE_TYPE = N'PROCEDURE'
            )
                DROP PROCEDURE dbo.Iniciar_sesion
                    GO
                CREATE PROCEDURE dbo.Iniciar_sesion
                    @CLAVE_DE_USUARIO VARCHAR(30)
                    , @CLAVE VARCHAR(30)
                AS
                    BEGIN
                        DECLARE @RESULT INT
                        EXECUTE Tokenizacion @CLAVE_DE_USUARIO
                        IF(SELECT [Administración].TOKEN
                            FROM [Administración]
                            LEFT JOIN Credenciales ON [Administración].[MATRICULA] = Credenciales.[MATRICULA]
                            LEFT JOIN Horarios ON Credenciales.[TIPO DE HORARIO] = Horarios.[TIPO DE HORARIO]
                                WHERE [Administración].[MATRICULA] = @CLAVE_DE_USUARIO
                                    AND Credenciales.[CLAVE] = @CLAVE
                                    AND CONVERT(TIME,GETDATE()) BETWEEN(
                                        Horarios.[HORA MINIMA]
                                    ) AND (
                                        Horarios.[HORA MAXIMA]
                                    )) IS NULL
                        BEGIN SET @RESULT = 0 END
                        ELSE
                        BEGIN
                            IF(SELECT [TIPO DE HORARIO] FROM [Credenciales] WHERE [MATRICULA] = @CLAVE_DE_USUARIO)= 'Admin'
                            BEGIN SET @RESULT = 1 END
                            ELSE
                            BEGIN
                                IF(SELECT [TIPO DE HORARIO] FROM [Credenciales] WHERE [MATRICULA] = @CLAVE_DE_USUARIO)= 'Docente'
                                BEGIN SET @RESULT = 2 END
                                ELSE BEGIN SET @RESULT = 3 END
                            END
                        END
                        RETURN @RESULT
                    END
                GO

    -- PROCEDIMIENTO PARA CALCULAR LA FECHA DE ENTREGA DEL PRESTAMO DEL LIBRO
        IF EXISTS (
            SELECT *
                FROM INFORMATION_SCHEMA.ROUTINES
                    WHERE SPECIFIC_SCHEMA = N'dbo'
                    AND SPECIFIC_NAME = N'[Calcular Fecha de entrega]'
                    AND ROUTINE_TYPE = N'PROCEDURE'
            )
            DROP PROCEDURE dbo.[Calcular Fecha de entrega]
            GO
                CREATE PROCEDURE dbo.[Calcular Fecha de entrega]
                        @regiduuid VARCHAR(60)
                        , @fecha DATE
                    AS
                BEGIN
                    BEGIN TRANSACTION __calculo_fecha_entrega_libro
                        DECLARE @fecha_calculada DATE
                        SET @fecha_calculada = CONVERT(DATE,DATEADD(DAY, 3, CONVERT(DATE, @fecha)))
                        IF(DATENAME(WEEKDAY, @fecha_calculada) = 'Saturday' OR DATENAME(WEEKDAY, @fecha_calculada) = 'Sábado' OR DATENAME(WEEKDAY, @fecha_calculada) = 'Sabado')
                        BEGIN
                            UPDATE Registros SET [FECHA PROMESA DE ENTREGA] = CONVERT(DATE, DATEADD(DAY, 5, @fecha)) WHERE REGIDUUID = @regiduuid
                        END
                        IF(DATENAME(WEEKDAY,@fecha_calculada) = 'Sunday' OR DATENAME(WEEKDAY, @fecha_calculada) = 'Domingo')
                        BEGIN
                            UPDATE Registros SET [FECHA PROMESA DE ENTREGA] = CONVERT(DATE, DATEADD(DAY, 4, @fecha)) WHERE REGIDUUID = @regiduuid
                        END
                    COMMIT
                END
                GO

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
                    DECLARE @regiduud VARCHAR(60)
                    BEGIN TRANSACTION __nuevo_prestamo
                        INSERT INTO [Préstamos]([MATRÍCULA], ISBN, [FECHA DE EMISIÓN]) VALUES
                        (@matricula, @isbn, @fecha)
                        SET @regiduud = (SELECT REGIDUUID FROM [Préstamos] WHERE [MATRÍCULA] = @matricula AND [ISBN] = @isbn AND [FECHA DE EMISIÓN] = @fecha)
                        INSERT INTO Registros(REGIDUUID) VALUES
                        (@regiduud)
                        UPDATE Libros SET DISPONIBLES = (DISPONIBLES - @cantidad) WHERE ISBN = @isbn
                        UPDATE Usuarios SET [LIBROS EN PODER] = ([LIBROS EN PODER] + @cantidad) WHERE MATRÍCULA = @matricula
                        EXECUTE [Calcular Fecha de entrega] @regiduud, @fecha
                    IF (@libros_disponibles >= @cantidad)
                        IF (@libros_usuario <= 2)
                            BEGIN SET @RESULT = 1
                            COMMIT
                            END
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

    -- FUNCIÓN PARA CONSULTA DE LIBROS
        IF OBJECT_ID (N'dbo.Consultar_Libros', N'IF') IS NOT NULL
            DROP FUNCTION dbo.Consultar_Libros
            GO
                CREATE FUNCTION dbo.Consultar_Libros()
                    RETURNS TABLE
                AS
                    RETURN
                    (
                        SELECT ISBN
                            , [TÍTULO]
                            , AUTOR
                            , [EDICIÓN]
                            , [NÚMERO DE IMPRESIÓN]
                            , EDITORIAL
                            , [AÑO]
                            , DISPONIBLES
                            FROM Libros
                                WHERE [Status] = 1
                    )
                GO

    -- FUNCIÓN PARA CONSULTA DE USUARIOS DOCENTES
        IF OBJECT_ID (N'dbo.Consultar_Docentes', N'IF') IS NOT NULL
            DROP FUNCTION dbo.Consultar_Docentes
            GO
                CREATE FUNCTION dbo.Consultar_Docentes()
                    RETURNS TABLE
                AS
                    RETURN
                    (
                        SELECT [MATRÍCULA]
                            , NOMBRE
                            , [APELLIDO PATERNO]
                            , [APELLIDO MATERNO]
                            , [NÚMERO DE CELULAR]
                            , MAIL
                            , CAMPUS
                            , EDIFICIO
                            , CARRERA
                            , [LIBROS EN PODER]
                            FROM Usuarios
                                WHERE [TIPO DE USUARIO] = 'Docente'
                                AND [STATUS] = 1
                    )
                GO

    -- FUNCIÓN PARA CONSULTA DE USUARIOS ALUMNOS
        IF OBJECT_ID (N'dbo.Consultar_Alumnos', N'IF') IS NOT NULL
            DROP FUNCTION dbo.Consultar_Alumnos
            GO
                CREATE FUNCTION dbo.Consultar_Alumnos()
                    RETURNS TABLE
                AS
                    RETURN
                    (
                        SELECT [MATRÍCULA]
                            , NOMBRE
                            , [APELLIDO PATERNO]
                            , [APELLIDO MATERNO]
                            , [NÚMERO DE CELULAR]
                            , MAIL
                            , CAMPUS
                            , EDIFICIO
                            , CARRERA
                            , [LIBROS EN PODER]
                            FROM Usuarios
                                WHERE [TIPO DE USUARIO] = 'Alumno'
                                AND [STATUS] = 1
                    )
                GO

    -- FUNCIÓN PARA CONSULTA DE PRÉSTAMOS
        IF OBJECT_ID (N'dbo.Consultar_Prestamos', N'IF') IS NOT NULL
            DROP FUNCTION dbo.Consultar_Prestamos
            GO
                CREATE FUNCTION dbo.Consultar_Prestamos()
                    RETURNS TABLE
                AS
                    RETURN
                    (
                        SELECT [Préstamos].REGIDUUID
                            , [Préstamos].MATRÍCULA
                            , Usuarios.[TIPO DE USUARIO]
                            , Usuarios.NOMBRE
                            , Usuarios.[NÚMERO DE CELULAR]
                            , Usuarios.MAIL
                            , [Préstamos].ISBN
                            , Libros.TÍTULO
                            , Libros.AUTOR
                            , [Préstamos].[STATUS]
                            , [Préstamos].[FECHA DE EMISIÓN]
                            , [Registros].[FECHA PROMESA DE ENTREGA]
                            , [Registros].[FECHA DE ENTREGA]
                            , [Registros].[EFECTIVO GENERADO]
                            , [Registros].[STATUS] [TIEMPO DE ENTREGA]
                            FROM [Préstamos]
                            LEFT JOIN Registros ON [Préstamos].REGIDUUID = Registros.REGIDUUID
                            LEFT JOIN Usuarios ON [Préstamos].[MATRÍCULA] = Usuarios.[MATRÍCULA]
                            LEFT JOIN Libros ON [Préstamos].ISBN = Libros.ISBN
                    )
                GO


----------------------
SELECT 'OK' AS 'RESULT'
----------------------