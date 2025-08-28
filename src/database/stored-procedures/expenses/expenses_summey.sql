DROP PROCEDURE IF EXISTS today_cash_summary;
CREATE PROCEDURE today_cash_summary(
)
BEGIN

    SET SESSION sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

    SELECT SUM(CASE
                   WHEN expensesType = 'Assigned' THEN amount
                   ELSE 0
        END),
           SUM(CASE WHEN expensesType = 'Income' THEN incomeAmount ELSE 0 END)
    INTO @todayCashOut ,@cashInHand
    FROM tbl_expense
    WHERE expensesDate = DATE_FORMAT(NOW(), '%Y-%m-%d');

    SELECT COALESCE(SUM(o.paid), 0) AS cashOnHand
    INTO @cashOnHand
    FROM tbl_order o
    WHERE o.orderStatus IN ('unpaid','completed')
      AND DATE(o.orderDate) = DATE_FORMAT(NOW(), '%Y-%m-%d');


    SELECT SUM(COALESCE(oiSum.totalOrderAmount, 0)) AS totalOrderAmount
    INTO @totalSales
    FROM tbl_order o
             INNER JOIN (SELECT orderId, SUM(totalPrice) AS totalOrderAmount
                         FROM tbl_order_item
                         GROUP BY orderId) oiSum ON o.id = oiSum.orderId
    WHERE DATE(o.orderDate) = DATE_FORMAT(NOW(), '%Y-%m-%d');


    SELECT COALESCE(@todayCashOut, 0) AS todayCashOut,
           COALESCE(@cashInHand, 0)   AS cashInHand,
           COALESCE(@totalSales, 0)   AS totalSales,
           COALESCE(@cashOnHand, 0)   AS cashOnHand;

END;
