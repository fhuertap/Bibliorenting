USE PROYECTO_INTERFACES;

-- ENTIDAD DE HORARIOS
	INSERT INTO Horarios (TIPO_DE_HORARIO, HORA_MINIMA, HORA_MAXIMA, OBSERVACIONES) VALUES
	('Admin', '00:00:00', '23:59:59', 'TEST'),
	('Docente', '00:00:00', '23:59:59', 'TEST'),
	('Alumno', '00:00:00', '23:59:59', 'TEST');

-- AGREGAR USUARIOS
	CALL AgregarUsuario('11223344-55', 1, 'Admin', 'Alumno', 'HH', 'HH', '1122334455', '112233@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32');
	CALL AgregarUsuario('11223344-56', 1, 'Docente', 'Docente', 'HH', 'HH', '1122334456', '112234@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32');
	CALL AgregarUsuario('11223344-57', 1, 'Alumno', 'Alumno', 'HH', 'HH', '1122334456', '112234@abc.com', 'AAAAAA', 'Cuarto', 'Sistemas Computacionales', 0, 'System32');

-- INICIAR SESIÓN
	CALL Iniciar_Sesion('11223344-55', 'System32');
-- 0 ES NO ACCEDER
-- 1 ES ADMIN
-- 2 ES DOCENTE
-- 3 ES ALUMNO

-- VALIDACIÓN DE TOKEN
	CALL ValidarToken('11223344-55');
-- 0 TOKEN VENCIDO
-- 1 TOKEN VIGENTE

-- AGREGAR LIBROS
	CALL AgregarLibro('1453-1454-12566', 1,'Chistes de Gallegos', 'Gallegín', 'Quinta', 'Tercera', 'Españolas Ediciones', 2003, 2);

-- CONSULTA DE LIBROS
	SELECT ISBN, TITULO, AUTOR, EDICION, NUMERO_DE_IMPRESION, EDITORIAL, ANIO, DISPONIBLES
    FROM Libros
    WHERE STATUS = 1;
    
-- CONSULTA DE DOCENTES
    SELECT MATRICULA, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, NUMERO_DE_CELULAR, MAIL, CAMPUS, EDIFICIO, CARRERA, LIBROS_EN_PODER
    FROM Usuarios
    WHERE TIPO_DE_USUARIO = 'Docente' AND STATUS = 1;
    
-- CONSULTA DE ALUMNOS
	SELECT MATRICULA, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, NUMERO_DE_CELULAR, MAIL, CAMPUS, EDIFICIO, CARRERA, LIBROS_EN_PODER
    FROM Usuarios
    WHERE TIPO_DE_USUARIO = 'Alumno' AND STATUS = 1;
    
-- ENTIDAD DE PRÉSTAMOS Y REGISTROS
	CALL Nuevo_Prestamo('11223344-55', '1453-1454-12566', 1);

-- Valores que retorna el procedimiento:
-- 1 : Préstamo completo y sin problemas
-- 2 : Préstamo incompleto porque no hay existencia suficiente del libro solicitado
-- 3 : Préstamo incompleto porque el usuario ya tiene 3 libros

-- CONSULTA DE PRESTAMOS
	SELECT Prestamos.REGIDUUID, Prestamos.MATRICULA, Usuarios.TIPO_DE_USUARIO, Usuarios.NOMBRE, Usuarios.NUMERO_DE_CELULAR, Usuarios.MAIL, Prestamos.ISBN, Libros.TITULO, Libros.AUTOR, Prestamos.STATUS, Prestamos.FECHA_DE_EMISION, Registros.FECHA_PROMESA_DE_ENTREGA, Registros.FECHA_DE_ENTREGA, Registros.EFECTIVO_GENERADO, Registros.STATUS AS TIEMPO_DE_ENTREGA
    FROM Prestamos
    LEFT JOIN Registros ON Prestamos.REGIDUUID = Registros.REGIDUUID
    LEFT JOIN Usuarios ON Prestamos.MATRICULA = Usuarios.MATRICULA
    LEFT JOIN Libros ON Prestamos.ISBN = Libros.ISBN;
    
-- CÁLCULO DE COSTO DE ENTREGA
CALL Calcular_Costo_de_prestamo();

-- LOS STATUS DE LOS LIBROS PUEDEN SER:
-- Activo: Cuando el préstamo aún es vigente y el usuario cuenta con él
-- Inactivo: Cuando el préstamo ya no es vigente y el libro se ha entregado a la librería
-- Retraso: Cuando el préstamo aún es vigente, el usuario cuenta con él y no ha sido entregado en el plazo estipulado

