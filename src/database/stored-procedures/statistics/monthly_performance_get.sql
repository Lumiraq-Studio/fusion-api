DROP PROCEDURE IF EXISTS monthly_performance_get;

CREATE PROCEDURE monthly_performance_get()
BEGIN
    -- Derived table for all months
    SELECT
        m.MonthShort,
        COALESCE(SUM(oi.totalPrice), 0) AS MonthlyRevenue,
        COALESCE(COUNT(DISTINCT o.id), 0) AS OrdersCount
    FROM (
             SELECT 1 AS MonthNum, 'Jan' AS MonthShort UNION ALL
             SELECT 2, 'Feb' UNION ALL
             SELECT 3, 'Mar' UNION ALL
             SELECT 4, 'Apr' UNION ALL
             SELECT 5, 'May' UNION ALL
             SELECT 6, 'Jun' UNION ALL
             SELECT 7, 'Jul' UNION ALL
             SELECT 8, 'Aug' UNION ALL
             SELECT 9, 'Sep' UNION ALL
             SELECT 10, 'Oct' UNION ALL
             SELECT 11, 'Nov' UNION ALL
             SELECT 12, 'Dec'
         ) AS m
             LEFT JOIN tbl_order o
                       ON MONTH(o.createdAt) = m.MonthNum
                           AND YEAR(o.createdAt) = YEAR(CURDATE())
                           AND o.orderStatus IN ('paid', 'unpaid', 'completed')
             LEFT JOIN tbl_order_item oi
                       ON o.id = oi.orderId
    GROUP BY m.MonthNum, m.MonthShort
    ORDER BY m.MonthNum;
END;
