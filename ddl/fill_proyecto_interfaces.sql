USE PROYECTO_INTERFACES
    GO

    -- ENTIDAD DE HORARIOS
        INSERT INTO Horarios VALUES
        ('Admin', '00:00:00.000', '23:59:59.000', 'TEST'),
        ('Docente', '00:00:00.000', '23:59:59.000', 'TEST'),
        ('Alumno', '00:00:00.000', '23:59:59.000', 'TEST')

    -- AGREGAR USUARIOS
        EXECUTE AgregarUsuario '11223344-55', 1, 'Admin', 'Alumno', 'HH', 'HH', '1122334455', '112233@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32'
        EXECUTE AgregarUsuario '11223344-56', 1, 'Docente', 'Docente', 'HH', 'HH', '1122334456', '112234@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32'
            
    -- AGREGAR LIBROS
        EXECUTE AgregarLibro '1453-1454-12566', 1,'Chistes de Gallegos', 'Gallegín', 'Quinta', 'Tercera', 'Españolas Ediciones', 2003, 2

    -- ENTIDAD DE PRÉSTAMOS Y REGISTROS
        DECLARE @RC INT
        EXECUTE @RC = [Nuevo Préstamo] '11223344-55', '1453-1454-12566', 1
        PRINT @RC

        /* Valores que retorna el procedimiento:
            1 : Préstamo completo y sin problemas
            2 : Préstamo incompleto porque no hay existencia suficiente del libro solicitado
            3 : Préstamo incompleto porque el usuario ya tiene 3 libros
        */

        DECLARE @RU INT
        EXECUTE @RU = [Calcular Costo de préstamo]
        PRINT @RU

----------------------
SELECT 'OK' AS 'RESULT'
----------------------