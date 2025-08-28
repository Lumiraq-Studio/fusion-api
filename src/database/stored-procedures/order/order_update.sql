DROP PROCEDURE IF EXISTS order_update;
CREATE PROCEDURE order_update(
    IN order_id INT,
    IN paid_val INT,
    IN updated_by VARCHAR(255)
)
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
    SET paid      = paid + paid_val,
        updatedBy = updated_by,
        updatedAt = DATE_FORMAT(NOW(), '%Y-%m-%d')
    WHERE id = order_id;

    SELECT SUM(toi.totalPrice) INTO @orderAmount from tbl_order_item toi where toi.orderId = order_id;
    SELECT so.paid INTO @paidAmount from tbl_order so where so.id = order_id;

    IF @paidAmount >= @orderAmount THEN
        UPDATE tbl_order
        SET orderStatus ='completed'
        WHERE id = order_id;
    END IF;
    SELECT order_id AS updated_order_id;

    COMMIT;
END;
