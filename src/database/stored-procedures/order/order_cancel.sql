DROP PROCEDURE IF EXISTS order_cancel;
CREATE PROCEDURE order_cancel(
    IN order_id INT,
    IN cancelled_by varchar(255))
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @sqlstate = RETURNED_SQLSTATE,
                @errno = MYSQL_ERRNO,
                @message_text = MESSAGE_TEXT;
            ROLLBACK;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;


    START TRANSACTION;


    UPDATE tbl_order
    SET orderStatus = 'cancel',
        updatedBy   = cancelled_by,
        updatedAt   = DATE_FORMAT(NOW(), '%Y-%m-%d')
    WHERE id = order_id;

    UPDATE tbl_rep_stock rs
        JOIN tbl_order_item oi ON rs.id = oi.salesRepStockId
    SET rs.remainingQty = rs.remainingQty + oi.quantity,
        rs.soldQty      = rs.soldQty - oi.quantity
    WHERE oi.orderId = order_id;


    #     Row wise qty updated with new method

#     OPEN cur;
#     read_loop: LOOP
#         FETCH cur INTO item_id, item_quantity, sales_rep_stock_id;
#         IF done THEN
#             LEAVE read_loop;
#         END IF;
#         UPDATE tbl_rep_stock
#         SET remainingQty = remainingQty + item_quantity,
#             soldQty = soldQty - item_quantity
#         WHERE id = sales_rep_stock_id;
#     END LOOP;
#
#
#     CLOSE cur;

    COMMIT;

    SELECT order_id AS CanceldOrderId;
END;
