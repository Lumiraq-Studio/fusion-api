DROP PROCEDURE IF EXISTS order_item_save;
CREATE PROCEDURE order_item_save(
    IN order_id INT,
    IN variant_id INT,
    IN price_val INT,
    IN quantity_val INT,
    IN created_by VARCHAR(255)
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

    INSERT INTO tbl_order_item (orderId, price, variantId, totalPrice, quantity, createdBy, createdAt)
    VALUES (order_id, price_val, variant_id, (quantity_val * price_val), quantity_val, created_by,
            DATE_FORMAT(NOW(), '%Y-%m-%d'));

    SET @InsertedOrderItemID = LAST_INSERT_ID();
    SELECT @InsertedOrderItemID AS inserted_order_item_id;
    COMMIT;
END;
