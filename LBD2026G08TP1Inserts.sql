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

USE `RomaLBD`;

-- Desactivamos momentáneamente las revisiones para facilitar la inserción masiva
SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

-- =====================================================
-- 1. POBLAR CATEGORÍAS (20 registros)
-- =====================================================
INSERT INTO `Categorias` (`categoria`) VALUES
('Pizzas'), ('Empanadas'), ('Bebidas sin alcohol'), ('Cervezas'), ('Vinos'),
('Postres'), ('Pastas'), ('Carnes Rojas'), ('Aves'), ('Ensaladas'),
('Minutas'), ('Cafetería'), ('Sandwiches'), ('Mariscos'), ('Sopas'),
('Guarniciones'), ('Tragos'), ('Helados'), ('Panadería'), ('Desayunos');

-- =====================================================
-- 2. POBLAR SUBCATEGORÍAS (20 registros)
-- =====================================================
INSERT INTO `Subcategorias` (`idCategoria`, `subcategoria`) VALUES
(1, 'A la Piedra'), (1, 'Al Molde'), (2, 'Fritas'), (2, 'Al Horno'), (3, 'Gaseosas'),
(3, 'Aguas Saborizadas'), (4, 'Artesanal Tirada'), (4, 'Industrial'), (5, 'Tintos'), (5, 'Blancos'),
(6, 'Tortas'), (7, 'Rellenas'), (8, 'A la Parrilla'), (9, 'Pollo Frito'), (10, 'Vegetarianas'),
(11, 'Milanesas'), (12, 'Café de Especialidad'), (13, 'De Miga'), (14, 'Pescados de Río'), (15, 'Cremas');

-- =====================================================
-- 3. POBLAR PRODUCTOS (20 registros)
-- =====================================================
-- Nota: idSubcategoria coincide con el orden de inserción (1 al 20) y mapeamos su respectivo idCategoria
INSERT INTO `Productos` (`producto`, `precioLista`, `puntos`, `descripcion`, `disponible`, `idSubcategoria`, `idCategoria`) VALUES
('Pizza Muzzarella', 8500.00, 10, 'Pizza clásica de muzzarella y aceitunas', 1, 1, 1),
('Pizza Fugazzeta', 9200.00, 12, 'Doble masa con queso y cebolla', 1, 2, 1),
('Empanada de Carne Cortada a Cuchillo', 900.00, 2, 'Empanada frita jugosa', 1, 3, 2),
('Empanada de Jamón y Queso', 850.00, 1, 'Clásica al horno', 1, 4, 2),
('Coca Cola 1.5L', 2500.00, 3, 'Gaseosa línea Coca Cola', 1, 5, 3),
('Agua Saborizada Pomelo', 1800.00, 2, 'Agua Levite 1.5L', 1, 6, 3),
('Pinta IPA', 3000.00, 5, 'Cerveza artesanal IPA', 1, 7, 4),
('Cerveza Quilmes 1L', 3500.00, 4, 'Cerveza rubia clásica', 1, 8, 4),
('Vino Malbec Rutini', 15000.00, 30, 'Vino tinto reserva', 1, 9, 5),
('Vino Blanco Dulce', 6500.00, 10, 'Cosecha tardía', 1, 10, 5),
('Cheesecake de Frutos Rojos', 4500.00, 8, 'Porción de torta', 1, 11, 6),
('Ravioles de Verdura', 5500.00, 10, 'Masa casera con salsa mixta', 1, 12, 7),
('Bife de Chorizo', 12000.00, 25, 'Corte de 400gr a la parrilla', 1, 13, 8),
('Pollo Crispy con Fritas', 7500.00, 15, 'Bastones de pollo frito', 1, 14, 9),
('Ensalada Caesar', 6000.00, 10, 'Lechuga, pollo, crutones y aderezo', 1, 15, 10),
('Milanesa Napolitana', 8500.00, 18, 'Con papas fritas', 1, 16, 11),
('Café Latte', 2200.00, 4, 'Doble shot de espresso con leche', 1, 17, 12),
('Docena Sandwiches de Miga', 11000.00, 20, 'Surtidos triples', 1, 18, 13),
('Pacú a la Pizza', 14000.00, 28, 'Pescado de río despinado', 1, 19, 14),
('Sopa Crema de Calabaza', 4000.00, 5, 'Sopa caliente con crutones', 1, 20, 15);

