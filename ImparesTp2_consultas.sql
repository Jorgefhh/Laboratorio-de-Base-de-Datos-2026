USE LBD2026G08;


-- Consulta 1

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



-- Consulta 3
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


-- 

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
            'idMesa',       c.numeroMesa,
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


-- Para ver tablas pobladas:

Select * from Usuarios;

SELECT * FROM CuponesClientes;

SELECT * FROM Comandas;

SELECT * FROM Clientes;