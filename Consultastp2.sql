USE LBD2026G08;


-- Consulta 1
SELECT subcategoria, Productos.producto FROM Productos INNER JOIN Subcategorias
ON Subcategorias.idSubcategoria = Productos.dCategoria 
WHERE Subcategorias.idCategoria = 1;



-- Consulta 3
/*
3. Dado un cliente, y un rango de fechas, listar todas sus comandas y cupones aplicados en
ese rango de fechas.

*/

SELECT Comandas.idComanda, Comandas.fechaFin, Comandas.cancelada, Comandas.idCliente, CuponesClientes.idCupon, CuponesClientes.codigo
FROM Comandas INNER JOIN Clientes ON Comandas.idCliente = Clientes.idCliente
INNER JOIN CuponesClientes ON CuponesClientes.idCliente = Clientes.idCliente
WHERE Clientes.idCliente = 4 AND Comandas.fechaFin BETWEEN '2026-01-01 00:00:00' AND '2026-12-31 23:59:59' 
AND CuponesClientes.estado = 'USADO';


-- 

/*

5. Hacer un ranking con los mozos con más comandas en un rango de fechas.

*/

SELECT COUNT(*) AS CantidadComandas, Usuarios.nombres FROM Usuarios
INNER JOIN Comandas ON Comandas.idMozo = Usuarios.idUsuario
WHERE Comandas.fechaFin BETWEEN '2026-01-01 00:00:00' AND '2026-12-31 23:59:59'
GROUP BY Usuarios.nombres ORDER BY CantidadComandas ASC;
    
    
/*
7. Hacer un ranking con los clientes con más cupones usados .

*/

SELECT COUNT(*) AS CantidadCupones, Usuarios.nombres FROM Usuarios
INNER JOIN Clientes ON Clientes.idCliente = Usuarios.idUsuario
INNER JOIN CuponesClientes ON Clientes.idCliente = CuponesClientes.idCliente
WHERE CuponesClientes.estado = 'USADO'
GROUP BY Usuarios.nombres ORDER BY CantidadCupones ASC;
    
    

/*
Select * from Usuarios;

SELECT * FROM CuponesClientes;

SELECT * FROM Comandas;

SELECT * FROM Clientes;

*/