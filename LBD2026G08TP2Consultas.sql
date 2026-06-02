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

USE LBD2026G08Roma;

/*
    1. Dada una Categoría, mostrar todas sus subcategorías y sus productos ordenados.
*/
SET @idCategoriaBuscada = 3;

SELECT c.categoria,s.subcategoria,p.producto FROM Categorias c
LEFT JOIN Subcategorias s
ON c.idCategoria = s.idCategoria
LEFT JOIN Productos p
ON s.idSubcategoria = p.idSubcategoria
WHERE c.idCategoria = @idCategoriaBuscada
ORDER BY s.subcategoria,p.producto;

/*
	2. Dado un producto, mostrar las comandas completas donde participa, ordenadas.
*/
-- Buso primero el producto por su nombre y lo guardo el id en una variable
SELECT idProducto INTO @var_idProducto FROM Productos WHERE producto = 'Hamburguesa Roma Completa';

SELECT c.idComanda, fechaInicio, fechaFin, cancelada, cantidad, precio, estado, mes.numeroMesa, idCliente,cl.nombres as 'nombre cliente', idMozo, m.nombres as 'nombre mozo'
FROM Productos p 
LEFT JOIN LineasComandas lc ON lc.idProducto = p.idProducto
INNER JOIN Comandas c ON c.idComanda = lc.idComanda
LEFT JOIN Usuarios cl ON cl.idUsuario= c.idCliente
LEFT JOIN Usuarios m ON m.idUsuario = c.idMozo
LEFT JOIN Mesas mes ON mes.idMesa = c.idMesa
WHERE c.fechaFin IS NOT NULL AND p.idProducto = @var_idProducto
ORDER BY c.fechaFin DESC;


/*
    3. Dado un cliente, y un rango de fechas, listar todas sus comandas y cupones aplicados en
    ese rango de fechas.
*/
SET @idCliente = 4;
SET @fechaDesde = '2026-01-01 00:00:00';
SET @fechaHasta = '2026-12-31 23:59:5';

SELECT c.idComanda,c.fechaInicio,c.idCliente,c.idMozo,c.numeroMesa,p.producto,lc.cantidad,cp.idCupon,cp.descuento
FROM Clientes cl
LEFT JOIN Comandas c
ON cl.idCliente = c.idCliente
LEFT JOIN LineasComandas lc
ON c.idComanda = lc.idComanda
LEFT JOIN Productos p
ON lc.idProducto = p.idProducto
LEFT JOIN CuponesClientes cc
ON cl.idCliente = cc.idCliente
LEFT JOIN Cupones cp
ON cc.idCupon = cp.idCupon
WHERE cl.idCliente = @idCliente
AND c.fechaInicio BETWEEN @fechaDesde AND @fechaHasta
AND cc.estado = 'USADO'
ORDER BY c.fechaInicio;


/*
	4) Dado un rango de fechas, mostrar mes a mes el total de productos vendidos, el importe
	total vendido. El formato deberá ser: més, total de productos, importe.
*/
SELECT date_format(fechaInicio, '%y-%m') as mes, sum(cantidad) as 'total de productos', sum(precio*cantidad) as importe
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
where fechaInicio BETWEEN '2024-01-1 00:00:00' and '2026-05-30 23:59:59' AND c.fechaFin IS NOT NULL
GROUP BY date_format(fechaInicio, '%y-%m') WITH ROLLUP;

/*
    5. Hacer un ranking con los mozos con más comandas en un rango de fechas.
*/

SET @fechaDesde = '2026-01-01 00:00:00';
SET @fechaHasta = '2026-12-31 23:59:59';

SELECT u.idUsuario,u.nombres,u.apellidos,COUNT(c.idComanda) AS CantidadComandas
FROM Usuarios u
INNER JOIN Comandas c
ON c.idMozo = u.idUsuario
WHERE  u.esMozo = TRUE AND c.fechaFin BETWEEN @fechaDesde AND @fechaHasta
GROUP BY u.idUsuario,u.nombres,u.apellidos
ORDER BY CantidadComandas DESC;
    
    
/*
	6. Hacer un ranking con las categorias, sub categorias y productos con más salidas en un
	rango de fechas.
*/
-- Ranking de productos
SELECT producto, COUNT(lc.cantidad) as ventas, categoria, subcategoria
FROM LineasComandas lc JOIN Productos p ON lc.idProducto = p.idProducto
JOIN Comandas c ON c.idComanda = lc.idComanda
JOIN Subcategorias sc ON sc.idSubcategoria = p.idSubcategoria AND sc.idCategoria = p.idCategoria
JOIN Categorias ca ON ca.idCategoria = p.idCategoria
WHERE c.fechaInicio BETWEEN '2024-01-1 00:00:00' and '2026-05-30 23:59:59'
GROUP BY producto, categoria,subcategoria
ORDER BY ventas DESC;
    