-- =====================================================
-- 4. POBLAR USUARIOS (40 registros: 20 Clientes + 20 Mozos)
-- =====================================================
-- Clientes (IDs 1 al 20)
INSERT INTO `Usuarios` (`nombres`, `apellidos`, `email`, `username`, `contrasenia`, `esAdmin`, `fechaNac`, `dni`, `activo`) VALUES
('Juan', 'Perez', 'juan.perez@email.com', 'juanp', 'pass123', 0, '1990-05-15', '35123456', 1),
('María', 'Gomez', 'maria.g@email.com', 'mariag', 'pass123', 0, '1992-08-20', '36123457', 1),
('Carlos', 'Lopez', 'carlos.l@email.com', 'carlosl', 'pass123', 0, '1985-11-10', '31123458', 1),
('Ana', 'Martinez', 'ana.m@email.com', 'anam', 'pass123', 0, '1998-02-25', '40123459', 1),
('Luis', 'Rodriguez', 'luis.r@email.com', 'luisr', 'pass123', 0, '1988-07-30', '33123460', 1),
('Laura', 'Fernandez', 'laura.f@email.com', 'lauraf', 'pass123', 0, '1995-09-12', '38123461', 1),
('Diego', 'Gonzalez', 'diego.g@email.com', 'diegog', 'pass123', 0, '1991-04-05', '36123462', 1),
('Sofia', 'Diaz', 'sofia.d@email.com', 'sofiad', 'pass123', 0, '1999-12-01', '41123463', 1),
('Martin', 'Alvarez', 'martin.a@email.com', 'martina', 'pass123', 0, '1982-03-18', '29123464', 1),
('Lucia', 'Torres', 'lucia.t@email.com', 'luciat', 'pass123', 0, '1997-06-22', '39123465', 1),
('Pablo', 'Ruiz', 'pablo.r@email.com', 'pablor', 'pass123', 0, '1989-10-14', '34123466', 1),
('Elena', 'Ramirez', 'elena.r@email.com', 'elenar', 'pass123', 0, '1994-01-08', '37123467', 1),
('Jorge', 'Flores', 'jorge.f@email.com', 'jorgef', 'pass123', 0, '1986-05-27', '32123468', 1),
('Valeria', 'Benitez', 'valeria.b@email.com', 'valeriab', 'pass123', 0, '1993-08-11', '37123469', 1),
('Matias', 'Acosta', 'matias.a@email.com', 'matiasa', 'pass123', 0, '1996-11-03', '39123470', 1),
('Camila', 'Medina', 'camila.m@email.com', 'camilam', 'pass123', 0, '2000-02-19', '42123471', 1),
('Facundo', 'Rojas', 'facundo.r@email.com', 'facundor', 'pass123', 0, '1987-07-15', '33123472', 1),
('Julieta', 'Suarez', 'julieta.s@email.com', 'julietas', 'pass123', 0, '1998-09-29', '40123473', 1),
('Agustin', 'Mendez', 'agustin.m@email.com', 'agustinm', 'pass123', 0, '1990-12-24', '35123474', 1),
('Micaela', 'Cruz', 'micaela.c@email.com', 'micaelac', 'pass123', 0, '1995-04-16', '38123475', 1);

