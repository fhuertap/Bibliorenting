USE PROYECTO_INTERFACES
    GO

    -- ENTIDAD DE HORARIOS
        INSERT INTO Horarios VALUES
        ('Admin', '00:00:00.000', '23:59:59.000', 'TEST'),
        ('Docente', '00:00:00.000', '23:59:59.000', 'TEST'),
        ('Alumno', '00:00:00.000', '23:59:59.000', 'TEST')

    -- ENTIDAD DE LOGIN
        INSERT INTO [Administración]([CLAVE DE USUARIO], NOMBRE) VALUES
        (1, 'FERNANDO HUERTA ADMIN'),
        (2, 'FERNANDO HUERTA DOCENTE'),
        (3, 'FERNANDO HUERTA ALUMNO')

    -- ENTIDAD DE CREDENCIALES
        INSERT INTO [Credenciales]([CLAVE DE USUARIO], CLAVE, [TIPO DE HORARIO]) VALUES
        ((SELECT [CLAVE DE USUARIO] FROM [Administración] WHERE NOMBRE = 'FERNANDO HUERTA ADMIN'), 'System32', 'Admin'),
        ((SELECT [CLAVE DE USUARIO] FROM [Administración] WHERE NOMBRE = 'FERNANDO HUERTA DOCENTE'), 'System32', 'Docente'),
        ((SELECT [CLAVE DE USUARIO] FROM [Administración] WHERE NOMBRE = 'FERNANDO HUERTA ALUMNO'), 'System32', 'Alumno')

    -- ENTIDAD DE LIBROS
        INSERT INTO Libros VALUES
        ('1453-1454-12566', 1,'Chistes de Gallegos', 'Gallegín', 'Quinta', 'Tercera', 'Españolas Ediciones', 2003, 2)

    -- ENTIDAD DE USUARIOS
        INSERT INTO Usuarios([MATRÍCULA]
                , [STATUS]
                , [TIPO DE USUARIO]
                , NOMBRE
                , [APELLIDO PATERNO]
                , [APELLIDO MATERNO]
                , [NÚMERO DE CELULAR]
                , MAIL
                , CAMPUS
                , EDIFICIO
                , CARRERA
                , [LIBROS EN PODER]) VALUES
        ('22320455-32', 1,'Alumno', 'Fernando', 'Huerta', 'Ponce', '5547682317', '2232045532@comunimex.edu.mx', 'IZCALLI', 'Cuarto', 'Sistemas Computacionales', 0)
            
    -- ENTIDAD DE PRÉSTAMOS Y REGISTROS
        DECLARE @RC INT
        EXECUTE @RC = [Nuevo Préstamo] '22320455-32', '1453-1454-12566', 1
        PRINT @RC


----------------------
SELECT 'OK' AS 'RESULT'
----------------------