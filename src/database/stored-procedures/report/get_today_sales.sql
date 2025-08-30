DROP PROCEDURE IF EXISTS get_today_order_details;
CREATE PROCEDURE get_today_order_details(
    IN date_value DATE
)
BEGIN
    SELECT o.salesRepId,
       o.orderDate,
       sr.name                                AS salesRepName,
       COUNT(DISTINCT o.id)                   AS totalOrders,
       SUM(oi.totalPrice)                     AS totalSales,
       (SELECT SUM(o2.paid)
        FROM tbl_order o2
        WHERE o2.salesRepId = o.salesRepId
          AND o2.orderStatus IN ('unpaid', 'completed')
          AND DATE(o2.orderDate) = date_value) AS cashOnHand,
       SUM(oi.totalPrice) -
       (SELECT SUM(o2.paid)
        FROM tbl_order o2
        WHERE o2.salesRepId = o.salesRepId
          AND o2.orderStatus IN ('unpaid', 'completed')
          AND DATE(o2.orderDate) = date_value) AS unpaidAmount
FROM tbl_order o
         JOIN tbl_order_item oi ON o.id = oi.orderId
         JOIN tbl_sales_rep sr ON o.salesRepId = sr.id
WHERE o.orderStatus IN ('unpaid', 'completed')
  AND DATE(o.orderDate) = date_value
GROUP BY o.salesRepId, sr.name, o.orderDate
ORDER BY o.salesRepId;
END;
