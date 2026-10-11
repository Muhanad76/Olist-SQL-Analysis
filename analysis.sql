-- =====================================================
-- Olist E-commerce Data Analysis
-- تحليل بيانات التجارة الإلكترونية لمتجر Olist
--
-- SQL Portfolio Project
-- مشروع SQL لعرض المهارات في تحليل البيانات
-- =====================================================

-- Select the project database
-- تحديد قاعدة البيانات المستخدمة في المشروع
USE olist_sql_analysis;


-- =====================================================
-- 1. Total Number of Orders
-- 1. إجمالي عدد الطلبات
--
-- This query counts all records in the orders table.
-- هذا الاستعلام يحسب عدد السجلات الموجودة في جدول الطلبات.
-- =====================================================

SELECT COUNT(*) AS total_orders
FROM orders;


-- =====================================================
-- 2. Order Status Distribution
-- 2. توزيع الطلبات حسب الحالة
--
-- This query counts orders for each status and sorts
-- the results from highest to lowest.
-- هذا الاستعلام يحسب عدد الطلبات لكل حالة،
-- ويرتب النتائج من الأكبر إلى الأصغر.
-- =====================================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- 3. Total Sales Revenue
-- 3. إجمالي إيرادات المبيعات
--
-- This query calculates total product sales revenue.
-- هذا الاستعلام يحسب إجمالي إيرادات بيع المنتجات.
-- =====================================================

SELECT
    ROUND(SUM(price), 2) AS total_sales
FROM order_items;


-- =====================================================
-- 4. Total Freight Cost
-- 4. إجمالي تكاليف الشحن
--
-- This query calculates the total freight cost.
-- هذا الاستعلام يحسب إجمالي تكاليف الشحن.
-- =====================================================

SELECT
    ROUND(SUM(freight_value), 2) AS total_freight
FROM order_items;


-- =====================================================
-- 5. Average Product Price
-- 5. متوسط سعر المنتج
--
-- This query calculates the average price of order items.
-- هذا الاستعلام يحسب متوسط أسعار المنتجات في تفاصيل الطلبات.
-- =====================================================

SELECT
    ROUND(AVG(price), 2) AS average_product_price
FROM order_items;


-- =====================================================
-- 6. Payment Analysis by Type
-- 6. تحليل المدفوعات حسب النوع
--
-- This query shows the number of payments and total
-- payment value for each payment type.
-- هذا الاستعلام يعرض عدد عمليات الدفع وإجمالي قيمتها
-- لكل نوع من أنواع الدفع.
-- =====================================================

SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;


-- =====================================================
-- 7. Top 10 Product Categories by Revenue
-- 7. أعلى 10 فئات منتجات من حيث الإيرادات
-- 
-- This query joins order items with products to identify
-- the product categories generating the highest revenue.
-- هذا الاستعلام يربط تفاصيل الطلبات بالمنتجات لتحديد
-- فئات المنتجات الأعلى تحقيقًا للإيرادات.
-- =====================================================

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items AS oi
JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;


-- =====================================================
-- 8. Monthly Order Trend
-- 8. اتجاه عدد الطلبات شهريًا
--
-- This query counts orders for each month to analyze
-- changes in order volume over time.
-- هذا الاستعلام يحسب عدد الطلبات لكل شهر لتحليل
-- التغير في حجم الطلبات بمرور الوقت.
-- =====================================================

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;


-- =====================================================
-- 9. Revenue by Customer State
-- 9. الإيرادات حسب ولاية العميل
--
-- This query joins orders, customers, and order items
-- to calculate sales revenue for each customer state.
-- هذا الاستعلام يربط الطلبات والعملاء وتفاصيل الطلبات
-- لحساب إيرادات المبيعات لكل ولاية.
-- =====================================================

SELECT
    c.customer_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;


-- =====================================================
-- 10. Average Order Value
-- 10. متوسط قيمة الطلب
--
-- This query calculates the total product value of each
-- order, then calculates the average across all orders
-- represented in the order_items table.
-- هذا الاستعلام يحسب قيمة المنتجات في كل طلب،
-- ثم يحسب متوسط قيمة الطلبات الموجودة في جدول التفاصيل.
-- =====================================================

SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals;