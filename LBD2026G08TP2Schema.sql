-- =====================================================
-- TRABAJO PRÁCTICO N° 2 - 2026
-- LABORATORIO DE BASES DE DATOS
-- =====================================================
-- Año: 2026 
-- Grupo Nro: 08 
-- Integrantes: Russo Francisco, Huarachi Jorge
-- Tema: Sistema de gestión de pedidos y fidelización de clientes
-- Nombre del Esquema: LBD2026G8RomaLBD
-- Plataforma (SO + Versión): Linux mint
-- Motor y Versión: MySQL Server 8.0
-- GitHub Repositorio: https://github.com/matiasmendiondo/LBD2026G08
-- GitHub Usuario:  russoagustin - Jorgefhh
-- =====================================================

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema RomaLBD
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `LBD2026G08Roma` ;

-- -----------------------------------------------------
-- Schema RomaLBD
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LBD2026G08Roma` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `LBD2026G08Roma` ;

-- -----------------------------------------------------
-- Table `Categorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Categorias` ;

CREATE TABLE IF NOT EXISTS `Categorias` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(50) NOT NULL CHECK (TRIM(`categoria`) <> ''),
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `categoria_UNIQUE` ON `Categorias` (`categoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Subcategorias`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Subcategorias` ;

CREATE TABLE IF NOT EXISTS `Subcategorias` (
  `idSubcategoria` INT NOT NULL AUTO_INCREMENT,
  `idCategoria` INT NOT NULL,
  `subcategoria` VARCHAR(50) NOT NULL CHECK (TRIM(`subcategoria`) <> ''),
  PRIMARY KEY (`idSubcategoria`, `idCategoria`),
  CONSTRAINT `fk_Subcategorias_Categorias`
    FOREIGN KEY (`idCategoria`)
    REFERENCES `Categorias` (`idCategoria`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

CREATE INDEX `fk_Subcategorias_Categorias_idx` ON `Subcategorias` (`idCategoria` ASC) VISIBLE;

/*
	Índice único compuesto entre las columnas subcategoria (nombre de la subcategoria) e idCategoria
    ya que una Categoría no puede tener dos subcategorias con el mismo nombre
*/
CREATE UNIQUE INDEX `Subcategorias_subcategoria_idCategoria_UNIQUE` ON `Subcategorias`(`idCategoria` ASC,`subcategoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Productos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Productos` ;

CREATE TABLE IF NOT EXISTS `Productos` (
  `idProducto` INT NOT NULL AUTO_INCREMENT,
  `producto` VARCHAR(50) NOT NULL CHECK (TRIM(`producto`) <> ''),
  `precioLista` DECIMAL(9,2) NOT NULL,
  `puntos` SMALLINT NOT NULL DEFAULT 0,
  `descripcion` VARCHAR(255) NULL,
  `disponible` TINYINT(1) NOT NULL DEFAULT TRUE,
  `idSubcategoria` INT NOT NULL,
  `idCategoria` INT NOT NULL,
  PRIMARY KEY (`idProducto`),
  CONSTRAINT `fk_Productos_Subcategorias1`
    FOREIGN KEY (`idSubcategoria` , `idCategoria`)
    REFERENCES `Subcategorias` (`idSubcategoria` , `idCategoria`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

CREATE INDEX `fk_Productos_Subcategorias1_idx` ON `Productos` (`idSubcategoria` ASC, `idCategoria` ASC) VISIBLE;
CREATE INDEX `fk_Productos_idSubcategoria_idx` ON `Productos` (`idSubcategoria`) VISIBLE;
CREATE INDEX `fk_Productos_idCategoria_idx` ON `Productos` (`idCategoria`) VISIBLE;

CREATE INDEX `idx_Productos_producto` ON `Productos`(`producto`) VISIBLE;

-- -----------------------------------------------------
-- Table `Usuarios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Usuarios` ;

CREATE TABLE IF NOT EXISTS `Usuarios` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(45) NOT NULL CHECK (TRIM(`nombres`) <> ''),
  `apellidos` VARCHAR(45) NOT NULL CHECK (TRIM(`apellidos`) <> ''),
  `email` VARCHAR(254) NOT NULL CHECK(email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'),
  `username` VARCHAR(45) NOT NULL CHECK (TRIM(`username`) <> ''),
  `contrasenia` CHAR(60) NOT NULL,
  `esMozo` TINYINT(1) NOT NULL DEFAULT FALSE,
  `esAdmin` TINYINT(1) NOT NULL DEFAULT FALSE,
  `fechaNac` DATE NOT NULL,
  `dni` CHAR(8) NOT NULL CHECK(dni REGEXP '^[0-9]{7,8}$'),
  `activo` TINYINT(1) NOT NULL DEFAULT FALSE,
  PRIMARY KEY (`idUsuario`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `Usuarios` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `dni_UNIQUE` ON `Usuarios` (`dni` ASC) VISIBLE;

CREATE UNIQUE INDEX `username_UNIQUE` ON `Usuarios` (`username` ASC) VISIBLE;

/*Índice compuesto entre las columnas apellidos y nombres,
  ya que el sistema puede requerir buscar usuarios por apellido
  o por apellido y nombre en conjunto
*/
CREATE INDEX `idx_Usuarios_apellidos_nombres`  ON `Usuarios` (`nombres` ASC, `apellidos` ASC) VISIBLE;

-- -----------------------------------------------------
-- Table `Clientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Clientes` ;

CREATE TABLE IF NOT EXISTS `Clientes` (
  `idCliente` INT NOT NULL,
  `puntos` SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idCliente`),
  CONSTRAINT `fk_Clientes_Usuarios1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cupones`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Cupones` ;

CREATE TABLE IF NOT EXISTS `Cupones` (
  `idCupon` INT NOT NULL AUTO_INCREMENT,
  `idProducto` INT NOT NULL,
  `descuento` DECIMAL(3,2) NOT NULL,
  `precioPuntos` SMALLINT NOT NULL,
  `fechaExpiracion` DATE NOT NULL,
  PRIMARY KEY (`idCupon`),
  CONSTRAINT `fk_Cupones_Productos1`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Productos` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

CREATE INDEX `fk_Cupones_Productos1_idx` ON `Cupones` (`idProducto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Mesas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Mesas` ;

CREATE TABLE IF NOT EXISTS `Mesas` (
  `idMesa` INT NOT NULL AUTO_INCREMENT,
  `numeroMesa` INT NOT NULL,
  `ubicacion` ENUM('ADENTRO', 'AFUERA') NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT TRUE,
  PRIMARY KEY (`idMesa`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `numeroMesa_UNIQUE` ON `Mesas` (`numeroMesa` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Comandas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Comandas` ;

CREATE TABLE IF NOT EXISTS `Comandas` (
  `idComanda` INT NOT NULL AUTO_INCREMENT,
  `fechaInicio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaFin` DATETIME NULL,
  `cancelada` BOOLEAN NOT NULL DEFAULT FALSE,
  `idCliente` INT NULL,
  `idMozo` INT NULL,
  `idMesa` INT NULL,
  PRIMARY KEY (`idComanda`),
  CONSTRAINT `fk_Comandas_Clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Clientes` (`idCliente`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Comandas_Mesas1`
    FOREIGN KEY (`idMesa`)
    REFERENCES `Mesas` (`idMesa`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Comandas_Usuarios1`
    FOREIGN KEY (`idMozo`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

CREATE INDEX `fk_Comandas_Clientes1_idx` ON `Comandas` (`idCliente` ASC) VISIBLE;

CREATE INDEX `fk_Comandas_Mesas1_idx` ON `Comandas` (`idMesa` ASC) VISIBLE;

CREATE INDEX `fk_Comandas_Usuarios1_idx` ON `Comandas` (`idMozo` ASC) VISIBLE;

CREATE INDEX `idx_Comandas_fechaInicio` ON `Comandas`(`fechaInicio`) VISIBLE;
CREATE INDEX `idx_Comandas_fechaFin` ON `Comandas`(`fechaFin`) VISIBLE;


-- -----------------------------------------------------
-- Table `LineasComandas`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `LineasComandas` ;

CREATE TABLE IF NOT EXISTS `LineasComandas` (
  `idLineasComanda` INT NOT NULL AUTO_INCREMENT,
  `cantidad` SMALLINT NOT NULL,
  `precio` DECIMAL(9,2) NOT NULL,
  `estado` ENUM('PREPARACION', 'CANCELADA', 'COMPLETADO') NOT NULL DEFAULT 'PREPARACION',
  `observaciones` VARCHAR(255) NULL,
  `idComanda` INT NOT NULL,
  `idProducto` INT NOT NULL,
  PRIMARY KEY (`idLineasComanda`),
  CONSTRAINT `fk_LineasComandas_Comandas1`
    FOREIGN KEY (`idComanda`)
    REFERENCES `Comandas` (`idComanda`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_LineasComandas_Productos1`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Productos` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

CREATE INDEX `fk_LineasComandas_Comandas1_idx` ON `LineasComandas` (`idComanda` ASC) VISIBLE;

CREATE INDEX `fk_LineasComandas_Productos1_idx` ON `LineasComandas` (`idProducto` ASC) VISIBLE;

/*
  Índice compuesto entre las columnas idComanda y estado,
  ya que es frecuente consultar los ítems de una comanda filtrados por su estado
  */
CREATE INDEX `idx_LineasComandas_idComanda_estado` ON `LineasComandas` (`idComanda` ASC, `estado` ASC) VISIBLE;

-- -----------------------------------------------------
-- Table `CuponesClientes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `CuponesClientes` ;

CREATE TABLE IF NOT EXISTS `CuponesClientes` (
  `idCupon` INT NOT NULL,
  `idCliente` INT NOT NULL,
  `codigo` BINARY(16) NOT NULL,
  `estado` ENUM('NO USADO', 'USADO', 'EXPIRADO') NOT NULL DEFAULT 'NO USADO',
  `idLineasComanda` INT NULL,
  PRIMARY KEY (`idCupon`, `idCliente`),
  CONSTRAINT `fk_Cupones_has_Clientes_Cupones1`
    FOREIGN KEY (`idCupon`)
    REFERENCES `Cupones` (`idCupon`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Cupones_has_Clientes_Clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Clientes` (`idCliente`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_CuponesClientes_LineasComandas1`
    FOREIGN KEY (`idLineasComanda`)
    REFERENCES `LineasComandas` (`idLineasComanda`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;

CREATE INDEX `fk_Cupones_has_Clientes_Clientes1_idx` ON `CuponesClientes` (`idCliente` ASC) VISIBLE;

CREATE INDEX `fk_Cupones_has_Clientes_Cupones1_idx` ON `CuponesClientes` (`idCupon` ASC) VISIBLE;

CREATE INDEX `fk_CuponesClientes_LineasComandas1_idx` ON `CuponesClientes` (`idLineasComanda` ASC) VISIBLE;

CREATE UNIQUE INDEX `codigo_UNIQUE` ON `CuponesClientes` (`codigo` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
