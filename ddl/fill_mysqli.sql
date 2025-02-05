USE PROYECTO_INTERFACES;

-- INICIAR SESIÓN
SET @LOGIN = 0;
CALL Iniciar_Sesion('11223344-55', 'System32', @LOGIN);
SELECT @LOGIN;
-- 0 ES NO ACCEDER
-- 1 ES ADMIN
-- 2 ES DOCENTE
-- 3 ES ALUMNO

-- VALIDACIÓN DE TOKEN
SET @VALIDARTOKEN = 0;
CALL ValidarToken('11223344-55', @VALIDARTOKEN);
SELECT @VALIDARTOKEN;
-- 0 TOKEN VENCIDO
-- 1 TOKEN VIGENTE

-- ENTIDAD DE HORARIOS
INSERT INTO Horarios (TIPO_DE_HORARIO, HORA_MINIMA, HORA_MAXIMA, OBSERVACIONES) VALUES
('Admin', '00:00:00', '23:59:59', 'TEST'),
('Docente', '00:00:00', '23:59:59', 'TEST'),
('Alumno', '00:00:00', '23:59:59', 'TEST');

-- AGREGAR USUARIOS
CALL AgregarUsuario('11223344-55', 1, 'Admin', 'Alumno', 'HH', 'HH', '1122334455', '112233@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32');
CALL AgregarUsuario('11223344-56', 1, 'Docente', 'Docente', 'HH', 'HH', '1122334456', '112234@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32');
CALL AgregarUsuario('11223344-57', 1, 'Alumno', 'Alumno', 'HH', 'HH', '1122334456', '112234@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32');

-- AGREGAR LIBROS
CALL AgregarLibro('1453-1454-12566', 1, 'Chistes de Gallegos', 'Gallegín', 'Quinta', 'Tercera', 'Españolas Ediciones', 2003, 2);

-- CONSULTA DE LIBROS
CALL Consultar_Libros();

-- CONSULTA DE DOCENTES
CALL Consultar_Docentes();

-- CONSULTA DE ALUMNOS
CALL Consultar_Alumnos();

-- ENTIDAD DE PRÉSTAMOS Y REGISTROS
SET @RC = 0;
CALL `Nuevo Préstamo`('11223344-55', '1453-1454-12566', 1, @RC);
SELECT @RC;

-- Valores que retorna el procedimiento:
-- 1 : Préstamo completo y sin problemas
-- 2 : Préstamo incompleto porque no hay existencia suficiente del libro solicitado
-- 3 : Préstamo incompleto porque el usuario ya tiene 3 libros

-- CÁLCULO DE COSTO DE ENTREGA
SET @RU = 0;
CALL `Calcular Costo de préstamo`(@RU);
SELECT @RU;

SELECT * FROM PRESTAMOS;

-- LOS STATUS DE LOS LIBROS PUEDEN SER:
-- Activo: Cuando el préstamo aún es vigente y el usuario cuenta con él
-- Inactivo: Cuando el préstamo ya no es vigente y el libro se ha entregado a la librería
-- Retraso: Cuando el préstamo aún es vigente, el usuario cuenta con él y no ha sido entregado en el plazo estipulado

SELECT 'OK' AS 'RESULT';
