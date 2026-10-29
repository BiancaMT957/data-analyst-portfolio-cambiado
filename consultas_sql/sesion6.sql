-- ¿Cuántos clientes hay registrados?
SELECT COUNT(*) AS NumClientes FROM Clientes;

-- ¿Cuántos productos existen?
SELECT COUNT(*) AS NumProductos FROM Productos;

-- ¿Cuál es el precio medio de los productos?
SELECT AVG(PrecioVenta) FROM Productos;

-- ¿Cuál es el producto más caro?
SELECT MAX(PrecioVenta) AS ProductoMasCaro FROM Productos;

-- ¿Cuál es el producto más barato?
SELECT MIN(PrecioVenta) AS ProductoMasBarato FROM Productos;

-- ¿Cuál es el stock total disponible?
SELECT SUM(Stock) AS StockTodoEnAlmacen FROM Productos;

-- ¿Cuántos clientes pertenecen a Alicante?
SELECT COUNT(*) AS ClientesAlicante FROM Clientes WHERE Provincia='Alicante';

-- ¿Precio medio de productos con stock > 50?
SELECT AVG(PrecioVenta) AS PrecioMedio FROM Productos WHERE Stock > 20;

-- ¿Importe total vendido en el primer trimestre?
SELECT SUM((Cantidad*PrecioUnitario)-((Cantidad*PrecioUnitario*(Descuento/100)))) AS ImporteTotal 
FROM LineasVenta,Ventas WHERE LineasVenta.IdVenta = Ventas.IdVenta AND 
FechaVenta BETWEEN '2025-01-01' AND '2025-03-31';

-- En una consulta: nº productos, precio medio, mínimo y máximo
SELECT COUNT(*) AS NumProducto,  
AVG(PrecioVenta) AS PrecioMedio, 
MIN(PRecioVenta) AS PrecioMinimo, 
MAX(PrecioVenta) AS PrecioMaximo 
FROM Productos;