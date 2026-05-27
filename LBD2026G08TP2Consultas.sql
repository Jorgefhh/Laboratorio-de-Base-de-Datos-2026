-- Consultas
USE LBD2026G08;

-- Consultas pares

/*
	2. Dado un producto, mostrar las comandas completas donde participa, ordenadas.
*/
-- Consulta: "Dado un producto" se refiere al id o al nombre?
SELECT c.idComanda, fechaInicio, fechaFin, cancelada, numeroMesa, cantidad, precio, estado, observaciones 
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
WHERE c.fechaFin IS NOT NULL AND lc.idProducto = 1
ORDER BY c.fechaFin;

SELECT c.idComanda, fechaInicio, fechaFin, cancelada, numeroMesa, cantidad, precio, estado, observaciones 
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
WHERE c.fechaFin IS NOT NULL AND lc.idProducto IN (SELECT idProducto FROM Productos where producto = 'Hamburguesa Roma Completa')
ORDER BY c.fechaFin;


/*
	4) Dado un rango de fechas, mostrar mes a mes el total de productos vendidos, el importe
	total vendido. El formato deberá ser: més, total de productos, importe.
*/
SELECT date_format(fechaInicio, '%y-%m') as mes, sum(cantidad) as 'total de productos', sum(precio*cantidad) as importe
FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
where fechaInicio BETWEEN '2024-01-1 00:00:00' and '2026-05-30 23:59:00'
GROUP BY date_format(fechaInicio, '%y-%m') WITH ROLLUP;

/*
	6. Hacer un ranking con las categorias, sub categorias y productos con más salidas en un
	rango de fechas.
*/
-- Consulta: Es un solo ranking con los tres, o una consulta independiente para cada ranking?

-- Ranking solo de productos
SELECT producto, COUNT(lc.cantidad) as ventas
FROM LineasComandas lc JOIN Productos p ON lc.idProducto = p.idProducto
JOIN Comandas c ON c.idComanda = lc.idComanda
WHERE c.fechaInicio BETWEEN '2024-01-1 00:00:00' and '2026-05-30 23:59:00'
GROUP BY lc.idProducto, p.idCategoria
ORDER BY ventas DESC;

/*
	8. Crear una vista con la funcionalidad del apartado 4.
*/
DROP VIEW IF EXISTS v_reporte_mes_a_mes;

CREATE VIEW v_reporte_mes_a_mes AS
SELECT date_format(fechaInicio, '%y-%m') as mes, sum(cantidad) as 'total de productos', sum(precio*cantidad) as importe
FROM Comandas c 
JOIN LineasComandas lc ON c.idComanda = lc.idComanda
GROUP BY date_format(fechaInicio, '%y-%m') WITH ROLLUP;

SELECT * FROM v_reporte_mes_a_mes WHERE mes BETWEEN '25-03' and '26-05';

/*
	10. Realizar una vista que considere importante para su modelo. También dejar escrito el
	enunciado de la misma.
*/