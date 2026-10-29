-- ============================================================
--  INFORME VENTAS COMPLETO — DataRetail Levante, S.L.
--  Base de datos: ventas.db (SQLite)
--  Caso práctico: Data Analyst Portfolio
-- ============================================================


-- ============================================================
--  SECCIÓN 1: INDICADORES GENERALES DEL NEGOCIO (KPIs)
-- ============================================================

-- 1.1 Total de clientes registrados
SELECT COUNT(*) AS TotalClientes
FROM Clientes;

-- 1.2 Resumen del catálogo de productos
SELECT
    COUNT(*)                  AS TotalProductos,
    ROUND(AVG(PrecioVenta),2) AS PrecioMedio,
    MIN(PrecioVenta)          AS PrecioMinimo,
    MAX(PrecioVenta)          AS PrecioMaximo,
    SUM(Stock)                AS StockTotal
FROM Productos;

-- 1.3 Facturación total (con descuentos aplicados)
SELECT
    COUNT(DISTINCT v.IdVenta)                                                                     AS TotalVentas,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)                  AS FacturacionReal,
    ROUND(AVG(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)                  AS TicketMedioPorLinea
FROM Ventas v
JOIN LineasVenta lv ON lv.IdVenta = v.IdVenta;

-- 1.4 Ticket medio por venta (importe total / número de ventas)
SELECT
    ROUND(
        SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)) /
        COUNT(DISTINCT v.IdVenta)
    , 2) AS TicketMedioVenta
FROM Ventas v
JOIN LineasVenta lv ON lv.IdVenta = v.IdVenta;


-- ============================================================
--  SECCIÓN 2: ANÁLISIS DE CLIENTES
-- ============================================================

-- 2.1 Listado completo de clientes con tipo
SELECT NombreCliente, Ciudad, Provincia, TipoCliente, FechaAlta
FROM Clientes
ORDER BY Provincia, NombreCliente;

-- 2.2 Clientes por provincia
SELECT Provincia, COUNT(*) AS NumClientes
FROM Clientes
GROUP BY Provincia
ORDER BY NumClientes DESC;

-- 2.3 Clientes por tipo (Empresa / Autónomo)
SELECT TipoCliente, COUNT(*) AS NumClientes
FROM Clientes
GROUP BY TipoCliente;

-- 2.4 Clientes con más pedidos
SELECT c.NombreCliente, COUNT(DISTINCT v.IdVenta) AS NumPedidos
FROM Clientes c
JOIN Ventas v ON c.IdCliente = v.IdCliente
GROUP BY c.IdCliente
ORDER BY NumPedidos DESC;

-- 2.5 Top 5 clientes por facturación total
SELECT
    c.NombreCliente,
    COUNT(DISTINCT v.IdVenta)                                                       AS NumPedidos,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)    AS TotalComprado
FROM Clientes c
JOIN Ventas v      ON c.IdCliente = v.IdCliente
JOIN LineasVenta lv ON v.IdVenta  = lv.IdVenta
GROUP BY c.IdCliente
ORDER BY TotalComprado DESC
LIMIT 5;

-- 2.6 Clientes sin ninguna compra (clientes inactivos)
SELECT NombreCliente, FechaAlta
FROM Clientes
WHERE IdCliente NOT IN (SELECT DISTINCT IdCliente FROM Ventas)
ORDER BY FechaAlta;


-- ============================================================
--  SECCIÓN 3: ANÁLISIS DE PRODUCTOS
-- ============================================================

-- 3.1 Catálogo completo con categoría y proveedor
SELECT
    p.NombreProducto,
    cat.NombreCategoria,
    prov.NombreProveedor,
    p.PrecioCoste,
    p.PrecioVenta,
    ROUND(p.PrecioVenta - p.PrecioCoste, 2)                     AS MargenBruto,
    ROUND((p.PrecioVenta - p.PrecioCoste) / p.PrecioVenta * 100, 1) AS MargenPct,
    p.Stock
FROM Productos p
JOIN Categorias  cat  ON p.IdCategoria  = cat.IdCategoria
JOIN Proveedores prov ON p.IdProveedor  = prov.IdProveedor
ORDER BY MargenPct DESC;

