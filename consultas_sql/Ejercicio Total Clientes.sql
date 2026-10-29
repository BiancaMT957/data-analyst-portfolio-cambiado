-- TOTAL DE CLIENTES
SELECT COUNT(*) AS TotalClientes
FROM Clientes;

-- INDICADORES DE CATÁLOGO DE PRODUCTOS
-- TotalProductos  -> amplitud del catálogo
-- PrecioMedio     -> posicionamiento de precios medio del catálogo (€)
-- PrecioMinimo    -> producto más barato (€)
-- PrecioMaximo    -> producto más caro (€)
-- StockTotal      -> unidades disponibles en almacén (uds)
SELECT
    COUNT(*)                  AS TotalProductos,
    ROUND(AVG(PrecioVenta),2) AS PrecioMedio,
    MIN(PrecioVenta)          AS PrecioMinimo,
    MAX(PrecioVenta)          AS PrecioMaximo,
    SUM(Stock)                AS StockTotal
FROM Productos;

-- INDICADORES DE VENTAS
-- TotalVentas       -> número de operaciones/tickets de venta registrados
-- FacturacionTotal  -> importe total facturado (€), calculado desde LineasVenta
SELECT
    COUNT(DISTINCT V.IdVenta)                         AS TotalVentas,
    SUM(L.Cantidad * L.PrecioUnitario - L.Descuento)  AS FacturacionTotal
FROM Ventas V
JOIN LineasVenta L ON L.IdVenta = V.IdVenta;

-- Producto más caro
SELECT NombreProducto, PrecioVenta
FROM Productos
ORDER BY PrecioVenta DESC
LIMIT 1;

-- Producto más barato
SELECT NombreProducto, PrecioVenta
FROM Productos
ORDER BY PrecioVenta ASC
LIMIT 1;