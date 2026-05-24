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

USE `LBD2026G08`;

-- =====================================================
-- 0. LIMPIEZA DE TABLAS
-- =====================================================
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE `CuponesClientes`;
TRUNCATE TABLE `LineasComandas`;
TRUNCATE TABLE `Comandas`;
TRUNCATE TABLE `Mesas`;
TRUNCATE TABLE `Cupones`;
TRUNCATE TABLE `Clientes`;
TRUNCATE TABLE `Usuarios`;
TRUNCATE TABLE `Productos`;
TRUNCATE TABLE `Subcategorias`;
TRUNCATE TABLE `Categorias`;
SET FOREIGN_KEY_CHECKS = 1;

-- =====================================================
-- 1. TABLA: Categorias
-- =====================================================
INSERT INTO `Categorias` (`idCategoria`, `categoria`) VALUES
(1, 'HAMBURGUESAS'),
(2, 'PAPAS'),
(3, 'PIZZAS INDIVIDUALES'),
(4, 'SANDWICHES DE MILANESA'),
(5, 'LOMITOS'),
(6, 'ENSALADAS'),
(7, 'BEBIDAS SIN ALCOHOL'),
(8, 'TRAGOS Y CÓCTELES'),
(9, 'CERVEZA ARTESANAL TIRADA'),
(10, 'CERVEZA INDUSTRIALES'),
(11, 'VINOS'),
(12, 'POSTRES HELADOS'),
(13, 'HAPPY HOUR'),
(14, 'ENTRETENIMIENTO');

-- =====================================================
-- 2. TABLA: Subcategorias
-- =====================================================
INSERT INTO `Subcategorias` (`idCategoria`, `subcategoria`) VALUES
-- GENERALES
(1, 'GENERAL'), (2, 'GENERAL'), (3, 'GENERAL'), (4, 'GENERAL'), (5, 'GENERAL'),
(6, 'GENERAL'), (7, 'GENERAL'), (8, 'GENERAL'), (9, 'GENERAL'), (10, 'GENERAL'),
(11, 'GENERAL'), (12, 'GENERAL'), (13, 'GENERAL'), (14, 'GENERAL'),
-- ESPECÍFICAS
(1, 'AGREGADOS'),
(11, 'VINOS FINOS DE BODEGA'),
(11, 'TINTO 3/4'),
(11, 'BLANCO 3/4'),
(11, 'ESPUMANTE 3/4'),
(11, 'VINO TIRADO BEET');

-- =====================================================
-- 3. TABLA: Productos
-- =====================================================
INSERT INTO `Productos` (`idProducto`, `producto`, `precioLista`, `puntos`, `descripcion`, `disponible`, `idSubcategoria`, `dCategoria`) VALUES
(1, 'Hamburguesa Roma Completa', 6500.00, 50, 'Medallón 180g, queso, lechuga, tomate y aderezo', 1, 1, 1),
(2, 'Doble Bacon Burger', 7800.00, 70, 'Doble carne, mucho bacon, cheddar y barbacoa', 1, 1, 1),
(3, 'Medallón Extra', 1800.00, 10, 'Añade un medallón extra a tu hamburguesa', 1, 15, 1),
(4, 'Baño de Cheddar', 1300.00, 10, 'Piscina de queso cheddar fundido', 1, 15, 1),
(5, 'Papas Fritas Medianas', 3200.00, 25, 'Papas bastón crujientes', 1, 2, 2),
(6, 'Papas Roma con Verdeo', 4800.00, 40, 'Papas con crema de verdeo y panceta', 1, 2, 2),
(7, 'Pizza Individual Muzzarella', 4500.00, 35, 'Salsa de tomate, muzzarella y aceitunas', 1, 3, 3),
(8, 'Pizza Individual Fugazzeta', 4900.00, 40, 'Muzzarella y abundante cebolla saltada', 1, 3, 3),
(9, 'Sándwich de Milanesa Completo', 5800.00, 50, 'Milanesa de carne, lechuga, tomate y huevo frito', 1, 4, 4),
(10, 'Lomito Clásico', 7200.00, 65, 'Lomo, queso, jamón, huevo, lechuga y tomate', 1, 5, 5),
(11, 'Ensalada César', 3900.00, 30, 'Lechuga, pollo croton, parmesano y aderezo césar', 1, 6, 6),
(12, 'Gaseosa Línea Coca Cola 500ml', 1500.00, 10, 'Botella descartable', 1, 7, 7),
(13, 'Agua Mineral 500ml', 1200.00, 5, 'Con o sin gas', 1, 7, 7),
(14, 'Fernet Branca Viajero', 4000.00, 30, 'Fernet con Coca Cola en vaso trago largo', 1, 8, 8),
(15, 'Negroni Classico', 4200.00, 35, 'Gin, Campari y Vermouth Rosso', 1, 8, 8),
(16, 'Pinta IPA Artesanal', 3100.00, 25, 'Cerveza con intenso amargor y aroma a lúpulo', 1, 9, 9),
(17, 'Pinta Honey', 3100.00, 25, 'Cerveza suave con un toque de miel', 1, 9, 9),
(18, 'Cerveza Stella Artois 1L', 4500.00, 35, 'Botella de litro no retornable', 1, 10, 10),
(19, 'Vino Tinto de la Casa', 3200.00, 20, 'Copa de vino tinto común', 1, 11, 11),
(20, 'Rutini Malbec 750ml', 19500.00, 150, 'Vino de alta gama', 1, 16, 11),
(21, 'Alamos Malbec 750ml', 7500.00, 60, 'Vino Tinto Frutado 3/4', 1, 17, 11),
(22, 'Cafayate Torrontés 750ml', 5800.00, 45, 'Vino Blanco Dulce Natural', 1, 18, 11),
(23, 'Chandon Extra Brut 750ml', 12500.00, 90, 'Espumante ideal para brindar', 1, 19, 11),
(24, 'Copa Tirada Beet', 3800.00, 30, 'Vino tirado directamente del barril', 1, 20, 11),
(25, 'Copa Helada Roma', 2800.00, 20, 'Dos bochas a elección con salsa de chocolate', 1, 12, 12),
(26, '2x1 Copas de Fernet (HH)', 4000.00, 30, 'Válido de 18:00 a 20:00 hs', 1, 13, 13),
(27, 'Ficha de Pool', 1000.00, 5, 'Ficha para mesa de billar/pool', 1, 14, 14);