-- 3.2 Indicadores por categoría
SELECT
    cat.NombreCategoria,
    COUNT(*)                  AS NumProductos,
    ROUND(AVG(p.PrecioVenta),2) AS PrecioMedio,
    MIN(p.PrecioVenta)          AS PrecioMinimo,
    MAX(p.PrecioVenta)          AS PrecioMaximo,
    SUM(p.Stock)                AS StockTotal
FROM Productos p
JOIN Categorias cat ON p.IdCategoria = cat.IdCategoria
GROUP BY cat.IdCategoria
ORDER BY StockTotal DESC;

-- 3.3 Productos con stock bajo (menos de 20 unidades)
SELECT NombreProducto, Stock
FROM Productos
WHERE Stock < 20
ORDER BY Stock ASC;

-- 3.4 Top 5 productos más vendidos (por unidades)
SELECT
    p.NombreProducto,
    SUM(lv.Cantidad) AS UnidadesVendidas
FROM LineasVenta lv
JOIN Productos p ON lv.IdProducto = p.IdProducto
GROUP BY lv.IdProducto
ORDER BY UnidadesVendidas DESC
LIMIT 5;

-- 3.5 Top 5 productos que más ingresos generan
SELECT
    p.NombreProducto,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2) AS ImporteTotal,
    SUM(lv.Cantidad)                                                               AS Unidades
FROM LineasVenta lv
JOIN Productos p ON lv.IdProducto = p.IdProducto
GROUP BY lv.IdProducto
ORDER BY ImporteTotal DESC
LIMIT 5;

-- 3.6 Productos sin ventas registradas
SELECT NombreProducto, Stock
FROM Productos
WHERE IdProducto NOT IN (SELECT DISTINCT IdProducto FROM LineasVenta)
ORDER BY NombreProducto;


-- ============================================================
--  SECCIÓN 4: ANÁLISIS TEMPORAL DE VENTAS
-- ============================================================

-- 4.1 Ventas por mes (facturación real)
SELECT
    strftime('%Y-%m', v.FechaVenta)                                                   AS Mes,
    COUNT(DISTINCT v.IdVenta)                                                          AS NumVentas,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)       AS FacturacionMes
FROM Ventas v
JOIN LineasVenta lv ON v.IdVenta = lv.IdVenta
GROUP BY Mes
ORDER BY Mes;

-- 4.2 Ventas por trimestre
SELECT
    CASE
        WHEN CAST(strftime('%m', FechaVenta) AS INTEGER) BETWEEN 1 AND 3  THEN 'Q1 2025'
        WHEN CAST(strftime('%m', FechaVenta) AS INTEGER) BETWEEN 4 AND 6  THEN 'Q2 2025'
        WHEN CAST(strftime('%m', FechaVenta) AS INTEGER) BETWEEN 7 AND 9  THEN 'Q3 2025'
        ELSE 'Q4 2025'
    END AS Trimestre,
    COUNT(DISTINCT v.IdVenta)                                                    AS NumVentas,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)),2)  AS FacturacionTrimestre
FROM Ventas v
JOIN LineasVenta lv ON v.IdVenta = lv.IdVenta
GROUP BY Trimestre
ORDER BY Trimestre;

-- 4.3 Mejor mes del año
SELECT
    strftime('%Y-%m', v.FechaVenta)                                                   AS Mes,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)       AS FacturacionMes
FROM Ventas v
JOIN LineasVenta lv ON v.IdVenta = lv.IdVenta
GROUP BY Mes
ORDER BY FacturacionMes DESC
LIMIT 1;

-- 4.4 Ventas por canal (Online / Presencial / Teléfono)
SELECT
    v.CanalVenta,
    COUNT(DISTINCT v.IdVenta)                                                    AS NumVentas,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)),2)  AS FacturacionCanal
FROM Ventas v
JOIN LineasVenta lv ON v.IdVenta = lv.IdVenta
GROUP BY v.CanalVenta
ORDER BY FacturacionCanal DESC;

-- 4.5 Ventas por forma de pago
SELECT
    v.FormaPago,
    COUNT(DISTINCT v.IdVenta)                                                    AS NumVentas,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)),2)  AS Total
FROM Ventas v
JOIN LineasVenta lv ON v.IdVenta = lv.IdVenta
GROUP BY v.FormaPago
ORDER BY Total DESC;


-- ============================================================
--  SECCIÓN 5: ANÁLISIS CON JOIN — VENTAS DETALLADAS
-- ============================================================

