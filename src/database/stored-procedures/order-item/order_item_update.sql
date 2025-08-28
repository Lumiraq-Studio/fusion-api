DROP PROCEDURE IF EXISTS order_item_update;
CREATE PROCEDURE order_item_update(
    IN order_item_id INT,
    IN price_val INT,
    IN quantity_val INT,
    IN updated_by INT
)
BEGIN

    DECLARE original_price INT;
    DECLARE original_quantity INT;
    DECLARE total_price INT;
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

    SELECT COUNT(*) INTO @record_count FROM tbl_order_item toi WHERE toi.id = order_item_id;

    IF @record_count > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Multiple records found (OrderItem). Please contact system administrator.';
    ELSEIF @record_count < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Records not found (OrderItem). Please contact system administrator.';
    END IF;

    SELECT price, quantity
    INTO original_price, original_quantity
    FROM tbl_order_item
    WHERE id = order_item_id;

    IF price_val <> original_price OR quantity_val <> original_quantity THEN
        SET total_price = price_val * quantity_val;

        UPDATE tbl_order_item
        SET quantity   = quantity_val,
            price      = price_val,
            totalPrice = total_price,
            updatedBy  = updated_by,
            updatedAt  = DATE_FORMAT(NOW(), '%Y-%m-%d')
        WHERE id = order_item_id;
    END IF;

    SELECT order_item_id AS updated_order_item_id;
    COMMIT;
END;
