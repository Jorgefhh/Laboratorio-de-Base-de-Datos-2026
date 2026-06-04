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

USE `LBD2026G08Roma`;

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
INSERT INTO `Productos` (`idProducto`, `producto`, `precioLista`, `puntos`, `descripcion`, `disponible`, `idSubcategoria`, `idCategoria`) VALUES
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
-- 8. TABLA: Comandas (Ampliada con reglas NULL y fechas)
-- =====================================================
-- Regla 1: idCliente e idMozo no pueden ser ambos NULL a la vez.
-- Regla 2: idMozo puede ser NULL (Ej. pedido autogestionado).
-- Regla 3: idCliente puede ser NULL (Ej. cliente ocasional de paso sin registro).
INSERT INTO `Comandas` (`idComanda`, `fechaInicio`, `fechaFin`, `cancelada`, `idCliente`, `idMozo`, `idMesa`) VALUES
-- Originales
(1, '2026-05-20 21:00:00', '2026-05-20 22:30:00', 0, 4, 2, 1), 
(2, '2026-05-24 12:00:00', NULL, 0, 5, 3, 4), 
(3, '2026-05-23 19:15:00', '2026-05-23 19:30:00', 1, NULL, 2, 2), -- Cliente NULL, válido
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
(23, '2026-05-21 22:00:00', '2026-05-21 23:10:00', 0, 25, 3, 5),
-- HISTÓRICO 2025 (Enero - Diciembre)
(24, '2025-01-15 20:00:00', '2025-01-15 21:45:00', 0, 4, NULL, 6), 
(25, '2025-01-20 21:15:00', '2025-01-20 23:00:00', 0, 5, 2, 1),
(26, '2025-02-14 19:30:00', '2025-02-14 21:00:00', 0, NULL, 3, 2), 
(27, '2025-02-14 21:30:00', '2025-02-14 23:50:00', 0, 6, 3, 3),
(28, '2025-03-05 18:00:00', '2025-03-05 19:20:00', 0, 7, 2, 4),
(29, '2025-03-18 20:45:00', '2025-03-18 22:15:00', 0, 8, NULL, 5),
(30, '2025-04-10 13:00:00', '2025-04-10 14:15:00', 0, NULL, 2, 1),
(31, '2025-05-25 12:30:00', '2025-05-25 14:00:00', 0, 9, 3, 2),
(32, '2025-06-15 21:00:00', '2025-06-15 22:30:00', 0, 10, NULL, 3),
(33, '2025-07-20 20:00:00', '2025-07-20 23:00:00', 0, NULL, 2, 4), 
(34, '2025-07-20 20:30:00', '2025-07-20 23:15:00', 0, 11, 3, 5),
(35, '2025-08-12 19:15:00', '2025-08-12 20:45:00', 0, 12, 2, 6),
(36, '2025-09-21 21:00:00', '2025-09-21 22:30:00', 0, 13, NULL, 7), 
(37, '2025-10-31 22:00:00', '2025-10-31 23:45:00', 0, 14, 3, 8),
(38, '2025-11-15 20:30:00', '2025-11-15 21:50:00', 0, NULL, 2, 9),
(39, '2025-12-24 13:00:00', '2025-12-24 14:30:00', 0, 15, 3, 1),
(40, '2025-12-31 21:30:00', '2025-12-31 23:55:00', 0, 16, 2, 2),
-- HISTÓRICO 2026 (Enero - Mayo)
(41, '2026-01-05 20:00:00', '2026-01-05 21:30:00', 0, NULL, 3, 3),
(42, '2026-01-18 21:15:00', '2026-01-18 22:45:00', 0, 17, 2, 4),
(43, '2026-02-14 20:30:00', '2026-02-14 22:30:00', 0, 18, NULL, 5),
(44, '2026-02-28 19:00:00', '2026-02-28 20:15:00', 1, 19, 3, 6), -- Cancelada
(45, '2026-03-10 21:00:00', '2026-03-10 22:15:00', 0, NULL, 2, 7),
(46, '2026-03-25 13:30:00', '2026-03-25 14:45:00', 0, 20, 3, 8),
(47, '2026-04-02 20:45:00', '2026-04-02 22:00:00', 0, 21, NULL, 9),
(48, '2026-04-15 21:30:00', '2026-04-15 23:00:00', 0, 22, 2, 1),
(49, '2026-05-01 12:30:00', '2026-05-01 14:30:00', 0, 23, 3, 2), 
(50, '2026-05-10 20:00:00', '2026-05-10 21:15:00', 0, NULL, 2, 3),
(51, '2026-05-12 19:30:00', '2026-05-12 21:00:00', 0, 24, 3, 4),
(52, '2026-05-15 21:45:00', '2026-05-15 23:15:00', 0, 25, NULL, 5),
(53, '2026-05-18 20:15:00', '2026-05-18 21:30:00', 0, 4, 2, 6),
(54, '2026-05-19 21:00:00', '2026-05-19 22:45:00', 0, NULL, 3, 7),
-- COMANDAS ACTIVAS (Sin fechaFin - Noche actual o al mediodía)
(55, '2026-05-25 12:00:00', NULL, 0, 5, 2, 8),
(56, '2026-05-25 12:15:00', NULL, 0, 6, NULL, 9),
(57, '2026-05-25 12:30:00', NULL, 0, NULL, 3, 1),
(58, '2026-05-25 13:00:00', NULL, 0, 7, 2, 2),
(59, '2026-05-25 13:10:00', NULL, 0, 8, NULL, 3),
(60, '2026-05-25 13:20:00', NULL, 0, 9, 3, 4);

