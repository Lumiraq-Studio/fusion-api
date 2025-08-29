DROP PROCEDURE IF EXISTS sales_overview_week_get;

CREATE PROCEDURE sales_overview_week_get()

BEGIN
    SELECT
        WeekDay,
        SUM(TotalSales) AS TotalSales,
        SUM(TotalExpenses) AS TotalExpenses
    FROM (
             -- Aggregate orders and expenses per day
             SELECT
                 ELT(WEEKDAY(dayDate)+1, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') AS WeekDay,
                 WEEKDAY(dayDate) AS WeekDayNum,
                 TotalSales,
                 TotalExpenses
             FROM (
                      -- Orders as TotalSales
                      SELECT o.createdAt AS dayDate, SUM(oi.totalPrice) AS TotalSales, 0 AS TotalExpenses
                      FROM tbl_order o
                               INNER JOIN tbl_order_item oi ON o.id = oi.orderId
                      WHERE o.orderStatus IN ('paid', 'unpaid', 'completed')
                        AND YEARWEEK(o.createdAt, 1) = YEARWEEK(CURDATE(), 1)
                      GROUP BY o.createdAt

                      UNION ALL

                      -- Expenses as TotalExpenses
                      SELECT e.createdAt AS dayDate, 0 AS TotalSales, SUM(e.expendAmount) AS TotalExpenses
                      FROM tbl_expense e
                      WHERE e.expensesType = 'Expense'
                        AND YEARWEEK(e.createdAt, 1) = YEARWEEK(CURDATE(), 1)
                      GROUP BY e.createdAt
                  ) AS combined
         ) AS sub
    GROUP BY WeekDay, WeekDayNum
    ORDER BY WeekDayNum;
END;
