-- MySQL Workbench Forward Engineering

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
  `idCategoria` INT NOT NULL,
  `categoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idCategoria`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `categoria_UNIQUE` ON `Categorias` (`categoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Subcategorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Subcategorias` (
  `idSubcategoria` INT NOT NULL,
  `Categorias_idCategoria` INT NOT NULL,
  `subcategoria` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idSubcategoria`, `Categorias_idCategoria`),
  CONSTRAINT `fk_Subcategorias_Categorias`
    FOREIGN KEY (`Categorias_idCategoria`)
    REFERENCES `Categorias` (`idCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Subcategorias_Categorias_idx` ON `Subcategorias` (`Categorias_idCategoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Productos` (
  `idProducto` INT NOT NULL,
  `producto` VARCHAR(50) NOT NULL,
  `precioLista` DECIMAL(9,2) NOT NULL,
  `puntos` SMALLINT NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `disponible` TINYINT(1) NOT NULL,
  `Subcategorias_idSubcategoria` INT NOT NULL,
  `Subcategorias_Categorias_idCategoria` INT NOT NULL,
  PRIMARY KEY (`idProducto`),
  CONSTRAINT `fk_Productos_Subcategorias1`
    FOREIGN KEY (`Subcategorias_idSubcategoria` , `Subcategorias_Categorias_idCategoria`)
    REFERENCES `Subcategorias` (`idSubcategoria` , `Categorias_idCategoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Productos_Subcategorias1_idx` ON `Productos` (`Subcategorias_idSubcategoria` ASC, `Subcategorias_Categorias_idCategoria` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Usuarios` (
  `idUsuario` INT NOT NULL,
  `nombres` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `email` VARCHAR(254) NOT NULL,
  `contrasenia` VARCHAR(45) NOT NULL,
  `rol` VARCHAR(45) NULL,
  `fechaNac` DATE NOT NULL,
  `dni` CHAR(8) NOT NULL,
  `activo` TINYINT(1) NOT NULL,
  PRIMARY KEY (`idUsuario`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `email_UNIQUE` ON `Usuarios` (`email` ASC) VISIBLE;

CREATE UNIQUE INDEX `dni_UNIQUE` ON `Usuarios` (`dni` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Clientes` (
  `puntos` SMALLINT NOT NULL DEFAULT 0,
  `Usuarios_idUsuario` INT NOT NULL,
  PRIMARY KEY (`Usuarios_idUsuario`),
  CONSTRAINT `fk_Clientes_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuario`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mozos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mozos` (
  `Usuarios_idUsuario` INT NOT NULL,
  PRIMARY KEY (`Usuarios_idUsuario`),
  CONSTRAINT `fk_Mozos_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuario`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Administradores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Administradores` (
  `Usuarios_idUsuario` INT NOT NULL,
  PRIMARY KEY (`Usuarios_idUsuario`),
  CONSTRAINT `fk_Administradores_Usuarios1`
    FOREIGN KEY (`Usuarios_idUsuario`)
    REFERENCES `Usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Cupones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cupones` (
  `idCupon` INT NOT NULL,
  `descuento` DECIMAL(3,2) NOT NULL,
  `precioPuntos` SMALLINT NOT NULL,
  `fechaExpiracion` DATE NOT NULL,
  `Productos_idProducto` INT NOT NULL,
  PRIMARY KEY (`idCupon`),
  CONSTRAINT `fk_Cupones_Productos1`
    FOREIGN KEY (`Productos_idProducto`)
    REFERENCES `Productos` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Cupones_Productos1_idx` ON `Cupones` (`Productos_idProducto` ASC) VISIBLE;


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
  `idComanda` INT NOT NULL,
  `fechaInicio` DATETIME NOT NULL,
  `fechaFin` DATETIME NULL,
  `Clientes_Usuarios_idUsuario` INT NULL,
  `Mozos_Usuarios_idUsuario` INT NULL,
  `Mesas_numeroMesa` INT NULL,
  PRIMARY KEY (`idComanda`),
  CONSTRAINT `fk_Comandas_Clientes1`
    FOREIGN KEY (`Clientes_Usuarios_idUsuario`)
    REFERENCES `Clientes` (`Usuarios_idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comandas_Mozos1`
    FOREIGN KEY (`Mozos_Usuarios_idUsuario`)
    REFERENCES `Mozos` (`Usuarios_idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comandas_Mesas1`
    FOREIGN KEY (`Mesas_numeroMesa`)
    REFERENCES `Mesas` (`numeroMesa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Comandas_Clientes1_idx` ON `Comandas` (`Clientes_Usuarios_idUsuario` ASC) VISIBLE;

CREATE INDEX `fk_Comandas_Mozos1_idx` ON `Comandas` (`Mozos_Usuarios_idUsuario` ASC) VISIBLE;

CREATE INDEX `fk_Comandas_Mesas1_idx` ON `Comandas` (`Mesas_numeroMesa` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `LineasComandas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LineasComandas` (
  `idLineasComanda` INT NOT NULL,
  `cantidad` SMALLINT NOT NULL,
  `precio` DECIMAL(9,2) NOT NULL,
  `estado` ENUM('PREPARACION', 'COMPLETADO') NOT NULL,
  `observaciones` VARCHAR(255) NULL,
  `Comandas_idComanda` INT NOT NULL,
  `Productos_idProducto` INT NOT NULL,
  PRIMARY KEY (`idLineasComanda`),
  CONSTRAINT `fk_LineasComandas_Comandas1`
    FOREIGN KEY (`Comandas_idComanda`)
    REFERENCES `Comandas` (`idComanda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_LineasComandas_Productos1`
    FOREIGN KEY (`Productos_idProducto`)
    REFERENCES `Productos` (`idProducto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_LineasComandas_Comandas1_idx` ON `LineasComandas` (`Comandas_idComanda` ASC) VISIBLE;

CREATE INDEX `fk_LineasComandas_Productos1_idx` ON `LineasComandas` (`Productos_idProducto` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `CuponesClientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CuponesClientes` (
  `Cupones_idCupon` INT NOT NULL,
  `Clientes_Usuarios_idUsuario` INT NOT NULL,
  `estado` ENUM('NO USADO', 'USADO', 'EXPIRADO') NOT NULL,
  `LineasComandas_idLineasComanda` INT NULL,
  PRIMARY KEY (`Cupones_idCupon`, `Clientes_Usuarios_idUsuario`),
  CONSTRAINT `fk_Cupones_has_Clientes_Cupones1`
    FOREIGN KEY (`Cupones_idCupon`)
    REFERENCES `Cupones` (`idCupon`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cupones_has_Clientes_Clientes1`
    FOREIGN KEY (`Clientes_Usuarios_idUsuario`)
    REFERENCES `Clientes` (`Usuarios_idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_CuponesClientes_LineasComandas1`
    FOREIGN KEY (`LineasComandas_idLineasComanda`)
    REFERENCES `LineasComandas` (`idLineasComanda`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Cupones_has_Clientes_Clientes1_idx` ON `CuponesClientes` (`Clientes_Usuarios_idUsuario` ASC) VISIBLE;

CREATE INDEX `fk_Cupones_has_Clientes_Cupones1_idx` ON `CuponesClientes` (`Cupones_idCupon` ASC) VISIBLE;

CREATE INDEX `fk_CuponesClientes_LineasComandas1_idx` ON `CuponesClientes` (`LineasComandas_idLineasComanda` ASC) VISIBLE;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


