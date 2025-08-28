DROP PROCEDURE IF EXISTS sales_rep_order_details;
CREATE PROCEDURE sales_rep_order_details(
    IN rep_stock_id INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            GET DIAGNOSTICS CONDITION 1
                @sqlstate = RETURNED_SQLSTATE,
                @errno = MYSQL_ERRNO,
                @message_text = MESSAGE_TEXT;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;


    SELECT IFNULL(SUM(te.amount), 0)
    INTO @pettyCash
    FROM tbl_expense te
    WHERE te.salesRepId = 5
      AND DATE(te.expensesDate) = CURDATE();


    SELECT toi.repStockId,
           IFNULL(NULLIF(SUM(too.paid), 0), 0)                     AS cashOnHand,
           IFNULL(NULLIF(SUM(toi.totalPrice), 0), 0)               AS totalOrderValue,
           IFNULL(NULLIF(SUM(toi.totalPrice - too.paid), 0), NULL) AS unpaidValue,
           IFNULL(NULLIF(SUM(toi.totalPrice), 0), 0)               AS todayOrderValue,
           @pettyCash                                              AS pettyCashValue
    FROM tbl_order too
             JOIN tbl_order_item toi ON too.id = toi.orderId
    WHERE too.salesRepId = rep_stock_id
      AND DATE(too.orderDate) = CURDATE()
      AND toi.repStockId IS NOT NULL
    GROUP BY toi.repStockId;
    COMMIT;
END;