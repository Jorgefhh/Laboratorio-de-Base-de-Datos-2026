USE LBD2026G08Roma;
/* /////////////////////////////////////////////// PROCEDIMIENTOS ALMACENADOS  ///////////////////////////////////////////////// */

/* 4.--------------- CREACIÓN DE UN USUARIO ---------------*/
DELIMITER //
DROP PROCEDURE IF EXISTS crear_usuario//

CREATE PROCEDURE crear_usuario(
    IN p_nombres VARCHAR(45),
    IN p_apellidos VARCHAR(45),
    IN p_fechaNac DATE,
    IN p_dni CHAR(8),
    IN p_email VARCHAR(255),
    IN p_username VARCHAR(45),
    IN p_contrasenia CHAR(60),  -- Nota: Idealmente ya debe venir encriptada (ej. BCrypt)
    OUT mensaje VARCHAR(255)
)
BEGIN
    DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';
    DECLARE v_idUsuario INT;
    
    -- VALIDACIONES 
    IF (p_nombres IS NULL) OR (p_apellidos IS NULL) OR (p_fechaNac IS NULL) OR (p_dni IS NULL) OR (p_email IS NULL) OR (p_username IS NULL) OR (p_contrasenia IS NULL) THEN
        SET mensaje = 'Error, debe llenar los campos obligatorios';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_nombres) = '') THEN
        SET mensaje = 'Error, el nombre no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_apellidos) = '') THEN
        SET mensaje = 'Error, el apellido no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (p_fechaNac > CURDATE()) THEN
        SET mensaje = 'Error, la fecha de nacimiento no puede ser una fecha futura';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_email) = '') THEN
        SET mensaje = 'Error, el email no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_username) = '') THEN
        SET mensaje = 'Error, el user no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_contrasenia) = '') THEN
        SET mensaje = 'Error, la contraseña no puede ser vacía';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF EXISTS(SELECT 1 FROM Usuarios WHERE dni = p_dni) THEN
        SET mensaje = 'Error, el DNI ya está en uso';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF EXISTS(SELECT 1 FROM Usuarios WHERE username = p_username) THEN
        SET mensaje = 'Error, el username ya está en uso';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF EXISTS(SELECT 1 FROM Usuarios WHERE email = p_email) THEN
        SET mensaje = 'Error, el email ya está registrado';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
    END IF;
    
    BLOQUE_TRANSACTION: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET mensaje = 'Error interno en el servidor al intentar crear el usuario';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        END;
        
        START TRANSACTION;
            INSERT INTO Usuarios (nombres, apellidos, fechaNac, dni, email, username, contrasenia, esMozo, esAdmin, activo)
            VALUES (p_nombres, p_apellidos, p_fechaNac, p_dni, p_email, p_username, p_contrasenia, 0, 0, 0);
            
            SET v_idUsuario = LAST_INSERT_ID(); 
            
            -- Inserto en cliente (por defecto todos los usuarios tienen rol cliente)
            INSERT INTO Clientes(idCliente, puntos) 
            VALUES (v_idUsuario, 0);
        COMMIT;
    END BLOQUE_TRANSACTION;

    -- MENSAJE DE ÉXITO (Solo se llega aquí si no saltó ningún SIGNAL)
    SET mensaje = 'Usuario y cliente creados exitosamente';
    SELECT v_idUsuario AS idUsuarioCreado;
    
END//
-- *LLAMADAS DE PRUEBA * --

/* 5.--------------- MODIFICACIÓN DE UN USUARIO ---------------*/

DROP PROCEDURE IF EXISTS modificar_usuario//

