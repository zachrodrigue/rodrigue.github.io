-- 1.1 Warehouse Capacity and Inventory
SELECT 
    w.warehouseCode,
    w.warehouseName,
    w.warehousePctCap,
    COUNT(DISTINCT p.productCode) AS num_product, 
    SUM(p.quantityInStock) AS total_inventory,
    ROUND(SUM(p.quantityInStock) / (w.warehousePctCap / 100), 0) AS estimated_total_capacity,
    (100 - w.warehousePctCap) AS pct_space_available
FROM mintclassics.products p
JOIN mintclassics.warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY w.warehouseCode, w.warehouseName, w.warehousePctCap
ORDER BY estimated_total_capacity;

-- 1.2 Warehouse with Least Demanded Product Lines
SELECT 
    p.warehouseCode,
    w.warehouseName,
    p.productLine AS product_line,
    SUM(p.quantityInStock) AS line_quantity
FROM mintclassics.products AS p
JOIN mintclassics.warehouses AS w
ON p.warehouseCode = w.warehouseCode
GROUP BY 1,2,3
ORDER BY SUM(quantityInStock);


-- 2.1 Revenue by Product Lines
SELECT 
    p.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM mintclassics.products p
JOIN mintclassics.orderdetails od ON p.productCode = od.productCode
GROUP BY 1
ORDER BY total_revenue DESC;

-- 2.2 Revenue per Item (Top 10)
SELECT
    p.productName,
    p.quantityInStock,
    od.priceEach,
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM mintclassics.products AS p
JOIN mintclassics.orderdetails AS od
ON p.productCode = od.productCode
GROUP BY p.productName, p.quantityInStock, od.priceEach
ORDER BY total_revenue DESC
LIMIT 10;

-- 2.3 Revenue per Item (Bottom 10)
SELECT
    p.productName,
    p.quantityInStock,
    od.priceEach,
    SUM(od.quantityOrdered * od.priceEach) AS total_revenue
FROM mintclassics.products AS p
JOIN mintclassics.orderdetails AS od
ON p.productCode = od.productCode
GROUP BY p.productName, p.quantityInStock, od.priceEach
ORDER BY total_revenue
LIMIT 10;

-- 3.1 Seasonality by Product Line (Warehouse D)
SELECT 
    p.productLine,
    MONTH(o.orderDate) AS order_month,
    SUM(od.quantityOrdered) AS total_units_sold
FROM mintclassics.orders o
JOIN mintclassics.orderdetails od ON o.orderNumber = od.orderNumber
JOIN mintclassics.products p ON od.productCode = p.productCode
WHERE p.productLine IN ('Trains', 'Ships', 'Trucks and Buses')
GROUP BY p.productLine, order_month
ORDER BY p.productLine, order_month;


-- 4.1 Inventory vs. Sales (Top Surplus)
SELECT
    w.warehouseCode,
    p.productName,
    p.quantityInStock,
    SUM(od.quantityOrdered) AS total_units_sold,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS inventory_surplus_deficit
FROM mintclassics.products AS p
JOIN mintclassics.orderdetails AS od
ON p.productCode = od.productCode
JOIN mintclassics.warehouses AS w
ON p.warehouseCode = w.warehouseCode
GROUP BY 1,2,3
ORDER BY inventory_surplus_deficit DESC;

-- 4.2 Inventory vs. Sales (Top Deficit)
SELECT
    w.warehouseCode,
    p.productName,
    p.quantityInStock,
    SUM(od.quantityOrdered) AS total_units_sold,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS inventory_surplus_deficit
FROM mintclassics.products AS p
JOIN mintclassics.orderdetails AS od
ON p.productCode = od.productCode
JOIN mintclassics.warehouses AS w
ON p.warehouseCode = w.warehouseCode
GROUP BY 1,2,3
ORDER BY inventory_surplus_deficit;

-- 5.1 Slow-Moving or Non-Moving Items
SELECT 
    p.productCode,
    p.productName,
    p.quantityInStock,
    IFNULL(SUM(od.quantityOrdered), 0) AS total_units_sold,
    (p.quantityInStock - IFNULL(SUM(od.quantityOrdered), 0)) AS inventory_not_sold
FROM products p
LEFT JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
HAVING total_units_sold = 0 OR total_units_sold < 100
ORDER BY inventory_not_sold DESC;

-- 6.1 Inventory Turnover Ratio
SELECT 
    p.productCode,
    p.productName,
    p.quantityInStock,
    SUM(od.quantityOrdered) AS total_units_sold,
    (SUM(od.quantityOrdered) / p.quantityInStock) AS inventory_turnover_ratio
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName, p.quantityInStock
ORDER BY inventory_turnover_ratio ASC;

