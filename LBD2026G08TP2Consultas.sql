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

USE LBD2026G08Roma;

/*
    1. Dada una Categoría, mostrar todas sus subcategorías y sus productos ordenados.
*/
-- Primero realizo la busqueda de la categoria dada:
SELECT idCategoria INTO @idCategoriaBuscada 
FROM Categorias 
WHERE categoria = 'HAMBURGUESAS';


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
-- Primero realizo la búsqueda del cliente dado:
SELECT idUsuario INTO @idCliente 
FROM Usuarios 
WHERE username = 'diegote';

-- Asigno los valores de fecha:
SET @fechaDesde = '2026-01-01 00:00:00';
SET @fechaHasta = '2026-12-31 23:59:5';

SELECT c.idComanda, c.fechaInicio, c.fechaFin, c.idCliente, c.idMozo, c.idMesa, p.producto, lc.precio, lc.cantidad, lc.observaciones, cc.idCupon, cup.descuento  FROM Clientes cl
LEFT JOIN Comandas c ON cl.idCliente = c.idCliente
JOIN LineasComandas lc ON lc.idComanda = c.idComanda
LEFT JOIN CuponesClientes cc ON cc.idCliente = c.idCliente AND cc.idLineasComanda = lc.idLineasComanda
LEFT JOIN Cupones cup ON cup.idCupon = cc.idCupon
JOIN Productos p ON p.idProducto = lc.idProducto
WHERE c.idCliente = @idCliente AND fechaInicio BETWEEN @fechaDesde AND @fechaHasta;


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

-- Defino un rango de fechas:
SET @fechaDesde = '2026-01-01 00:00:00';
SET @fechaHasta = '2026-12-31 23:59:59';


SELECT u.idUsuario as idMozo, u.nombres,u.apellidos,COUNT(c.idComanda) AS CantidadComandas
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

-- Creo tabla productos JSON
DROP TABLE IF EXISTS ProductosJSON;

CREATE TABLE ProductosJSON AS
SELECT Productos.*, NULL AS detalleComandas
FROM Productos;

-- 2. Modifico la columna a tipo JSON
ALTER TABLE ProductosJSON
MODIFY detalleComandas JSON;

-- Creo tabla temporal con los datos de las lineas comandas en formato JSON para poder anidar los JSON.

DROP TABLE IF EXISTS datosJson;

CREATE TEMPORARY TABLE datosJson AS
SELECT cmd.idComanda, cmd.fechaInicio, cmd.fechaFin, cmd.cancelada,
	cmd.idMesa,
	lc.idProducto,
    mozo.idUsuario as idMozo,
	mozo.nombres as mozo,
    cliente.idUsuario as idCliente,
	cliente.nombres as cliente,
	JSON_ARRAYAGG(
		JSON_OBJECT(
			'idLinea',       lc.idLineasComanda,
			'precio',        lc.precio, 
			'cantidad',      lc.cantidad, 
			'estado',        lc.estado,
            'observaciones', lc.observaciones
		)
	) AS lineas_json
FROM LineasComandas lc
JOIN Comandas cmd ON lc.idComanda = cmd.idComanda
LEFT JOIN Usuarios cliente ON cliente.idUsuario = cmd.idCliente
LEFT JOIN Usuarios mozo ON mozo.idUsuario = cmd.idMozo
WHERE cmd.fechaFin IS NOT NULL
GROUP BY cmd.idComanda, lc.idProducto;


-- 3. Actualizo la tabla usando tabla temporal para anidar los JSON correctamente
UPDATE ProductosJSON pj
SET detalleComandas = (
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'idComanda',   idComanda,
            'fechaInicio', fechaInicio,
            'fechaFin',    fechaFin,
            'cancelada',   cancelada,
            'idMesa',      idMesa,
            'idMozo',      idMozo,
            'mozo',		   mozo,
            'idCliente',    idCliente,
            'cliente',	   cliente,
            'lineas',      lineas_json -- Aquí insertamos el JSON ya agrupado
        )
    )
    FROM datosJson
    WHERE idProducto = idProducto
);

/*
Ejemplo JSON guardado:
[
  {
    "mozo": "Juan Mozo",
    "idMesa": 1,
    "idMozo": 2,
    "lineas": [
      {
        "estado": "COMPLETADO",
        "precio": 6500.0,
        "idLinea": 1,
        "cantidad": 1,
        "observaciones": "Sin cebolla por favor"
      }
    ],
    "cliente": "Diego Nicolas",
    "fechaFin": "2026-05-20 22:30:00.000000",
    "cancelada": 0,
    "idCliente": 4,
    "idComanda": 1,
    "fechaInicio": "2026-05-20 21:00:00.000000"
  },...
*/


-- Luego: Dado un producto, mostrar las comandas completas donde participa
-- Entonces hago la búsquedad para encontrar el producto dado:
SELECT idProducto INTO @idProducto 
FROM Productos 
WHERE producto = 'Hamburguesa Roma Completa';


SELECT det.idComanda, det.idMesa, det.fechaInicio, det.fechaFin, det.cancelada, p.producto, det.precio, det.cantidad, det.estado,
det.idCliente, det.cliente, det.idMozo, det.mozo
FROM ProductosJSON p,
JSON_TABLE(
    p.detalleComandas,
    '$[*]' COLUMNS(
        idComanda INT PATH '$.idComanda',
        idMesa    INT PATH '$.idMesa',
        cancelada BOOLEAN PATH '$.cancelada',
        idMozo    INT PATH '$.idMozo',
        mozo      VARCHAR(45) PATH '$.mozo',
        idCliente    INT PATH '$.idCliente',
        cliente   VARCHAR(45) PATH '$.cliente',
        fechaInicio DATETIME  PATH '$.fechaInicio',
        fechaFin    DATETIME  PATH '$.fechaFin',
        -- Entramos al arreglo interno de líneas por comanda
        NESTED PATH '$.lineas[*]' COLUMNS(
			idLinea        INT 			 PATH '$.idLinea',
            precio   DECIMAL(10,2) PATH '$.precio',
            cantidad INT           PATH '$.cantidad',
            estado   VARCHAR(50)   PATH '$.estado',
            observaciones   VARCHAR(255)   PATH '$.observaciones'
        )
    )
) AS det
WHERE p.idProducto = @idProducto;

/*
	10. Realizar una vista que considere importante para su modelo. También dejar escrito el
	enunciado de la misma.
*/

/* 
    Vista de comandas activas para mozos y caja
	muestra que mesas están ocupadas, las lineas de comanda y quién las atiende
*/

CREATE OR REPLACE VIEW v_comandas_activas AS 
SELECT m.numeroMesa, mozo.nombres as 'mozo' ,co.idComanda, co.fechaInicio, p.producto, lc.cantidad, lc.precio, lc.estado FROM Mesas m 
LEFT JOIN Comandas co ON m.idMesa = co.idMesa
INNER JOIN LineasComandas lc ON co.idComanda = lc.idComanda
INNER JOIN Productos p ON lc.idProducto = p.idProducto
INNER JOIN Usuarios mozo ON co.idMozo = mozo.idUsuario
WHERE co.fechaFin IS NULL and co.cancelada = FALSE;

SELECT * FROM v_comandas_activas;