CREATE PROCEDURE modificar_usuario(
    IN p_idUsuario INT,
    IN p_nombres VARCHAR(45),
    IN p_apellidos VARCHAR(45),
    IN p_fechaNac DATE,
    IN p_dni CHAR(8),
    IN p_username VARCHAR(45),
    IN p_contrasenia CHAR(60),  -- Ya debe venir encriptada
    OUT mensaje VARCHAR(255)    -- Nuevo parámetro de salida
)
BEGIN
    DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';
    DECLARE v_dni CHAR(8);
    DECLARE v_username VARCHAR(45);
    
    -- Obtenemos los datos actuales para compararlos
    SELECT dni INTO v_dni FROM Usuarios WHERE idUsuario = p_idUsuario;
    SELECT username INTO v_username FROM Usuarios WHERE idUsuario = p_idUsuario;
    
    -- VALIDACIONES 
    IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE idUsuario = p_idUsuario) THEN
        SET mensaje = 'Usuario no encontrado';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (p_nombres IS NULL) OR (p_apellidos IS NULL) OR (p_fechaNac IS NULL) OR (p_dni IS NULL) OR (p_username IS NULL) OR (p_contrasenia IS NULL) THEN
        SET mensaje = 'Error, debe llenar los campos obligatorios';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_nombres) = '') THEN
        SET mensaje = 'Error, el nombre no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_apellidos) = '') THEN
        SET mensaje = 'Error, el apellido no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (p_fechaNac > CURDATE()) THEN
        SET mensaje = 'Error, la fecha de nacimiento no puede ser una fecha futura';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_username) = '') THEN
        SET mensaje = 'Error, el user no puede ser vacío';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (TRIM(p_contrasenia) = '') THEN
        SET mensaje = 'Error, la contraseña no puede ser vacía';
        SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        
    ELSEIF (p_dni <> v_dni) THEN
        IF EXISTS(SELECT 1 FROM Usuarios WHERE dni = p_dni) THEN
            SET mensaje = 'Error, el DNI ya está en uso';
            SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        END IF;
        
    ELSEIF (v_username <> p_username) THEN
        IF EXISTS(SELECT 1 FROM Usuarios WHERE username = p_username) THEN
            SET mensaje = 'Error, el username ya está en uso';
            SIGNAL datos_invalidos SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        END IF;
    END IF;

    BLOQUE_TRANSACTION: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SET mensaje = 'Error interno en el servidor al intentar modificar el usuario';
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = mensaje, MYSQL_ERRNO = 45000;
        END;
        
        -- Añadido START TRANSACTION para que el ROLLBACK funcione
        START TRANSACTION;
            UPDATE Usuarios 
            SET nombres = p_nombres, 
                apellidos = p_apellidos, 
                fechaNac = p_fechaNac, 
                dni = p_dni, 
                username = p_username, 
                contrasenia = p_contrasenia
            WHERE idUsuario = p_idUsuario;
        -- Añadido COMMIT
        COMMIT;
    END BLOQUE_TRANSACTION;

    -- MENSAJE DE ÉXITO (Solo se llega aquí si no saltó ningún SIGNAL)
    SET mensaje = 'Usuario modificado exitosamente';

END//

-- *LLAMADAS DE PRUEBA * --

/* 6.--------------- BORRAR USUARIO ---------------*/

DELIMITER //
DROP PROCEDURE IF EXISTS borrar_usuario//

CREATE PROCEDURE borrar_usuario(
    IN p_idUsuario INT
)
BEGIN
    DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';  -- Uso un alias para el sqlstate.
    DECLARE v_activo TINYINT(1);

    -- 1. VALIDACIÓN: Verificar si el usuario existe en la BD antes de intentar borrar
    IF NOT EXISTS (  
        SELECT 1  
        FROM Usuarios
        WHERE idUsuario = p_idUsuario
    ) THEN
        SIGNAL datos_invalidos
        SET MESSAGE_TEXT = 'Error: Usuario no encontrado.',
            MYSQL_ERRNO = 45000;
	END IF;
    -- 2. VALIDACIÓN: El usuario DEBE estar dado de baja lógicamente primero
    -- Obtenemos el estado actual del usuario
    SELECT activo INTO v_activo FROM Usuarios WHERE idUsuario = p_idUsuario;

    IF (v_activo = TRUE) THEN
        SIGNAL datos_invalidos
        SET MESSAGE_TEXT = 'Error: No se puede realizar el borrado físico. El usuario debe estar dado de baja lógicamente (activo = FALSE) primero.',
            MYSQL_ERRNO = 45000;
            
    -- 3. VALIDACIÓN DE NEGOCIO: Evitar romper la integridad con posibles Comandas asociadas al usuario a borrar.
    ELSEIF EXISTS (
        SELECT 1 FROM Comandas 
        WHERE idCliente = p_idUsuario OR idMozo = p_idUsuario
    ) THEN
        SIGNAL datos_invalidos
        SET MESSAGE_TEXT = 'Error: No se puede eliminar físicamente el usuario porque tiene comandas asociadas en el sistema.',
            MYSQL_ERRNO = 45000;
    END IF;

    -- 4. BLOQUE TRANSACCIONAL: Borrado en cascada manual controlado
    BLOQUE_DELETE: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error interno: No se pudo realizar el borrado físico del usuario.', MYSQL_ERRNO = 45000;
        END;

        START TRANSACTION;
            -- Eliminamos primero de la tabla CuponesClientes si tuviera cupones asignados
            DELETE FROM CuponesClientes WHERE idCliente = p_idUsuario;

            -- Eliminamos la extensión de rol en la tabla Clientes debido al RESTRICT
            DELETE FROM Clientes WHERE idCliente = p_idUsuario;
            
            -- Finalmente realizamos el borrado físico en la tabla principal
            -- Esto disparará inmediatamente el trigger de borrado para las auditorías.
            DELETE FROM Usuarios WHERE idUsuario = p_idUsuario;
        COMMIT;
    END BLOQUE_DELETE;

    SELECT 'Usuario y sus datos asociados eliminados físicamente del sistema con éxito.' AS Mensaje;
