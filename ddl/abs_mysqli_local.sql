-- CREACIÓN DE LA BASE DE DATOS
-- DROP DATABASE IF EXISTS PROYECTO_INTERFACES;
-- CREATE DATABASE PROYECTO_INTERFACES
--    CHARACTER SET latin1
--    COLLATE latin1_swedish_ci;
-- ENTIDAD DE LIBROS
CREATE TABLE Libros(
    ISBN VARCHAR(100) PRIMARY KEY,
    STATUS BIT,
    TITULO VARCHAR(100) NOT NULL,
    AUTOR VARCHAR(100) NOT NULL,
    EDICION VARCHAR(100) NOT NULL,
    NUMERO_DE_IMPRESION VARCHAR(100) NOT NULL,
    EDITORIAL VARCHAR(100) NOT NULL,
    ANIO INT NOT NULL,
    DISPONIBLES INT
);

-- ENTIDAD DE USUARIOS FINALES
CREATE TABLE Usuarios(
    MATRICULA VARCHAR(30) PRIMARY KEY,
    STATUS BIT,
    TIPO_DE_USUARIO VARCHAR(100) NOT NULL,
    NOMBRE VARCHAR(100) NOT NULL,
    APELLIDO_PATERNO VARCHAR(100) NOT NULL,
    APELLIDO_MATERNO VARCHAR(100) NOT NULL,
    NUMERO_DE_CELULAR VARCHAR(100) NOT NULL,
    MAIL VARCHAR(100) NOT NULL,
    CAMPUS VARCHAR(100) NOT NULL,
    EDIFICIO VARCHAR(100) NOT NULL,
    CARRERA VARCHAR(100) NOT NULL,
    LIBROS_EN_PODER INT NOT NULL
);

-- ENTIDAD DE HORARIOS
CREATE TABLE Horarios(
    TIPO_DE_HORARIO VARCHAR(25) PRIMARY KEY,
    HORA_MINIMA TIME NOT NULL,
    HORA_MAXIMA TIME NOT NULL,
    OBSERVACIONES VARCHAR(100)
);

-- ENTIDAD DE ADMINISTRACION (LOGIN)
CREATE TABLE Administracion(
    MATRICULA VARCHAR(30) PRIMARY KEY,
    FECHA_DE_REGISTRO TIMESTAMP,
    TOKEN TIME
);

-- ENTIDAD DE CREDENCIALES
CREATE TABLE Credenciales(
    REGIDUUID VARCHAR(60) PRIMARY KEY DEFAULT (UUID()),
    MATRICULA VARCHAR(30),
    CLAVE VARCHAR(30) NOT NULL,
    TIPO_DE_HORARIO VARCHAR(25),
    FOREIGN KEY (MATRICULA) REFERENCES Administracion(MATRICULA),
    FOREIGN KEY (TIPO_DE_HORARIO) REFERENCES Horarios(TIPO_DE_HORARIO)
);

-- ENTIDAD DE PRÉSTAMOS
CREATE TABLE Prestamos(
    REGIDUUID VARCHAR(60) PRIMARY KEY DEFAULT (UUID()),
    MATRICULA VARCHAR(30),
    ISBN VARCHAR(100),
    FECHA_DE_EMISION DATETIME,
    INSERTING BIT,
    STATUS VARCHAR(60) NOT NULL DEFAULT 'Activo',
    FOREIGN KEY (MATRICULA) REFERENCES Usuarios(MATRICULA),
    FOREIGN KEY (ISBN) REFERENCES Libros(ISBN)
);

-- ENTIDAD DE REGISTRO DE FECHAS Y EFECTIVO DE PRÉSTAMOS
DROP TABLE IF EXISTS Registros;
CREATE TABLE Registros(
    No_Reg INT AUTO_INCREMENT PRIMARY KEY,
    REGIDUUID VARCHAR(60),
    FECHA_DE_EMISION TIMESTAMP,
    FECHA_PROMESA_DE_ENTREGA DATE DEFAULT DATE_ADD(CURRENT_DATE, INTERVAL 3 DAY),
    FECHA_DE_ENTREGA DATE,
    EFECTIVO_GENERADO DECIMAL(10, 2) DEFAULT 30.00,
    STATUS VARCHAR(60) NOT NULL DEFAULT 'En tiempo',
    FOREIGN KEY (REGIDUUID) REFERENCES Prestamos(REGIDUUID)
);

