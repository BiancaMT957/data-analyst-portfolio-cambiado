SELECT COUNT(*) FROM Clientes;

SELECT COUNT(Telefono) FROM Proveedores;

SELECT SUM(Cantidad*PrecioUnitario) AS ImporteVentas FROM LineasVenta;

SELECT SUM(Cantidad*PrecioUnitario) AS ImporteVentas, AVG(Cantidad*PrecioUnitario) FROM LineasVenta;

SELECT AVG(PrecioVenta) FROM Productos;

SELECT AVG(PrecioVenta), AVG(PrecioCoste) FROM Productos;

SELECT COUNT(*) AS NumeroProductos,
			SUM(PrecioVenta*Stock) AS ValorProductos, AVG(PrecioVenta) AS PVPMedio,
			MAX(PrecioVenta) AS ValorMasCaro, MIN(PrecioVenta) AS ValorMasBarato, 
			SUM(PrecioCoste*Stock) AS ValorCompraTotal, AVG(PrecioCoste) AS PVDMedio,
			MAX(PrecioCoste) AS CosteMayor, MIN(PrecioCoste) AS CosteMenor
			FROM Productos;

SELECT COUNT(*) FROM Clientes WHERE Provincia='Alicante' AND Ciudad='Elche';

SELECT SUM(Cantidad*PrecioUnitario) AS ImporteVentas,
			AVG(Cantidad*PrecioUnitario) AS TicketMedio 
			FROM LineasVenta,Ventas 
			WHERE LineasVenta.IdVenta = Ventas.IdVenta AND
			FechaVenta BETWEEN '2025-01-01' AND '2025-01-31';

