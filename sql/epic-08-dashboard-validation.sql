-- Epic 8: Admin Dashboard & Reporting
-- I used these queries to check whether the dashboard numbers matched the data in PostgreSQL.
-- I compared each result with what I saw on the Admin dashboard during testing.

-- 1. Total revenue: exclude cancelled orders.
SELECT SUM("TotalAmount") AS "TotalRevenue"
FROM public."Orders"
WHERE "Status" <> 'Cancelled';

-- 2. Monthly revenue: current month according to the database clock/time zone.
SELECT SUM("TotalAmount") AS "MonthlyRevenue"
FROM public."Orders"
WHERE DATE_TRUNC('month', "CreatedAt") = DATE_TRUNC('month', CURRENT_DATE)
  AND "Status" <> 'Cancelled';

-- 3. Total registered users.
SELECT COUNT(*) AS "TotalUsers"
FROM public."AspNetUsers";

-- 4. Active products.
SELECT COUNT(*) AS "TotalActiveProducts"
FROM public."Products"
WHERE "IsActive" = true;

-- 5. Total non-cancelled orders.
SELECT COUNT(*) AS "TotalOrders"
FROM public."Orders"
WHERE "Status" <> 'Cancelled';

-- 6. Pending orders.
SELECT COUNT(*) AS "PendingOrders"
FROM public."Orders"
WHERE "Status" = 'Pending';

-- 7. Active products with stock at or below the low-stock threshold.
SELECT COUNT(*) AS "LowStockProducts"
FROM public."Products"
WHERE "Stock" <= 10
  AND "IsActive" = true;

-- 8. Ten most recent orders.
SELECT *
FROM public."Orders"
ORDER BY "CreatedAt" DESC
LIMIT 10;

-- 9. Five best-selling products by quantity, excluding cancelled orders.
SELECT
    oi."ProductId",
    SUM(oi."Quantity") AS "TotalSold"
FROM public."OrderItems" oi
JOIN public."Orders" o
    ON oi."OrderId" = o."Id"
WHERE o."Status" <> 'Cancelled'
GROUP BY oi."ProductId"
ORDER BY "TotalSold" DESC
LIMIT 5;