-- =====================================================
-- 9. TABLA: LineasComandas (Ampliada)
-- =====================================================
INSERT INTO `LineasComandas` (`idLineasComanda`, `cantidad`, `precio`, `estado`, `observaciones`, `idComanda`, `idProducto`) VALUES
-- Originales
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
(11, 3, 1500.00, 'COMPLETADO', NULL, 8, 12),
-- Nuevas Líneas (Histórico 2025)
(12, 2, 6500.00, 'COMPLETADO', 'Sin aderezo', 24, 1),
(13, 1, 3200.00, 'COMPLETADO', NULL, 24, 5),
(14, 2, 3100.00, 'COMPLETADO', NULL, 25, 16),
(15, 1, 4500.00, 'COMPLETADO', NULL, 25, 7),
(16, 2, 4200.00, 'COMPLETADO', 'Para el brindis de San Valentín', 26, 15),
(17, 1, 19500.00, 'COMPLETADO', 'Descorche', 27, 20),
(18, 2, 7200.00, 'COMPLETADO', 'Para compartir', 27, 10),
(19, 1, 5800.00, 'COMPLETADO', 'En pan francés', 28, 9),
(20, 1, 1500.00, 'COMPLETADO', NULL, 28, 12),
(21, 3, 3100.00, 'COMPLETADO', 'Variadas', 29, 17),
(22, 1, 4900.00, 'COMPLETADO', NULL, 30, 8),
(23, 2, 3900.00, 'COMPLETADO', 'Sin crutones', 31, 11),
(24, 1, 1200.00, 'COMPLETADO', 'Sin gas', 31, 13),
(25, 1, 6500.00, 'COMPLETADO', NULL, 32, 1),
(26, 4, 4500.00, 'COMPLETADO', 'Promo día del amigo', 33, 18),
(27, 2, 4800.00, 'COMPLETADO', 'Doble panceta', 33, 6),
(28, 2, 7800.00, 'COMPLETADO', NULL, 34, 2),
(29, 1, 12500.00, 'COMPLETADO', 'Bien frío', 35, 23),
(30, 2, 4000.00, 'COMPLETADO', NULL, 36, 14),
(31, 1, 4500.00, 'COMPLETADO', NULL, 36, 7),
(32, 1, 5800.00, 'COMPLETADO', NULL, 37, 22),
(33, 2, 2800.00, 'COMPLETADO', 'Postre para dos', 37, 25),
(34, 1, 7200.00, 'COMPLETADO', NULL, 38, 10),
(35, 1, 4000.00, 'COMPLETADO', 'Promo Happy Hour', 38, 26),
(36, 3, 1000.00, 'COMPLETADO', 'Fichas de pool', 39, 27),
(37, 1, 12500.00, 'COMPLETADO', 'Brindis Fin de Año', 40, 23),
(38, 2, 7800.00, 'COMPLETADO', NULL, 40, 2),
-- Nuevas Líneas (Histórico 2026)
(39, 2, 3100.00, 'COMPLETADO', 'IPAs', 41, 16),
(40, 1, 4800.00, 'COMPLETADO', 'Con extra crema', 41, 6),
(41, 1, 6500.00, 'COMPLETADO', NULL, 42, 1),
(42, 1, 1800.00, 'COMPLETADO', 'Medallón extra', 42, 3),
(43, 2, 3800.00, 'COMPLETADO', 'Copas tiradas', 43, 24),
(44, 1, 4500.00, 'CANCELADA', 'Se demoró mucho', 44, 7),
(45, 1, 7200.00, 'COMPLETADO', NULL, 45, 10),
(46, 1, 3200.00, 'COMPLETADO', NULL, 46, 5),
(47, 1, 1500.00, 'COMPLETADO', NULL, 46, 12),
(48, 2, 3900.00, 'COMPLETADO', NULL, 47, 11),
(49, 1, 7500.00, 'COMPLETADO', NULL, 47, 21),
(50, 2, 4000.00, 'COMPLETADO', NULL, 48, 14),
(51, 1, 5800.00, 'COMPLETADO', NULL, 49, 9),
(52, 2, 4500.00, 'COMPLETADO', 'Stella 1L', 49, 18),
(53, 1, 6500.00, 'COMPLETADO', NULL, 50, 1),
(54, 1, 3100.00, 'COMPLETADO', NULL, 50, 17),
(55, 1, 4900.00, 'COMPLETADO', NULL, 51, 8),
(56, 1, 1200.00, 'COMPLETADO', 'Con gas', 51, 13),
(57, 1, 7800.00, 'COMPLETADO', NULL, 52, 2),
(58, 1, 1300.00, 'COMPLETADO', 'Extra Cheddar', 52, 4),
(59, 2, 4200.00, 'COMPLETADO', 'Negronis', 53, 15),
(60, 1, 7200.00, 'COMPLETADO', NULL, 54, 10),
-- Nuevas Líneas (Día actual - En preparación)
(61, 2, 6500.00, 'PREPARACION', 'Sin tomate', 55, 1),
(62, 1, 3200.00, 'PREPARACION', NULL, 55, 5),
(63, 1, 4500.00, 'PREPARACION', NULL, 56, 7),
(64, 1, 1500.00, 'COMPLETADO', 'Coca entregada', 56, 12),
(65, 1, 5800.00, 'PREPARACION', NULL, 57, 9),
(66, 1, 7800.00, 'PREPARACION', 'Sale con barbacoa', 58, 2),
(67, 1, 3100.00, 'PREPARACION', 'Pinta IPA', 58, 16),
(68, 2, 3900.00, 'PREPARACION', NULL, 59, 11),
(69, 1, 1200.00, 'COMPLETADO', 'Agua entregada', 59, 13),
(70, 1, 19500.00, 'PREPARACION', 'Llevar hielera', 60, 20),
(71, 1, 4800.00, 'PREPARACION', 'Papas con verdeo', 60, 6);

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
