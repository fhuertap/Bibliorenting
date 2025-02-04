USE PROYECTO_INTERFACES
    GO

    -- INICIAR SESIÓN
    DECLARE @LOGIN INT
    EXECUTE @LOGIN = Iniciar_Sesion '11223344-55','System32'
    PRINT @LOGIN
    -- 0 ES NO ACCEDER
    -- 1 ES ADMIN
    -- 2 ES DOCENTE
    -- 3 ES ALUMNO

    -- VALIDACIÓN DE TOKEN
    DECLARE @VALIDARTOKEN INT
    EXECUTE @VALIDARTOKEN = ValidarToken '11223344-55'
    PRINT @VALIDARTOKEN
    -- 0 TOKEN VENCIDO
    -- 1 TOKEN VIGENTE


    SELECT * FROM Libros

    SELECT * FROM PRESTAMOS
    SELECT * FROM Registros
    /* LOS STATUS DE LOS LIBROS PUEDEN SER:
        Activo: Cuando el préstamo aún es vigente y el usuario cuenta con él
        Inactivo: Cuando el préstamo ya no es vigente y el libro se a entregado a la librería
        Retraso: Cuando el préstamo aún es vigente, el usuario cuenta con él y no ha sido entregado en el plazo estipulado
        


     */




        

        
            
