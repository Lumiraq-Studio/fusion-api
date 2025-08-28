DROP PROCEDURE IF EXISTS sales_screen;
CREATE PROCEDURE sales_screen()
BEGIN

    DECLARE total_sales_people INT;
    DECLARE active_members INT;
    DECLARE avg_monthly_sales DECIMAL(10, 2);
    DECLARE target_achievement_percentage DECIMAL(5, 2);
    DECLARE target_amount DECIMAL(10, 2);


    SELECT COUNT(*)
    INTO total_sales_people
    FROM tbl_sales_rep;


    SELECT COUNT(*)
    INTO active_members
    FROM tbl_sales_rep
    WHERE status = 'A';


    SELECT AVG(monthly_sales)
    INTO avg_monthly_sales
    FROM (SELECT SUM(oi.totalPrice) AS monthly_sales
          FROM tbl_order_item oi
                   JOIN
               tbl_order o ON oi.orderId = o.id

          GROUP BY YEAR(o.orderDate), MONTH(o.orderDate)) AS monthly_sales;


    SET target_amount = 1000000;



    SELECT (SUM(oi.totalPrice) / target_amount) * 100
    INTO target_achievement_percentage
    FROM tbl_order_item oi
             JOIN tbl_order o ON oi.orderId = o.id
    ;


    SELECT total_sales_people            AS `totalSalesPeople`,
           active_members                AS `activeMembers`,
           avg_monthly_sales             AS `avgMonthlySales`,
           target_achievement_percentage AS `targetAchievementPercentage`;

END