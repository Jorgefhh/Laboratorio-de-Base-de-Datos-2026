USE LBD2026G08Roma;


-- CREACIÓN DE UN USUARIO
DELIMITER //
DROP PROCEDURE IF EXISTS crear_usuario//

CREATE PROCEDURE crear_usuario(
    IN p_nombres VARCHAR(45),
    IN p_apellidos VARCHAR(45),
    IN p_fechaNac DATE,
    IN p_dni CHAR(8),
    IN p_email VARCHAR(255),
    IN p_username VARCHAR(45),
    IN p_contrasenia CHAR(60)  -- Nota: Idealmente ya debe venir encriptada (ej. BCrypt)
)
BEGIN
    DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';
    DECLARE v_idUsuario INT;
    
    -- VALIDACIONES 
    IF (p_nombres IS NULL) OR (p_apellidos IS NULL) OR (p_fechaNac IS NULL) OR (p_dni IS NULL) OR (p_email IS NULL) OR (p_username IS NULL) OR (p_contrasenia IS NULL) THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, debe llenar los campos obligatorios', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_nombres) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el nombre no puede ser vacío', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_apellidos) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el apellido no puede ser vacío', MYSQL_ERRNO = 45000;
	ELSEIF (p_fechaNac > CURDATE()) THEN
		SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, la fecha de nacimiento no puede ser una fecha futura', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_email) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el email no puede ser vacío', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_username) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el user no puede ser vacío', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_contrasenia) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, la contraseña no puede ser vacía', MYSQL_ERRNO = 45000;
    ELSEIF EXISTS(SELECT 1 FROM Usuarios WHERE username = p_username) THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el username ya está en uso', MYSQL_ERRNO = 45000;
    ELSEIF EXISTS(SELECT 1 FROM Usuarios WHERE email = p_email) THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el email ya está registrado', MYSQL_ERRNO = 45000;
    END IF;
    
    BLOQUE_TRANSACTION: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error interno en el servidor', MYSQL_ERRNO = 45000;
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

    SELECT v_idUsuario AS idUsuarioCreado;
END//

DELIMITER ;

-- MODIFICACIÓN DE UN USUARIO
DELIMITER //
DROP PROCEDURE IF EXISTS modificar_usuario//

CREATE PROCEDURE modificar_usuario(
	IN p_idUsuario INT,
    IN p_nombres VARCHAR(45),
    IN p_apellidos VARCHAR(45),
    IN p_fechaNac DATE,
    IN p_dni CHAR(8),
    IN p_username VARCHAR(45),
    IN p_contrasenia CHAR(60)  -- Ya debe venir encriptada (ej. BCrypt)
)
BEGIN
    DECLARE datos_invalidos CONDITION FOR SQLSTATE '45000';
    DECLARE v_idUsuario INT;
    DECLARE v_username VARCHAR(45);
    SELECT username INTO v_username FROM Usuarios WHERE idUsuario = p_idUsuario;
    
    -- VALIDACIONES 
    IF (SELECT 0 FROM Usuarios WHERE idUsuario = p_idUsuario) THEN
		SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Usuario no encontrado', MYSQL_ERRNO = 45000;
    ELSEIF (p_nombres IS NULL) OR (p_apellidos IS NULL) OR (p_fechaNac IS NULL) OR (p_dni IS NULL) OR (p_username IS NULL) OR (p_contrasenia IS NULL) THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, debe llenar los campos obligatorios', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_nombres) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el nombre no puede ser vacío', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_apellidos) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el apellido no puede ser vacío', MYSQL_ERRNO = 45000;
	ELSEIF (p_fechaNac > CURDATE()) THEN
		SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, la fecha de nacimiento no puede ser una fecha futura', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_username) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el user no puede ser vacío', MYSQL_ERRNO = 45000;
    ELSEIF (TRIM(p_contrasenia) = '') THEN
        SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, la contraseña no puede ser vacía', MYSQL_ERRNO = 45000;
	ELSEIF (v_username <> p_username) THEN
		IF EXISTS(SELECT 1 FROM Usuarios WHERE username = p_username) THEN
			SIGNAL datos_invalidos SET MESSAGE_TEXT = 'Error, el username ya está en uso', MYSQL_ERRNO = 45000;
		END IF;
    END IF;

    
    BLOQUE_TRANSACTION: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error interno en el servidor', MYSQL_ERRNO = 45000;
    END;
    START TRANSACTION;
        UPDATE Usuarios SET nombres = p_nombres, apellidos = p_apellidos, fechaNac = p_fechaNac, dni = p_dni, username = p_username, contrasenia = p_contrasenia
		WHERE idUsuario = p_idUsuario;
        
    COMMIT;
    END BLOQUE_TRANSACTION;

END//

DELIMITER ;