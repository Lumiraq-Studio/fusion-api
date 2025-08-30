DROP PROCEDURE IF EXISTS sales_order_summary;
CREATE PROCEDURE sales_order_summary()
BEGIN
    DECLARE total_sales_this_month DECIMAL(10, 2);
    DECLARE total_sales_last_month DECIMAL(10, 2);
    DECLARE completed_orders_this_month INT;
    DECLARE unpaid_orders_this_month INT;
    DECLARE cancelled_orders_this_month INT;
    DECLARE avg_order_value_this_month DECIMAL(10, 2);
    DECLARE total_orders_this_month INT;

    SELECT SUM(oi.totalPrice)
    INTO total_sales_this_month
    FROM tbl_order_item oi
             JOIN tbl_order o ON oi.orderId = o.id
    WHERE YEAR(o.orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(o.orderDate) = MONTH(CURRENT_DATE());

    SELECT SUM(oi.totalPrice)
    INTO total_sales_last_month
    FROM tbl_order_item oi
             JOIN tbl_order o ON oi.orderId = o.id
    WHERE YEAR(o.orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(o.orderDate) = MONTH(CURRENT_DATE()) - 1;

    SELECT COUNT(*)
    INTO completed_orders_this_month
    FROM tbl_order
    WHERE YEAR(orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(orderDate) = MONTH(CURRENT_DATE())
      AND orderStatus = 'Completed';

    SELECT COUNT(*)
    INTO unpaid_orders_this_month
    FROM tbl_order
    WHERE YEAR(orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(orderDate) = MONTH(CURRENT_DATE())
      AND orderStatus = 'Unpaid';

    SELECT COUNT(*)
    INTO cancelled_orders_this_month
    FROM tbl_order
    WHERE YEAR(orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(orderDate) = MONTH(CURRENT_DATE())
      AND orderStatus = 'Cancelled';

    SELECT COUNT(*)
    INTO total_orders_this_month
    FROM tbl_order
    WHERE YEAR(orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(orderDate) = MONTH(CURRENT_DATE());

    SELECT IFNULL(SUM(oi.totalPrice) / COUNT(DISTINCT o.id), 0)
    INTO avg_order_value_this_month
    FROM tbl_order_item oi
             JOIN tbl_order o ON oi.orderId = o.id
    WHERE YEAR(o.orderDate) = YEAR(CURRENT_DATE())
      AND MONTH(o.orderDate) = MONTH(CURRENT_DATE());

    SELECT total_sales_this_month       AS `TotalSalesThisMonth`,
           total_sales_last_month       AS `TotalSalesLastMonth`,
           completed_orders_this_month  AS `CompletedOrdersThisMonth`,
           unpaid_orders_this_month     AS `UnpaidOrdersThisMonth`,
           cancelled_orders_this_month  AS `CancelledOrdersThisMonth`,
           avg_order_value_this_month   AS `AvgOrderValueThisMonth`,
           total_orders_this_month      AS `TotalOrdersThisMonth`;
END;
