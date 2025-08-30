DROP PROCEDURE IF EXISTS order_item_update;
CREATE PROCEDURE order_item_update(
    IN order_item_id INT,
    IN order_id INT,
    IN product_id INT,
    IN quantity_val INT,
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

    UPDATE tbl_order_item
    SET orderId   = order_id,
        productId = product_id,
        quantity  = quantity_val,
        updatedBy = updated_by,
        updatedAt = NOW()
    WHERE id = order_item_id;

    SELECT order_item_id AS updated_order_item_id;
    COMMIT;
END;