-- Mozos (IDs 21 al 40)
INSERT INTO `Usuarios` (`nombres`, `apellidos`, `email`, `username`, `contrasenia`, `esAdmin`, `fechaNac`, `dni`, `activo`) VALUES
('Ezequiel', 'Navarro', 'ezequiel.n@mozos.com', 'ezequieln', 'mozo123', 0, '1985-01-10', '31999001', 1),
('Rocio', 'Villar', 'rocio.v@mozos.com', 'rociov', 'mozo123', 0, '1992-04-22', '36999002', 1),
('Maximiliano', 'Rios', 'maxi.r@mozos.com', 'maxir', 'mozo123', 0, '1988-07-05', '33999003', 1),
('Florencia', 'Silva', 'flor.s@mozos.com', 'flors', 'mozo123', 0, '1995-10-18', '38999004', 1),
('Nicolas', 'Vega', 'nicolas.v@mozos.com', 'nicolasv', 'mozo123', 0, '1990-02-28', '35999005', 1),
('Romina', 'Paz', 'romina.p@mozos.com', 'rominap', 'mozo123', 0, '1993-05-11', '37999006', 1),
('Ignacio', 'Gimenez', 'ignacio.g@mozos.com', 'ignaciog', 'mozo123', 0, '1987-08-25', '33999007', 1),
('Daniela', 'Moreno', 'daniela.m@mozos.com', 'danielam', 'mozo123', 0, '1996-11-07', '39999008', 1),
('Leandro', 'Luna', 'leandro.l@mozos.com', 'leandrol', 'mozo123', 0, '1989-01-20', '34999009', 1),
('Carolina', 'Herrera', 'carolina.h@mozos.com', 'carolinah', 'mozo123', 0, '1994-04-03', '37999010', 1),
('Mariano', 'Cabrera', 'mariano.c@mozos.com', 'marianoc', 'mozo123', 0, '1991-07-16', '36999011', 1),
('Antonella', 'Dominguez', 'anto.d@mozos.com', 'antod', 'mozo123', 0, '1998-10-29', '40999012', 1),
('Gabriel', 'Molina', 'gabriel.m@mozos.com', 'gabrielm', 'mozo123', 0, '1986-02-12', '32999013', 1),
('Agustina', 'Castro', 'agustina.c@mozos.com', 'agustinac', 'mozo123', 0, '1997-05-26', '39999014', 1),
('Rodrigo', 'Sosa', 'rodrigo.s@mozos.com', 'rodrigos', 'mozo123', 0, '1990-08-08', '35999015', 1),
('Brenda', 'Romero', 'brenda.r@mozos.com', 'brendar', 'mozo123', 0, '1995-11-21', '38999016', 1),
('Tomás', 'Arias', 'tomas.a@mozos.com', 'tomasa', 'mozo123', 0, '1999-01-04', '41999017', 1),
('Melina', 'Bustos', 'melina.b@mozos.com', 'melinab', 'mozo123', 0, '1992-04-17', '36999018', 1),
('Emanuel', 'Mansilla', 'emanuel.m@mozos.com', 'emanuelm', 'mozo123', 0, '1988-07-30', '33999019', 1),
('Belen', 'Cordoba', 'belen.c@mozos.com', 'belenc', 'mozo123', 0, '1996-10-12', '39999020', 1);

-- =====================================================
-- 5. POBLAR CLIENTES (20 registros apuntando a idUsuario 1 al 20)
-- =====================================================
INSERT INTO `Clientes` (`idUsuario`, `puntos`) VALUES
(1, 150), (2, 300), (3, 50), (4, 420), (5, 0),
(6, 120), (7, 600), (8, 90), (9, 210), (10, 330),
(11, 45), (12, 500), (13, 80), (14, 190), (15, 275),
(16, 410), (17, 30), (18, 160), (19, 240), (20, 380);

-- =====================================================
-- 6. POBLAR MOZOS (20 registros apuntando a idUsuario 21 al 40)
-- =====================================================
INSERT INTO `Mozos` (`idUsuario`) VALUES
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30),
(31), (32), (33), (34), (35), (36), (37), (38), (39), (40);

