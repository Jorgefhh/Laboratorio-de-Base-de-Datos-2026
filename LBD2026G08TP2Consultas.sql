-- Consultas
USE LBD2026G08;

-- Consultas pares

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
	4) Dado un rango de fechas, mostrar mes a mes el total de productos vendidos, el importe
	total vendido. El formato deberá ser: més, total de productos, importe.
*/
SELECT date_format(fechaInicio, '%y-%m') as mes, sum(cantidad) as 'total de productos', sum(precio*cantidad) as importe
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
where fechaInicio BETWEEN '2024-01-1 00:00:00' and '2026-05-30 23:59:59' AND c.fechaFin IS NOT NULL
GROUP BY date_format(fechaInicio, '%y-%m') WITH ROLLUP;

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
	8. Crear una vista con la funcionalidad del apartado 4.
*/
DROP VIEW IF EXISTS v_reporte_mes_a_mes;

CREATE VIEW v_reporte_mes_a_mes AS
SELECT date_format(fechaInicio, '%y-%m') as mes, sum(cantidad) as 'total de productos', sum(precio*cantidad) as importe
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
where c.fechaFin IS NOT NULL
GROUP BY date_format(fechaInicio, '%y-%m') WITH ROLLUP;

SELECT * FROM v_reporte_mes_a_mes WHERE mes BETWEEN '25-03' and '26-05';

/*
	10. Realizar una vista que considere importante para su modelo. También dejar escrito el
	enunciado de la misma.
*/

/* Vista de comandas activas para mozos y caja
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
