
-- INFORME PARA LA DIRECCIÓN COMERCIAL


-- Bloque 1: Indicador de Clientes
SELECT 
    COUNT(*) AS TotalClientes 
FROM Clientes;

-- Bloque 2: Indicadores de Productos (Precio Medio, Más Caro, Más Barato y Stock)
SELECT
    COUNT(*) AS TotalProductos,
    AVG(PrecioVenta) AS PrecioMedio,
    MIN(PrecioVenta) AS PrecioMinimo,
    MAX(PrecioVenta) AS PrecioMaximo,
    SUM(Stock) AS StockTotal
FROM Productos;

-- Bloque 3: Indicadores de Ventas (Total de Ventas y Facturación Real)
SELECT
    COUNT(DISTINCT Ventas.IdVenta) AS TotalVentasRegistradas,
    SUM((Cantidad * PrecioUnitario) - ((Cantidad * PrecioUnitario * (Descuento / 100)))) AS FacturacionTotal
FROM LineasVenta
INNER JOIN Ventas ON LineasVenta.IdVenta = Ventas.IdVenta;