-- =====================================================
-- 7. POBLAR CUPONES (20 registros)
-- =====================================================
-- El descuento es DECIMAL(3,2), formato: 0.10 representa 10%
INSERT INTO `Cupones` (`descuento`, `precioPuntos`, `fechaExpiracion`, `idProducto`) VALUES
(0.10, 100, '2026-12-31', 1), (0.15, 150, '2026-12-31', 2), (0.20, 200, '2026-12-31', 3),
(0.05, 50, '2026-12-31', 4), (0.25, 250, '2026-12-31', 5), (0.10, 100, '2026-12-31', 6),
(0.30, 300, '2026-12-31', 7), (0.15, 150, '2026-12-31', 8), (0.40, 400, '2026-12-31', 9),
(0.20, 200, '2026-12-31', 10), (0.10, 100, '2026-12-31', 11), (0.15, 150, '2026-12-31', 12),
(0.25, 250, '2026-12-31', 13), (0.20, 200, '2026-12-31', 14), (0.10, 100, '2026-12-31', 15),
(0.30, 300, '2026-12-31', 16), (0.05, 50, '2026-12-31', 17), (0.35, 350, '2026-12-31', 18),
(0.40, 400, '2026-12-31', 19), (0.15, 150, '2026-12-31', 20);

-- =====================================================
-- 8. POBLAR MESAS (20 registros)
-- =====================================================
INSERT INTO `Mesas` (`numeroMesa`, `ubicacion`, `activo`) VALUES
(1, 'ADENTRO', 1), (2, 'ADENTRO', 1), (3, 'ADENTRO', 1), (4, 'ADENTRO', 1), (5, 'ADENTRO', 1),
(6, 'ADENTRO', 1), (7, 'ADENTRO', 1), (8, 'ADENTRO', 1), (9, 'ADENTRO', 1), (10, 'ADENTRO', 1),
(11, 'AFUERA', 1), (12, 'AFUERA', 1), (13, 'AFUERA', 1), (14, 'AFUERA', 1), (15, 'AFUERA', 1),
(16, 'AFUERA', 1), (17, 'AFUERA', 1), (18, 'AFUERA', 0), (19, 'AFUERA', 0), (20, 'AFUERA', 1);

-- =====================================================
-- 9. POBLAR COMANDAS (20 registros)
-- =====================================================
INSERT INTO `Comandas` (`fechaInicio`, `fechaFin`, `cancelada`, `idCliente`, `idMozo`, `numeroMesa`) VALUES
('2026-05-10 12:00:00', '2026-05-10 13:30:00', 0, 1, 21, 1),
('2026-05-10 12:15:00', '2026-05-10 14:00:00', 0, 2, 22, 2),
('2026-05-10 12:30:00', NULL, 0, 3, 23, 3),
('2026-05-10 13:00:00', '2026-05-10 13:10:00', 1, 4, 24, 4),
('2026-05-10 20:00:00', '2026-05-10 21:45:00', 0, 5, 25, 11),
('2026-05-10 20:15:00', '2026-05-10 22:00:00', 0, 6, 26, 12),
('2026-05-10 20:30:00', NULL, 0, 7, 27, 13),
('2026-05-10 21:00:00', '2026-05-10 22:30:00', 0, 8, 28, 5),
('2026-05-11 12:00:00', '2026-05-11 13:15:00', 0, 9, 29, 6),
('2026-05-11 12:45:00', NULL, 0, 10, 30, 14),
('2026-05-11 13:00:00', '2026-05-11 14:30:00', 0, 11, 31, 7),
('2026-05-11 20:30:00', '2026-05-11 22:15:00', 0, 12, 32, 15),
('2026-05-11 21:00:00', '2026-05-11 23:00:00', 0, 13, 33, 8),
('2026-05-11 21:15:00', NULL, 0, 14, 34, 16),
('2026-05-12 12:30:00', '2026-05-12 14:00:00', 0, 15, 35, 9),
('2026-05-12 13:00:00', '2026-05-12 13:05:00', 1, 16, 36, 10),
('2026-05-12 20:00:00', '2026-05-12 21:30:00', 0, 17, 37, 17),
('2026-05-12 20:45:00', NULL, 0, 18, 38, 1),
('2026-05-12 21:30:00', '2026-05-12 23:15:00', 0, 19, 39, 2),
('2026-05-12 22:00:00', NULL, 0, 20, 40, 11);

