DROP PROCEDURE IF EXISTS order_item_save;
CREATE PROCEDURE order_item_save(
    IN order_id INT,
    IN product_id INT,
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

    INSERT INTO tbl_order_item (orderId, productId, quantity, createdBy, createdAt)
    VALUES (order_id, product_id, quantity_val, created_by, NOW());

    SET @InsertedOrderItemID = LAST_INSERT_ID();
    SELECT @InsertedOrderItemID AS inserted_order_item_id;

    COMMIT;
END;