-- =====================================================
-- 4. TABLA: Usuarios (25 Usuarios)
-- =====================================================
INSERT INTO `Usuarios` (`idUsuario`, `nombres`, `apellidos`, `email`, `username`, `contrasenia`, `esMozo`, `esAdmin`, `fechaNac`, `dni`, `activo`) VALUES
(1, 'Carlos Admin', 'Gomez', 'carlos.admin@romalbd.com', 'admin_carlos', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefghijklmnop', 0, 1, '1988-05-12', '33444555', 1),
(2, 'Juan Mozo', 'Perez', 'juan.mozo@romalbd.com', 'mozo_juan', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefghijklmnop', 1, 0, '1995-09-23', '39111222', 1),
(3, 'María Moza', 'Rodriguez', 'maria.moza@romalbd.com', 'moza_maria', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefghijklmnop', 1, 0, '1998-02-02', '41000999', 1),
(4, 'Diego Nicolas', 'Maradona', 'dieguito10@gmail.com', 'diegote', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefghijklmnop', 0, 0, '1960-10-30', '14222333', 1),
(5, 'Lionel Andres', 'Messi', 'leomessi10@hotmail.com', 'lapulga', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefghijklmnop', 0, 0, '1987-06-24', '33010010', 1),
(6, 'Laura', 'García', 'laura.garcia@mail.com', 'lau_garcia', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1990-04-15', '35123456', 1),
(7, 'Martin', 'Lopez', 'martin.lopez@mail.com', 'marto_l', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1992-08-20', '36234567', 1),
(8, 'Sofia', 'Martinez', 'sofia.m@mail.com', 'sofi_m', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1988-11-03', '34345678', 1),
(9, 'Pedro', 'Alvarez', 'pedro.alv@mail.com', 'pedro_a', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1995-01-25', '39456789', 1),
(10, 'Lucia', 'Fernandez', 'lucia.f@mail.com', 'lu_fer', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1997-07-10', '40567890', 1),
(11, 'Matias', 'Gomez', 'mati.gomez@mail.com', 'mati_g', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1993-05-18', '37678901', 1),
(12, 'Valeria', 'Diaz', 'vale.diaz@mail.com', 'vale_d', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1991-09-30', '36789012', 1),
(13, 'Joaquin', 'Perez', 'joaquin.p@mail.com', 'joaq_p', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1985-12-12', '31890123', 1),
(14, 'Camila', 'Sanchez', 'cami.sanchez@mail.com', 'cami_s', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1999-03-22', '42901234', 1),
(15, 'Facundo', 'Romero', 'facu.romero@mail.com', 'facu_r', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1994-06-05', '38012345', 1),
(16, 'Florencia', 'Sosa', 'flor.sosa@mail.com', 'flor_s', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1996-02-14', '39123450', 1),
(17, 'Gonzalo', 'Torres', 'gonza.torres@mail.com', 'gonza_t', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1989-10-08', '34234561', 1),
(18, 'Agustina', 'Ruiz', 'agus.ruiz@mail.com', 'agus_r', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1998-08-19', '41345672', 1),
(19, 'Emiliano', 'Castro', 'emi.castro@mail.com', 'emi_c', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1990-11-27', '35456783', 1),
(20, 'Micaela', 'Luna', 'mica.luna@mail.com', 'mica_l', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1995-04-02', '39567894', 1),
(21, 'Tomas', 'Herrera', 'tomi.herrera@mail.com', 'tomi_h', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1992-01-15', '36678905', 1),
(22, 'Rocio', 'Molina', 'rocio.molina@mail.com', 'ro_molina', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1997-09-09', '40789016', 1),
(23, 'Nicolas', 'Silva', 'nico.silva@mail.com', 'nico_s', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1987-05-21', '33890127', 1),
(24, 'Julieta', 'Guzman', 'juli.guzman@mail.com', 'juli_g', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1994-12-06', '38901238', 1),
(25, 'Mariano', 'Rios', 'marian.rios@mail.com', 'marian_r', '$2a$12$K39b7dfXyZ8hN9v2K7jLe.uXWbM1234567890abcdefg', 0, 0, '1991-03-31', '36012349', 1);

-- =====================================================
-- 5. TABLA: Clientes (22 Clientes)
-- =====================================================
INSERT INTO `Clientes` (`idCliente`, `puntos`) VALUES
(4, 350), (5, 1200), (6, 450), (7, 120), (8, 890), (9, 30), 
(10, 500), (11, 210), (12, 1000), (13, 0), (14, 340), (15, 670),
(16, 150), (17, 80), (18, 920), (19, 45), (20, 260), (21, 710), 
(22, 55), (23, 1100), (24, 390), (25, 15);

-- =====================================================
-- 6. TABLA: Mesas
-- =====================================================
INSERT INTO `Mesas` (`idMesa`, `numeroMesa`, `ubicacion`, `activo`) VALUES
(1, 1, 'ADENTRO', 1), (2, 2, 'ADENTRO', 1), (3, 3, 'ADENTRO', 1),
(4, 4, 'AFUERA', 1), (5, 5, 'AFUERA', 1),(6, 6, 'ADENTRO', 1),
(7, 7, 'ADENTRO', 1),(8, 8, 'ADENTRO', 1), (9, 9, 'ADENTRO', 1);

-- =====================================================
-- 7. TABLA: Cupones (23 Cupones)
-- =====================================================
INSERT INTO `Cupones` (`idCupon`, `idProducto`, `descuento`, `precioPuntos`, `fechaExpiracion`) VALUES
(1, 2, 0.20, 150, '2026-12-31'), (2, 6, 0.50, 200, '2026-08-15'), (3, 20, 0.15, 500, '2026-06-01'),
(4, 1, 0.15, 100, '2026-12-01'), (5, 3, 0.50, 50, '2026-10-15'), (6, 5, 0.25, 80, '2026-09-30'), 
(7, 7, 0.10, 90, '2026-11-20'), (8, 9, 0.20, 150, '2026-08-25'), (9, 11, 0.15, 70, '2026-12-31'),
(10, 12, 0.30, 40, '2026-07-10'), (11, 14, 0.10, 120, '2026-09-05'), (12, 16, 0.25, 110, '2026-10-20'), 
(13, 18, 0.15, 130, '2026-11-15'), (14, 21, 0.20, 250, '2026-12-10'), (15, 23, 0.10, 300, '2027-01-01'),
(16, 25, 0.50, 90, '2026-08-30'), (17, 26, 0.15, 100, '2026-09-15'), (18, 27, 0.20, 30, '2026-10-31'), 
(19, 2, 0.25, 180, '2026-11-25'), (20, 4, 0.40, 60, '2026-12-05'), (21, 6, 0.15, 140, '2026-07-20'),
(22, 8, 0.20, 160, '2026-08-10'), (23, 10, 0.10, 200, '2026-09-25');

-- =====================================================
-- 8. TABLA: Comandas (23 Comandas)
-- =====================================================
INSERT INTO `Comandas` (`idComanda`, `fechaInicio`, `fechaFin`, `cancelada`, `idCliente`, `idMozo`, `numeroMesa`) VALUES
(1, '2026-05-20 21:00:00', '2026-05-20 22:30:00', 0, 4, 2, 1), 
(2, '2026-05-24 12:00:00', NULL, 0, 5, 3, 4), 
(3, '2026-05-23 19:15:00', '2026-05-23 19:30:00', 1, NULL, 2, 2),
(4, '2026-05-24 20:00:00', '2026-05-24 21:30:00', 0, 6, 2, 1),
(5, '2026-05-24 20:15:00', '2026-05-24 21:45:00', 0, 7, 3, 2),
(6, '2026-05-24 20:30:00', NULL, 0, 8, 2, 3),
(7, '2026-05-24 20:45:00', '2026-05-24 22:00:00', 0, 9, 3, 4),
(8, '2026-05-24 21:00:00', NULL, 0, 10, 2, 5),
(9, '2026-05-23 19:00:00', '2026-05-23 20:15:00', 0, 11, 3, 1),
(10, '2026-05-23 19:30:00', '2026-05-23 19:45:00', 1, 12, 2, 2),
(11, '2026-05-23 20:00:00', '2026-05-23 21:10:00', 0, 13, 3, 3),
(12, '2026-05-23 21:30:00', '2026-05-23 23:00:00', 0, 14, 2, 4),
(13, '2026-05-23 22:00:00', '2026-05-23 23:45:00', 0, 15, 3, 5),
(14, '2026-05-22 18:30:00', '2026-05-22 19:30:00', 0, 16, 2, 1),
(15, '2026-05-22 19:15:00', '2026-05-22 20:50:00', 0, 17, 3, 2),
(16, '2026-05-22 20:00:00', '2026-05-22 21:20:00', 0, 18, 2, 3),
(17, '2026-05-22 21:00:00', '2026-05-22 22:30:00', 0, 19, 3, 4),
(18, '2026-05-22 22:15:00', '2026-05-22 23:50:00', 0, 20, 2, 5),
(19, '2026-05-21 19:00:00', '2026-05-21 20:00:00', 0, 21, 3, 1),
(20, '2026-05-21 19:45:00', '2026-05-21 21:15:00', 0, 22, 2, 2),
(21, '2026-05-21 20:30:00', '2026-05-21 21:40:00', 0, 23, 3, 3),
(22, '2026-05-21 21:15:00', '2026-05-21 22:50:00', 0, 24, 2, 4),
(23, '2026-05-21 22:00:00', '2026-05-21 23:10:00', 0, 25, 3, 5);

-- =====================================================
-- 9. TABLA: LineasComandas (11 Líneas)
-- =====================================================
INSERT INTO `LineasComandas` (`idLineasComanda`, `cantidad`, `precio`, `estado`, `observaciones`, `idComanda`, `idProducto`) VALUES
(1, 1, 6500.00, 'COMPLETADO', 'Sin cebolla por favor', 1, 1),
(2, 1, 1300.00, 'COMPLETADO', NULL, 1, 4),
(3, 2, 4000.00, 'COMPLETADO', 'Bien fríos', 1, 14),
(4, 1, 7800.00, 'PREPARACION', 'Punto jugoso', 2, 2),
(5, 1, 3100.00, 'COMPLETADO', NULL, 2, 16),
(6, 1, 7200.00, 'CANCELADA', 'Se arrepintió el cliente', 3, 10),
(7, 1, 6500.00, 'COMPLETADO', NULL, 4, 1),
(8, 2, 3200.00, 'COMPLETADO', NULL, 5, 5),
(9, 1, 5800.00, 'PREPARACION', NULL, 6, 9),
(10, 1, 4500.00, 'COMPLETADO', NULL, 7, 7),
(11, 3, 1500.00, 'COMPLETADO', NULL, 8, 12);

-- =====================================================
-- 10. TABLA: CuponesClientes (22 Relaciones)
-- =====================================================
INSERT INTO `CuponesClientes` (`idCupon`, `idCliente`, `codigo`, `estado`, `idLineasComanda`) VALUES
(1, 4, UNHEX(REPLACE(UUID(), '-', '')), 'USADO', 1),
(2, 5, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(4, 6, UNHEX(REPLACE(UUID(), '-', '')), 'USADO', 7),
(5, 7, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(6, 8, UNHEX(REPLACE(UUID(), '-', '')), 'EXPIRADO', NULL),
(7, 9, UNHEX(REPLACE(UUID(), '-', '')), 'USADO', 8),
(8, 10, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(9, 11, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(10, 12, UNHEX(REPLACE(UUID(), '-', '')), 'EXPIRADO', NULL),
(11, 13, UNHEX(REPLACE(UUID(), '-', '')), 'USADO', 9),
(12, 14, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(13, 15, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(14, 16, UNHEX(REPLACE(UUID(), '-', '')), 'USADO', 10),
(15, 17, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(16, 18, UNHEX(REPLACE(UUID(), '-', '')), 'EXPIRADO', NULL),
(17, 19, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(18, 20, UNHEX(REPLACE(UUID(), '-', '')), 'USADO', 11),
(19, 21, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(20, 22, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(21, 23, UNHEX(REPLACE(UUID(), '-', '')), 'EXPIRADO', NULL),
(22, 24, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL),
(23, 25, UNHEX(REPLACE(UUID(), '-', '')), 'NO USADO', NULL);