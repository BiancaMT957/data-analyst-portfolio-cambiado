SELECT Provincia, count(*)
FROM Clientes
GROUP BY Provincia ORDER BY Provincia DESC;

SELECT Provincia, TipoCliente, COUNT (*)AS Numero_Clientes_Por_Tipo
FROM Clientes
GROUP BY Provincia, TipoCliente;

SELECT IdCategoria,
COUNT(*) AS NumProductos,
AVG(PrecioVenta) AS PrecioMedio,
MIN(PrecioVenta) AS PrecioMinimo,
MAX(PrecioVenta) AS PrecioMaximo,
SUM(Stock) AS StockTotal
FROM Productos
GROUP BY IdCategoria
HAVING StockTotal>400
ORDER BY StockTotal DESC,PrecioMedio DESC;