-- 5.1 Detalle de cada venta: cliente, empleado, importe total
SELECT
    v.IdVenta,
    v.FechaVenta,
    c.NombreCliente,
    e.NombreEmpleado,
    v.CanalVenta,
    v.FormaPago,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2) AS ImporteVenta
FROM Ventas v
JOIN Clientes     c  ON v.IdCliente  = c.IdCliente
JOIN Empleados    e  ON v.IdEmpleado = e.IdEmpleado
JOIN LineasVenta  lv ON v.IdVenta    = lv.IdVenta
GROUP BY v.IdVenta
ORDER BY v.FechaVenta;

-- 5.2 Rendimiento por empleado
SELECT
    e.NombreEmpleado,
    COUNT(DISTINCT v.IdVenta)                                                    AS VentasGestionadas,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)),2)  AS FacturacionTotal
FROM Empleados e
JOIN Ventas v      ON e.IdEmpleado = v.IdEmpleado
JOIN LineasVenta lv ON v.IdVenta   = lv.IdVenta
GROUP BY e.IdEmpleado
ORDER BY FacturacionTotal DESC;

-- 5.3 Líneas de venta con nombre de producto y cliente
SELECT
    v.FechaVenta,
    c.NombreCliente,
    p.NombreProducto,
    lv.Cantidad,
    lv.PrecioUnitario,
    lv.Descuento,
    ROUND(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0), 2) AS ImporteLinea
FROM LineasVenta lv
JOIN Ventas    v ON lv.IdVenta    = v.IdVenta
JOIN Clientes  c ON v.IdCliente   = c.IdCliente
JOIN Productos p ON lv.IdProducto = p.IdProducto
ORDER BY v.FechaVenta, v.IdVenta;


-- ============================================================
--  SECCIÓN 6: SUBCONSULTAS Y CONSULTAS AVANZADAS
-- ============================================================

-- 6.1 Clientes que han comprado el producto más caro del catálogo
SELECT DISTINCT c.NombreCliente, c.Provincia
FROM Clientes c
JOIN Ventas v      ON c.IdCliente  = v.IdCliente
JOIN LineasVenta lv ON v.IdVenta   = lv.IdVenta
WHERE lv.IdProducto = (
    SELECT IdProducto FROM Productos ORDER BY PrecioVenta DESC LIMIT 1
);

-- 6.2 Productos cuyo precio de venta supera la media del catálogo
SELECT NombreProducto, PrecioVenta
FROM Productos
WHERE PrecioVenta > (SELECT AVG(PrecioVenta) FROM Productos)
ORDER BY PrecioVenta DESC;

-- 6.3 Mes con mayor facturación (subconsulta)
SELECT Mes, FacturacionMes
FROM (
    SELECT
        strftime('%Y-%m', v.FechaVenta)                                                    AS Mes,
        ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)        AS FacturacionMes
    FROM Ventas v
    JOIN LineasVenta lv ON v.IdVenta = lv.IdVenta
    GROUP BY Mes
) AS VentasMes
ORDER BY FacturacionMes DESC
LIMIT 1;

-- 6.4 Clasificación de clientes por volumen de compra con CASE WHEN
SELECT
    c.NombreCliente,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2) AS TotalComprado,
    CASE
        WHEN SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)) >= 2000 THEN 'VIP'
        WHEN SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)) >= 1000 THEN 'Frecuente'
        ELSE 'Ocasional'
    END AS SegmentoCliente
FROM Clientes c
JOIN Ventas v      ON c.IdCliente = v.IdCliente
JOIN LineasVenta lv ON v.IdVenta  = lv.IdVenta
GROUP BY c.IdCliente
ORDER BY TotalComprado DESC;

-- 6.5 Margen bruto total del negocio
SELECT
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)), 2)              AS IngresoTotal,
    ROUND(SUM(lv.Cantidad * p.PrecioCoste), 2)                                                AS CosteTotal,
    ROUND(SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0))
          - SUM(lv.Cantidad * p.PrecioCoste), 2)                                              AS MargenBruto,
    ROUND(
        (SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0))
         - SUM(lv.Cantidad * p.PrecioCoste))
        / SUM(lv.Cantidad * lv.PrecioUnitario * (1 - lv.Descuento / 100.0)) * 100
    , 1)                                                                                       AS MargenPct
FROM LineasVenta lv
JOIN Productos p ON lv.IdProducto = p.IdProducto;

-- ============================================================
--  FIN DEL INFORME
-- ============================================================
