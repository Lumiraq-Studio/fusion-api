DROP PROCEDURE IF EXISTS base_statistics_get;

CREATE PROCEDURE base_statistics_get()
BEGIN
    DECLARE total_orders INT;
    DECLARE unpaid_orders INT;
    DECLARE unpaid_orders_over_month INT;

    DECLARE active_customers_alltime INT;
    DECLARE customers_this_month INT;
    DECLARE customers_last_month INT;
    DECLARE customer_change_percentage DECIMAL(10,2);

    DECLARE revenue_this_month DECIMAL(18,2);
    DECLARE revenue_last_month DECIMAL(18,2);
    DECLARE revenue_change_percentage DECIMAL(10,2);

    SELECT COUNT(*) INTO total_orders
    FROM (
             SELECT orderReference
             FROM tbl_order
             WHERE YEAR(createdAt) = YEAR(CURDATE())
               AND MONTH(createdAt) = MONTH(CURDATE())
             GROUP BY orderReference
         ) AS sub;

    SELECT COUNT(*) INTO unpaid_orders
    FROM (
             SELECT orderReference
             FROM tbl_order
             WHERE orderStatus = 'unpaid'
             GROUP BY orderReference
         ) AS sub;

    SELECT COUNT(*) INTO unpaid_orders_over_month
    FROM (
             SELECT orderReference
             FROM tbl_order
             WHERE orderStatus = 'unpaid'
               AND createdAt < DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
             GROUP BY orderReference
         ) AS sub;

    SELECT COUNT(*) INTO active_customers_alltime
    FROM tbl_shop
    WHERE status = 'active';

    SELECT COUNT(*) INTO customers_this_month
    FROM tbl_shop
    WHERE status = 'active'
      AND YEAR(createdAt) = YEAR(CURDATE())
      AND MONTH(createdAt) = MONTH(CURDATE());

    SELECT COUNT(*) INTO customers_last_month
    FROM tbl_shop
    WHERE status = 'active'
      AND YEAR(createdAt) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
      AND MONTH(createdAt) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

    IF customers_last_month = 0 THEN
        SET customer_change_percentage = 100.00;
    ELSE
        SET customer_change_percentage =
                ((customers_this_month - customers_last_month) / customers_last_month) * 100;
    END IF;

    SELECT COALESCE(SUM(oi.totalPrice),0) INTO revenue_this_month
    FROM tbl_order o
             INNER JOIN tbl_order_item oi ON o.id = oi.orderId
    WHERE o.orderStatus IN ('paid', 'unpaid', 'completed')
      AND YEAR(o.createdAt) = YEAR(CURDATE())
      AND MONTH(o.createdAt) = MONTH(CURDATE());

    SELECT COALESCE(SUM(oi.totalPrice),0) INTO revenue_last_month
    FROM tbl_order o
             INNER JOIN tbl_order_item oi ON o.id = oi.orderId
    WHERE o.orderStatus IN ('paid', 'unpaid', 'completed')
      AND YEAR(o.createdAt) = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))
      AND MONTH(o.createdAt) = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH));

    IF revenue_last_month = 0 THEN
        SET revenue_change_percentage = 100.00;
    ELSE
        SET revenue_change_percentage =
                ((revenue_this_month - revenue_last_month) / revenue_last_month) * 100;
    END IF;

    SELECT
        total_orders AS TotalOrdersThisMonth,
        unpaid_orders AS UnpaidOrders,
        unpaid_orders_over_month AS UnpaidOrdersOverMonth,
        active_customers_alltime AS ActiveCustomersAllTime,
        customers_this_month AS CustomersThisMonth,
        customers_last_month AS CustomersLastMonth,
        CONCAT(IF(customer_change_percentage >= 0,'+',''), ROUND(customer_change_percentage,2), '%') AS CustomerChangePercentage,
        revenue_this_month AS RevenueThisMonth,
        revenue_last_month AS RevenueLastMonth,
        CONCAT(IF(revenue_change_percentage >= 0,'+',''), ROUND(revenue_change_percentage,2), '%') AS RevenueChangePercentage;
END;