/*
    7. Hacer un ranking con los clientes con más cupones usados .
*/ 
-- Solo se incluyen en el ranking los clientes que alguna vez usaron un cupón    
SELECT u.idUsuario,u.nombres,u.apellidos,COUNT(cc.idCupon) AS CantidadCupones
FROM Usuarios u
INNER JOIN Clientes c
ON c.idCliente = u.idUsuario
INNER JOIN CuponesClientes cc
ON cc.idCliente = c.idCliente
WHERE cc.estado = 'USADO'
GROUP BY u.idUsuario,u.nombres,u.apellidos
ORDER BY CantidadCupones DESC;

/*
	8. Crear una vista con la funcionalidad del apartado 4.
*/

CREATE OR REPLACE VIEW v_reporte_mes_a_mes AS
SELECT date_format(fechaInicio, '%y-%m') as mes, sum(cantidad) as 'total de productos', sum(precio*cantidad) as importe
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
where c.fechaFin IS NOT NULL
GROUP BY date_format(fechaInicio, '%y-%m') WITH ROLLUP;

SELECT * FROM v_reporte_mes_a_mes WHERE mes BETWEEN '25-03' and '26-05' OR mes IS NULL; -- mes is null para que se muestre el rollup


    
/*
    9. Crear una copia de la tabla productos, que además tenga una columna del tipo JSON
    para guardar el detalle de las comandas donde participa. Llenar esta tabla con los mismos
    datos del TP1 y resolver la consulta: Dado un producto, mostrar las comandas completas
    donde participa.
*/
CREATE TEMPORARY TABLE ProductosJSON AS
SELECT Productos.*, NULL  AS detalleComandas
FROM Productos;
ALTER TABLE ProductosJSON
MODIFY detalleComandas JSON;

UPDATE ProductosJSON pj
SET detalleComandas = (
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'idComanda',    lc.idComanda,
            'fechaInicio',  c.fechaInicio,
            'fechaFin',     c.fechaFin,
            'cancelada',    c.cancelada,
            'idMesa',       c.idMesa,
            'cantidad',     lc.cantidad,
            'precio',       lc.precio,
            'estado',       lc.estado
        )
    )
    FROM LineasComandas lc
    JOIN Comandas c ON lc.idComanda = c.idComanda
    WHERE lc.idProducto = pj.idProducto
);


-- Luego: Dado un producto, mostrar las comandas completas donde participa
SET @idProducto = 1;

SELECT pj.idProducto,pj.producto,jt.*
FROM ProductosJSON pj
LEFT JOIN JSON_TABLE(
    pj.detalleComandas,
    '$[*]' COLUMNS (
        idComanda   INT         PATH '$.idComanda',
        fechaInicio DATETIME    PATH '$.fechaInicio',
        fechaFin    DATETIME    PATH '$.fechaFin',
        cancelada   TINYINT     PATH '$.cancelada',
        idMesa      INT         PATH '$.idMesa',
        cantidad    SMALLINT    PATH '$.cantidad',
        precio      DECIMAL(9,2) PATH '$.precio',
        estado      VARCHAR(20) PATH '$.estado'
    )
) AS jt ON TRUE
WHERE @idProducto = 1;


/*
	10. Realizar una vista que considere importante para su modelo. También dejar escrito el
	enunciado de la misma.
*/

/* 
    Vista de comandas activas para mozos y caja
	muestra que mesas están ocupadas, las lineas de comanda y quién las atiende
*/
DROP VIEW IF EXISTS v_comandas_activas;

CREATE VIEW v_comandas_activas AS 
SELECT m.numeroMesa, u.nombres as 'mozo' ,co.idComanda, co.fechaInicio, p.producto, lc.cantidad, lc.precio, lc.estado FROM Mesas m LEFT JOIN Comandas co ON m.idMesa = co.idMesa
INNER JOIN LineasComandas lc ON co.idComanda = lc.idComanda
INNER JOIN Productos p ON lc.idProducto = p.idProducto
INNER JOIN Usuarios u ON co.idMozo = u.idUsuario
WHERE co.fechaFin IS NULL and co.cancelada = FALSE;

SELECT * FROM v_comandas_activas;