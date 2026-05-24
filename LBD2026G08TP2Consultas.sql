-- Consultas
/*
	1. Dada una Categoría, mostrar todas sus subcategorías y sus productos ordenados.
*/
SELECT subcategoria FROM Subcategorias WHERE idCategoria = 1;

/*
	2. Dado un producto, mostrar las comandas completas donde participa, ordenadas.
*/
SELECT * FROM Comandas c JOIN LineasComandas lc ON c.idComanda = lc.idComanda
WHERE lc.idProducto IN (SELECT idProducto FROM Productos where producto = 'Hamburguesa Roma Completa');