SELECT Provincia, COUNT (*) AS NumeroClientes
FROM Clientes
GROUP BY Provincia
ORDER BY NumeroClientes DESC;

SELECT IdCategoria, COUNT (*) AS NumeroProductos
FROM Productos
GROUP BY IdCategoria;

SELECT IdCategoria, AVG(PrecioVenta) AS PrecioMedio
FROM Productos
GROUP BY IdCategoria;

SELECT IdCategoria, SUM(Stock) AS StockTotal
FROM Productos
GROUP BY IdCategoria;

SELECT IdCategoria,
MAX(PrecioVenta) AS PrecioMaximo,
MIN(PrecioVenta) AS PrecioMinimo
FROM Productos
ORDER BY IdCategoria;

SELECT Provincia, COUNT(*) AS NumeroClientes
FROM Clientes
GROUP BY Provincia
HAVING NumeroClientes >2;

SELECT IdCategoria, AVG(PrecioVenta) AS PrecioMedio
FROM Productos
GROUP BY IdCategoria
HAVING PrecioMedio >100;

SELECT IdCategoria, COUNT(*) AS NumeroProductos,
AVG(PrecioVenta) AS PrecioMedio,
MAX(PrecioVenta) AS PrecioMaximo,
MIN(PrecioVenta) AS PrecioMinimo
FROM Productos
GROUP BY IdCategoria;
