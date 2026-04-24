-- MySQL Workbench Forward Engineering

-- =====================================================
-- TRABAJO PRÁCTICO N° 1 - 2026
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


SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema RomaLBD
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `RomaLBD` ;

-- -----------------------------------------------------
-- Schema RomaLBD
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `RomaLBD` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `RomaLBD` ;

-- -----------------------------------------------------
-- Table `Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Categorias` (
  `idCategoria` INT NOT NULL AUTO_INCREMENT,
  `categoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `categoria_UNIQUE` ON `Categorias` (`categoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Subcategorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Subcategorias` (
  `idSubcategoria` INT NOT NULL AUTO_INCREMENT,
  `idCategoria` INT NOT NULL,
  `subcategoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idSubcategoria`, `idCategoria`),
  CONSTRAINT `fk_Subcategorias_Categorias`
    FOREIGN KEY (`idCategoria`)
    REFERENCES `Categorias` (`idCategoria`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Subcategorias_Categorias_idx` ON `Subcategorias` (`idCategoria` ASC) VISIBLE;
/*Indice único comuesto entre las columnas subcategoria (nombre de la subcategoria) e idCategoria
  ya que una Categoria no puede tener dos subcategorias con el mismo nombre.
*/
CREATE UNIQUE INDEX `uq_Subcategorias_subcategoria_idCategoria` ON `Subcategorias`(`idCategoria`,`subcategoria` ASC) VISIBLE;

-- -----------------------------------------------------
-- Table `Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos` (
  `idProducto` INT NOT NULL AUTO_INCREMENT,
  `producto` VARCHAR(50) NOT NULL,
  `precioLista` DECIMAL(9,2) NOT NULL,
  `puntos` SMALLINT NOT NULL DEFAULT 0,
  `descripcion` VARCHAR(255) NULL,
  `disponible` TINYINT(1) NOT NULL,
  `idSubcategoria` INT NOT NULL,
  `idCategoria` INT NOT NULL,
  PRIMARY KEY (`idProducto`),
  CONSTRAINT `fk_Productos_Subcategorias1`
    FOREIGN KEY (`idSubcategoria` , `idCategoria`)
    REFERENCES `Subcategorias` (`idSubcategoria` , `idCategoria`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Productos_Subcategorias1_idx` ON `Productos` (`idSubcategoria` ASC, `idCategoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Usuarios` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `email` VARCHAR(254) NOT NULL CHECK(email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'),
  `username` VARCHAR(45) NOT NULL,
  `contrasenia` VARCHAR(45) NOT NULL,
  `esAdmin` TINYINT(1) NOT NULL,
  `fechaNac` DATE NOT NULL,
  `dni` CHAR(8) NOT NULL CHECK(dni REGEXP '^[0-9]{7,8}$'),
  `activo` TINYINT(1) NOT NULL,
  PRIMARY KEY (`idUsuario`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `Usuarios` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `dni_UNIQUE` ON `Usuarios` (`dni` ASC) VISIBLE;

CREATE UNIQUE INDEX `username_UNIQUE` ON `Usuarios` (`username` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes` (
  `puntos` SMALLINT NOT NULL DEFAULT 0,
  `idUsuario` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `fk_Clientes_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mozos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mozos` (
  `idUsuario` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  CONSTRAINT `fk_Mozos_Usuarios1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cupones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cupones` (
  `idCupon` INT NOT NULL AUTO_INCREMENT,
  `descuento` DECIMAL(3,2) NOT NULL,
  `precioPuntos` SMALLINT NOT NULL,
  `fechaExpiracion` DATE NOT NULL,
  `idProducto` INT NOT NULL,
  PRIMARY KEY (`idCupon`),
  CONSTRAINT `fk_Cupones_Productos1`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Productos` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Cupones_Productos1_idx` ON `Cupones` (`idProducto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Mesas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mesas` (
  `numeroMesa` INT NOT NULL,
  `ubicacion` ENUM('ADENTRO', 'AFUERA') NOT NULL,
  `activo` TINYINT(1) NOT NULL,
  PRIMARY KEY (`numeroMesa`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Comandas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Comandas` (
  `idComanda` INT NOT NULL AUTO_INCREMENT,
  `fechaInicio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaFin` DATETIME NULL,
  `cancelada` BOOLEAN NOT NULL DEFAULT FALSE,
  `idCliente` INT NULL,
  `idMozo` INT NULL,
  `numeroMesa` INT NULL,
  PRIMARY KEY (`idComanda`),
  CONSTRAINT `fk_Comandas_Clientes1`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Clientes` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comandas_Mozos1`
    FOREIGN KEY (`idMozo`)
    REFERENCES `Mozos` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comandas_Mesas1`
    FOREIGN KEY (`numeroMesa`)
    REFERENCES `Mesas` (`numeroMesa`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Comandas_Clientes1_idx` ON `Comandas` (`idCliente` ASC) VISIBLE;

CREATE INDEX `fk_Comandas_Mozos1_idx` ON `Comandas` (`idMozo` ASC) VISIBLE;

CREATE INDEX `fk_Comandas_Mesas1_idx` ON `Comandas` (`numeroMesa` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LineasComandas`
-- -----------------------------------------------------
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
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LineasComandas_Productos1`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Productos` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_LineasComandas_Comandas1_idx` ON `LineasComandas` (`idComanda` ASC) VISIBLE;

CREATE INDEX `fk_LineasComandas_Productos1_idx` ON `LineasComandas` (`idProducto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `CuponesClientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CuponesClientes` (
  `Cupones_idCupon` INT NOT NULL,
  `Clientes_Usuarios_idUsuario` INT NOT NULL,
  `codigo` BINARY(16) NOT NULL UNIQUE,
  `estado` ENUM('NO USADO', 'USADO', 'EXPIRADO') NOT NULL DEFAULT 'NO USADO',
  `idLineasComanda` INT NULL,
  PRIMARY KEY (`Cupones_idCupon`, `Clientes_Usuarios_idUsuario`),
  CONSTRAINT `fk_Cupones_has_Clientes_Cupones1`
    FOREIGN KEY (`Cupones_idCupon`)
    REFERENCES `Cupones` (`idCupon`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cupones_has_Clientes_Clientes1`
    FOREIGN KEY (`Clientes_Usuarios_idUsuario`)
    REFERENCES `Clientes` (`idUsuario`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CuponesClientes_LineasComandas1`
    FOREIGN KEY (`idLineasComanda`)
    REFERENCES `LineasComandas` (`idLineasComanda`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Cupones_has_Clientes_Clientes1_idx` ON `CuponesClientes` (`Clientes_Usuarios_idUsuario` ASC) VISIBLE;

CREATE INDEX `fk_Cupones_has_Clientes_Cupones1_idx` ON `CuponesClientes` (`Cupones_idCupon` ASC) VISIBLE;

CREATE INDEX `fk_CuponesClientes_LineasComandas1_idx` ON `CuponesClientes` (`idLineasComanda` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