-- =====================================================
-- 10. POBLAR LINEAS COMANDAS (20 registros)
-- =====================================================
INSERT INTO `LineasComandas` (`cantidad`, `precio`, `estado`, `observaciones`, `idComanda`, `idProducto`) VALUES
(1, 8500.00, 'COMPLETADO', 'Sin aceitunas', 1, 1),
(2, 900.00, 'COMPLETADO', 'Bien calientes', 2, 3),
(1, 3000.00, 'PREPARACION', NULL, 3, 7),
(1, 15000.00, 'CANCELADA', 'El cliente se retiró', 4, 9),
(2, 5500.00, 'COMPLETADO', 'Extra queso rallado', 5, 12),
(1, 12000.00, 'COMPLETADO', 'A punto', 6, 13),
(3, 2500.00, 'PREPARACION', 'Con mucho hielo', 7, 5),
(1, 8500.00, 'COMPLETADO', 'Papas crocantes', 8, 16),
(2, 2200.00, 'COMPLETADO', 'Leche descremada', 9, 17),
(1, 4500.00, 'PREPARACION', NULL, 10, 11),
(4, 850.00, 'COMPLETADO', NULL, 11, 4),
(1, 6000.00, 'COMPLETADO', 'Aderezo aparte', 12, 15),
(2, 3500.00, 'COMPLETADO', NULL, 13, 8),
(1, 14000.00, 'PREPARACION', 'Al limón', 14, 19),
(1, 4000.00, 'COMPLETADO', NULL, 15, 20),
(1, 9200.00, 'CANCELADA', 'Error al tomar el pedido', 16, 2),
(2, 7500.00, 'COMPLETADO', NULL, 17, 14),
(1, 6500.00, 'PREPARACION', 'Vino bien frío', 18, 10),
(1, 11000.00, 'COMPLETADO', 'Surtido clásico', 19, 18),
(3, 1800.00, 'PREPARACION', NULL, 20, 6);

-- =====================================================
-- 11. POBLAR CUPONES CLIENTES (20 registros)
-- =====================================================
-- Enlazamos algunos a las lineas completadas y otros quedan sin usar/expirados
INSERT INTO `CuponesClientes` (`Cupones_idCupon`, `Clientes_Usuarios_idUsuario`, `estado`, `idLineasComanda`) VALUES
(1, 1, 'USADO', 1),
(2, 2, 'NO USADO', NULL),
(3, 3, 'EXPIRADO', NULL),
(4, 4, 'NO USADO', NULL),
(5, 5, 'USADO', 5),
(6, 6, 'USADO', 6),
(7, 7, 'NO USADO', NULL),
(8, 8, 'USADO', 8),
(9, 9, 'USADO', 9),
(10, 10, 'NO USADO', NULL),
(11, 11, 'USADO', 11),
(12, 12, 'USADO', 12),
(13, 13, 'USADO', 13),
(14, 14, 'NO USADO', NULL),
(15, 15, 'USADO', 15),
(16, 16, 'EXPIRADO', NULL),
(17, 17, 'USADO', 17),
(18, 18, 'NO USADO', NULL),
(19, 19, 'USADO', 19),
(20, 20, 'NO USADO', NULL);

-- Restauramos las validaciones
SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;