-- PROCEDIMIENTO PARA AGREGAR NUEVO USUARIO
DROP PROCEDURE IF EXISTS AgregarUsuario;
DELIMITER //
CREATE PROCEDURE AgregarUsuario(
    IN MATRICULA VARCHAR(30),
    IN ESTADO BIT,
    IN TIPO_DE_USUARIO VARCHAR(100),
    IN NOMBRE VARCHAR(100),
    IN APELLIDO_PATERNO VARCHAR(100),
    IN APELLIDO_MATERNO VARCHAR(100),
    IN NUMERO_DE_CELULAR VARCHAR(100),
    IN MAIL VARCHAR(100),
    IN CAMPUS VARCHAR(100),
    IN EDIFICIO VARCHAR(100),
    IN CARRERA VARCHAR(100),
    IN LIBROS_EN_PODER INT,
    IN CONTRASENA VARCHAR(30)
)
BEGIN
    INSERT INTO Usuarios (MATRICULA, STATUS, TIPO_DE_USUARIO, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, NUMERO_DE_CELULAR, MAIL, CAMPUS, EDIFICIO, CARRERA, LIBROS_EN_PODER)
    VALUES (MATRICULA, ESTADO, TIPO_DE_USUARIO, NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, NUMERO_DE_CELULAR, MAIL, CAMPUS, EDIFICIO, CARRERA, LIBROS_EN_PODER);

    INSERT INTO Administracion (MATRICULA) VALUES (MATRICULA);

    INSERT INTO Credenciales (MATRICULA, CLAVE, TIPO_DE_HORARIO) VALUES (MATRICULA, CONTRASENA, TIPO_DE_USUARIO);
END //
DELIMITER ;

-- PROCEDIMIENTO PARA AGREGAR NUEVO LIBRO
DROP PROCEDURE IF EXISTS AgregarLibro;
DELIMITER //
CREATE PROCEDURE AgregarLibro(
    IN ISBN VARCHAR(100),
    IN ESTADO BIT,
    IN TITULO VARCHAR(100),
    IN AUTOR VARCHAR(100),
    IN EDICION VARCHAR(100),
    IN NUMERO_DE_IMPRESION VARCHAR(100),
    IN EDITORIAL VARCHAR(100),
    IN ANIO INT,
    IN DISPONIBLES INT
)
BEGIN
    INSERT INTO Libros VALUES(ISBN, ESTADO, TITULO, AUTOR, EDICION, NUMERO_DE_IMPRESION, EDITORIAL, ANIO, DISPONIBLES);
END //
DELIMITER ;

-- PROCEDIMIENTO PARA CREAR TOKEN (TOKENIZACION)
DROP PROCEDURE IF EXISTS Tokenizacion;
DELIMITER //
CREATE PROCEDURE Tokenizacion(
    IN CLAVE_DE_USUARIO VARCHAR(30)
)
BEGIN
    UPDATE Administracion SET TOKEN = ADDTIME(CURRENT_TIME(), '01:00:00')
    WHERE MATRICULA = CLAVE_DE_USUARIO;
END //
DELIMITER ;

-- PROCEDIMIENTO PARA VALIDAR TOKEN (VALIDAR TOKENIZACION)
DROP PROCEDURE IF EXISTS ValidarToken;
DELIMITER //
CREATE PROCEDURE ValidarToken(
    IN CLAVE_DE_USUARIO VARCHAR(30)
)
BEGIN
    DECLARE RESULT INT DEFAULT 0;
    DECLARE TOKEN TIME;
    SET TOKEN = (SELECT TOKEN FROM Administracion WHERE MATRICULA = CLAVE_DE_USUARIO);
    IF TOKEN IS NOT NULL THEN
        IF ABS(TIMESTAMPDIFF(MINUTE, TOKEN, CURRENT_TIME())) >= 1 THEN
            SET RESULT = 1;
        END IF;
    END IF;
    SELECT RESULT;
END //
DELIMITER ;

-- PROCEDIMIENTO DE INICIAR SESION
DROP PROCEDURE IF EXISTS Iniciar_sesion;
DELIMITER //
CREATE PROCEDURE Iniciar_sesion(
    IN CLAVE_DE_USUARIO VARCHAR(30),
    IN CLAVE VARCHAR(30)
)
BEGIN
    DECLARE RESULT INT;
    CALL Tokenizacion(CLAVE_DE_USUARIO);
    IF (SELECT Administracion.TOKEN
        FROM Administracion
        LEFT JOIN Credenciales ON Administracion.MATRICULA = Credenciales.MATRICULA
        LEFT JOIN Horarios ON Credenciales.TIPO_DE_HORARIO = Horarios.TIPO_DE_HORARIO
        WHERE Administracion.MATRICULA = CLAVE_DE_USUARIO
        AND Credenciales.CLAVE = CLAVE
        AND CURRENT_TIME() BETWEEN Horarios.HORA_MINIMA AND Horarios.HORA_MAXIMA) IS NULL THEN
        SET RESULT = 0;
    ELSE
        IF (SELECT TIPO_DE_HORARIO FROM Credenciales WHERE MATRICULA = CLAVE_DE_USUARIO) = 'Admin' THEN
            SET RESULT = 1;
        ELSEIF (SELECT TIPO_DE_HORARIO FROM Credenciales WHERE MATRICULA = CLAVE_DE_USUARIO) = 'Docente' THEN
            SET RESULT = 2;
        ELSE
            SET RESULT = 3;
        END IF;
    END IF;
    SELECT RESULT;