END//

-- *LLAMADAS DE PRUEBA * --
-- FLUJO CORRECTO:
--  Preparamos el escenario insertando un usuario de prueba
INSERT INTO Usuarios (idUsuario, nombres, apellidos, fechaNac, dni, email, username, contrasenia, esMozo, esAdmin, activo)
VALUES (991, 'Test', 'Borrado Exitoso', '2000-01-01', '99999991', 'test1@prueba.com', 'user_delete_ok', 'hash_secreto_1', 0, 0, 0);

-- Insertamos también su extensión obligatoria en Clientes
INSERT INTO Clientes(idCliente, puntos) VALUES (991, 50);

--  Ejecución del flujo correcto (Usuario existe, está inactivo y no tiene comandas)
CALL borrar_usuario(991);

-- Verificación (Debería retornar vacío el SELECT de usuarios y haber impactado en AuditoriaUsuarios)
SELECT * FROM Usuarios WHERE idUsuario = 991;
SELECT * FROM AuditoriaUsuarios WHERE idUsuario = 991 AND tipo = 'BORRADO';

-- FLUJO ALTERNATIVO 1:
-- Preparamos un usuario que se encuentra ACTIVO
INSERT INTO Usuarios (idUsuario, nombres, apellidos, fechaNac, dni, email, username, contrasenia, esMozo, esAdmin, activo)
VALUES (992, 'Test', 'Fallo Activo', '2000-01-01', '99999992', 'test2@prueba.com', 'user_delete_fail1', 'hash_secreto_2', 0, 0, 1);

-- Ejecución (Debe lanzar el error 45000: 'El usuario debe estar dado de baja lógicamente...')
CALL borrar_usuario(992);

-- FLUJO ALTERNATIVO 2:
-- 1. Preparamos el escenario: Usuario inactivo
INSERT INTO Usuarios (idUsuario, nombres, apellidos, fechaNac, dni, email, username, contrasenia, esMozo, esAdmin, activo)
VALUES (993, 'Test', 'Fallo Comanda', '2000-01-01', '99999993', 'test3@prueba.com', 'user_delete_fail2', 'hash_secreto_3', 0, 0, 0);

INSERT INTO Clientes(idCliente, puntos) VALUES (993, 10);

-- 2. Le creamos una comanda asociada en el historial
INSERT INTO Comandas (idComanda, fechaInicio, fechaFin, cancelada, idCliente, idMozo, idMesa)
VALUES (999, NOW(), NOW(), 0, 993, NULL, NULL);

-- 3. Ejecución (Debe lanzar el error 45000: 'No se puede eliminar físicamente ... tiene comandas asociadas')
CALL borrar_usuario(993);


/* 7.--------------- BUSCAR USUARIO ---------------*/

DROP PROCEDURE IF EXISTS buscar_usuario//

CREATE PROCEDURE buscar_usuario(
    IN p_cadena VARCHAR(45)
)
BEGIN
    DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';
    
    IF p_cadena IS NULL OR TRIM(p_cadena) = '' THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error: El término de búsqueda no puede estar vacío.', MYSQL_ERRNO = 45000;
    END IF;

    -- Hago una búsqueda optimizada ya sea por coincidencia exacta o parcial en base a : apellidos, nombres o username
    SELECT idUsuario, nombres, apellidos, email, username, esMozo, esAdmin, fechaNac, dni, activo
    FROM Usuarios
    WHERE apellidos LIKE CONCAT('%', p_cadena, '%')
       OR nombres LIKE CONCAT('%', p_cadena, '%')
       OR username = p_cadena;
END//

-- *LLAMADAS DE PRUEBA * --

-- FLUJO CORRECTO
-- 1. Preparamos el escenario con un apellido particular
INSERT INTO Usuarios (idUsuario, nombres, apellidos, fechaNac, dni, email, username, contrasenia, esMozo, esAdmin, activo)
VALUES (994, 'Gervasio', 'Perez Companc', '1995-05-12', '99999994', 'gervasio@perez.com', 'gervaperez', 'hash_secreto_4', 0, 0, 1);

-- 2. Ejecución buscando un fragmento del apellido (Trae el registro correctamente)
CALL buscar_usuario('Companc');

-- 3. Ejecución buscando por coincidencia exacta de username
CALL buscar_usuario('gervaperez');

-- FLUJO ALTERNATIVO 1
-- Ejecución (Debe lanzar el error 45000: 'El término de búsqueda no puede estar vacío.')
CALL buscar_usuario('   ');

