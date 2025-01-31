USE PROYECTO_INTERFACES
    GO

    DECLARE @RESULT INT
    EXECUTE @RESULT = Iniciar_Sesion '11223344-55','System32'
    PRINT @RESULT
    EXECUTE @RESULT = Iniciar_Sesion '11223344-56','System32'
    PRINT @RESULT
    -- 0 ES NO ACCEDER
    -- 1 ES ADMIN
    -- 2 ES DOCENTE
    -- 3 ES ALUMNO

    SELECT * FROM LIBROS

    SELECT * FROM USUARIOS

    SELECT * FROM PRESTAMOS
    /* LOS STATUS DE LOS LIBROS PUEDEN SER:
        Activo: Cuando el préstamo aún es vigente y el usuario cuenta con él
        Inactivo: Cuando el préstamo ya no es vigente y el libro se a entregado a la librería
        Retraso: Cuando el préstamo aún es vigente, el usuario cuenta con él y no ha sido entregado en el plazo estipulado
        


     */

    SELECT * FROM REGISTROS


    UPDATE Registros SET [FECHA DE EMISIÓN] = '2025-01-20'

        DECLARE @RC INT
        EXECUTE @RC = [Nuevo Préstamo] '22320455-32', '1453-1454-12566', 1
        PRINT @RC


        DECLARE @RU INT
        EXECUTE @RU = [Calcular Costo de préstamo]

            