END //
DELIMITER ;

-- PROCEDIMIENTO PARA CALCULAR LA FECHA DE ENTREGA DEL PRESTAMO DEL LIBRO
DROP PROCEDURE IF EXISTS Calcular_Fecha_de_entrega;
DELIMITER //
CREATE PROCEDURE Calcular_Fecha_de_entrega(
    IN regiduuid VARCHAR(60),
    IN fecha DATE
)
BEGIN
    DECLARE fecha_calculada DATE;
    SET fecha_calculada = DATE_ADD(fecha, INTERVAL 3 DAY);
    IF DAYOFWEEK(fecha_calculada) = 7 THEN
        UPDATE Registros SET FECHA_PROMESA_DE_ENTREGA = DATE_ADD(fecha, INTERVAL 5 DAY) WHERE REGIDUUID = regiduuid;
    ELSEIF DAYOFWEEK(fecha_calculada) = 1 THEN
        UPDATE Registros SET FECHA_PROMESA_DE_ENTREGA = DATE_ADD(fecha, INTERVAL 4 DAY) WHERE REGIDUUID = regiduuid;
    END IF;
END //
DELIMITER ;

-- PROCEDIMIENTO PARA AGREGAR NUEVO PRÉSTAMO DE LIBRO
DROP PROCEDURE IF EXISTS Nuevo_Prestamo;
DELIMITER //
CREATE PROCEDURE Nuevo_Prestamo(
    IN matricula VARCHAR(30),
    IN isbn VARCHAR(100),
    IN cantidad INT
)
BEGIN
    DECLARE libros_disponibles INT;
    DECLARE libros_usuario INT;
    DECLARE fecha DATETIME;
    DECLARE RESULT INT DEFAULT 0;
    DECLARE regiduud VARCHAR(60);
    SET libros_disponibles = (SELECT DISPONIBLES FROM Libros WHERE ISBN = isbn AND `STATUS` = 1 LIMIT 1);
    SET libros_usuario = (SELECT LIBROS_EN_PODER FROM Usuarios WHERE MATRICULA = matricula LIMIT 1);
    SET fecha = current_date();
    
    START TRANSACTION;
    INSERT INTO Prestamos (MATRICULA, ISBN, FECHA_DE_EMISION, INSERTING) VALUES (matricula, isbn, fecha, 1);
    SET regiduud = (SELECT REGIDUUID FROM Prestamos WHERE MATRICULA = matricula AND ISBN = isbn AND INSERTING = 1 LIMIT 1);
    INSERT INTO Registros (REGIDUUID) VALUES (regiduud);
    UPDATE Prestamos SET INSERTING = 0;
    UPDATE Libros SET DISPONIBLES = DISPONIBLES - cantidad WHERE ISBN = isbn;
    UPDATE Usuarios SET LIBROS_EN_PODER = LIBROS_EN_PODER + cantidad WHERE MATRICULA = matricula;
    CALL Calcular_Fecha_de_entrega(regiduud, fecha);
    IF libros_disponibles >= cantidad THEN
        IF libros_usuario <= 2 THEN
            SET RESULT = 1;
            COMMIT;
        ELSE
            SET RESULT = 3;
            ROLLBACK;
        END IF;
    ELSE
        SET RESULT = 2;
        ROLLBACK;
    END IF;
    SELECT RESULT;
END //
DELIMITER ;

-- PROCEDIMIENTO PARA CALCULAR COSTOS DE RETRASO DE PRÉSTAMOS
DROP PROCEDURE IF EXISTS Calcular_Costo_de_prestamo;
DELIMITER //
CREATE PROCEDURE Calcular_Costo_de_prestamo()
BEGIN
    START TRANSACTION;
    UPDATE Registros SET STATUS = 'Retraso' WHERE DATEDIFF(CURRENT_DATE, FECHA_DE_EMISION) > 2;
    UPDATE Registros SET EFECTIVO_GENERADO = DATEDIFF(CURRENT_DATE, FECHA_DE_EMISION) * 10 WHERE DATEDIFF(CURRENT_DATE, FECHA_DE_EMISION) > 2;
    COMMIT;
END //
DELIMITER ;

-- Confirm the script execution
SELECT 'OK' AS RESULT;
 