-- FLUJO ALTERNATIVO 2
-- Ejecución (No debe lanzar excepción, simplemente devuelve una estructura de tabla con 0 filas)
CALL buscar_usuario('XYZZY_ID_INVENTADO');

/* ----   8. LISTADO DE PRODUCTOS MÁS VENDIDOS + MONTOS ----*/


-- *LLAMADAS DE PRUEBA * --

/* ---- LISTADO DE TODAS LAS VENTAS DADA UNA CATEGORÍA  + MONTOS ----*/ 


-- *LLAMADAS DE PRUEBA * --

/* ---- PRODCEDMIENTO EXTRA : APLICAR CUPONES A UN PRODUCTO ----*/


-- *LLAMADAS DE PRUEBA * --

DELIMITER ;

/* /////////////////////////////////////////////// TRIGGERS  ///////////////////////////////////////////////// */

/*----------- DEFINICIÓN DE TABLA DE AUDITORÍAS ----------*/

DROP TABLE IF EXISTS `AuditoriaUsuarios` ;

CREATE TABLE IF NOT EXISTS `AuditoriaUsuarios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `email` VARCHAR(254) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `contrasenia` CHAR(60) NOT NULL,
  `esMozo` TINYINT(1) NOT NULL,
  `esAdmin` TINYINT(1) NOT NULL,
  `fechaNac` DATE NOT NULL,
  `dni` CHAR(8) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT FALSE,
  `tipo` ENUM('INSERCION', 'MODIFICACION', 'BORRADO') NOT NULL,
  `usuario` VARCHAR(45) NOT NULL,
  `maquina` VARCHAR(45) NOT NULL,
  `fecha` DATETIME NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


/* --------------- TRIGGER INSERCIÓN ---------------*/
DELIMITER // 
DROP TRIGGER IF EXISTS `Trig_Usuarios_Insercion`//
CREATE TRIGGER `Trig_Usuarios_Insercion`
AFTER INSERT ON `Usuarios` FOR EACH ROW
BEGIN
	INSERT INTO `AuditoriaUsuarios` VALUES (
		DEFAULT,
		NEW.idUsuario,
        NEW.nombres,
        NEW.apellidos,
        NEW.email,
        NEW.username,
        NEW.contrasenia,
        NEW.esMozo,
        NEW.esAdmin,
        NEW.fechaNac,
        NEW.dni,
        NEW.activo,
        'INSERCION',
        SUBSTRING_INDEX(USER(),'@',1),
        SUBSTRING_INDEX(USER(),'@',-1),
        NOW()
    );
END //

/* --------------- TRIGGER MODIFICACIÓN  ---------------*/
DROP TRIGGER IF EXISTS `Trig_Usuarios_Modificacion`//
CREATE TRIGGER `Trig_Usuarios_Modificacion`
AFTER UPDATE ON `Usuarios` FOR EACH ROW
BEGIN
	INSERT INTO `AuditoriaUsuarios` VALUES (
		DEFAULT,
		OLD.idUsuario,
        OLD.nombres,
        OLD.apellidos,
        OLD.email,
        OLD.username,
        OLD.contrasenia,
        OLD.esMozo,
        OLD.esAdmin,
        OLD.fechaNac,
        OLD.dni,
        OLD.activo,
        'MODIFICACION',
        SUBSTRING_INDEX(USER(),'@',1),
        SUBSTRING_INDEX(USER(),'@',-1),
        NOW()
    );
    	INSERT INTO `AuditoriaUsuarios` VALUES (
		DEFAULT,
		NEW.idUsuario,
        NEW.nombres,
        NEW.apellidos,
        NEW.email,
        NEW.username,
        NEW.contrasenia,
        NEW.esMozo,
        NEW.esAdmin,
        NEW.fechaNac,
        NEW.dni,
        NEW.activo,
        'MODIFICACION',
        SUBSTRING_INDEX(USER(),'@',1),
        SUBSTRING_INDEX(USER(),'@',-1),
        NOW()
    );
END //


/* -----------  TRIGGER BORRADO   -----------  */
DROP TRIGGER IF EXISTS `Trig_Usuarios_Borrado`//
CREATE TRIGGER `Trig_Usuarios_Borrado`
AFTER DELETE ON `Usuarios` FOR EACH ROW
BEGIN
    INSERT INTO `AuditoriaUsuarios` VALUES (
        DEFAULT,
        OLD.idUsuario,
        OLD.nombres,
        OLD.apellidos,
        OLD.email,
        OLD.username,
        OLD.contrasenia,
        OLD.esMozo,
        OLD.esAdmin,
        OLD.fechaNac,
        OLD.dni,
        OLD.activo,
        'BORRADO',
        SUBSTRING_INDEX(USER(),'@',1),
        SUBSTRING_INDEX(USER(),'@',-1),
        NOW()
    );
END //


DELIMITER ;