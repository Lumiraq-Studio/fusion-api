DROP PROCEDURE IF EXISTS order_save;
CREATE PROCEDURE order_save(
    IN order_date VARCHAR(100),
    IN order_status VARCHAR(50),
    IN note_val VARCHAR(255),
    IN uu_id VARCHAR(255),
    IN created_at VARCHAR(255),
    IN shop_id INT,
    IN paid_val INT,
    IN sales_rep_id INT,
    IN payment_type_id INT,
    IN created_by VARCHAR(100),
    IN order_type VARCHAR(100),
    IN orderItems JSON
)
BEGIN

    DECLARE i INT DEFAULT 0;

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

    IF sales_rep_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM tbl_sales_rep WHERE id = sales_rep_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sales Rep ID does not exist.';
    END IF;

    SELECT orderReference
    INTO @LAST_REFERENCE
    FROM tbl_order
    ORDER BY orderReference DESC
    LIMIT 1;

    SET @current_time = CONVERT_TZ(NOW(), '+00:00', '+05:30');

    SET @PREFIX = CONCAT('NO', DATE_FORMAT(NOW(), '%Y%m/'));

    IF @LAST_REFERENCE IS NULL THEN
        SET @order_ref = CONCAT(@PREFIX, '000001');
    ELSE

        SET @LAST_INDEX = CAST(SUBSTRING_INDEX(@LAST_REFERENCE, '/', -1) AS UNSIGNED);

        SET @order_ref = CONCAT(@PREFIX, LPAD(@LAST_INDEX + 1, 6, '0'));
    END IF;


    INSERT INTO tbl_order (orderDate,
                           orderType,
                           uuId,
                           orderReference,
                           orderStatus,
                           shopId,
                           paid,
                           salesRepId,
                           createdBy,
                           createdAt,
                           paymentTypeId, note, createdTime)
    VALUES (order_date,
            order_type,
            uu_id,
            @order_ref,
            order_status,
            shop_id,
            paid_val,
            sales_rep_id,
            created_by,
            NOW(),
            payment_type_id,
            note_val
               , created_at);

    SET @OrderId = LAST_INSERT_ID();
    SET @order_item_count = JSON_LENGTH(orderItems);

    WHILE i < @order_item_count
        DO
            SET @item_quantity = JSON_UNQUOTE(JSON_EXTRACT(orderItems, CONCAT('$[', i, '].quantity')));
            SET @item_variant_id = JSON_UNQUOTE(JSON_EXTRACT(orderItems, CONCAT('$[', i, '].variantId')));
            SET @item_rep_stock_id = JSON_UNQUOTE(JSON_EXTRACT(orderItems, CONCAT('$[', i, '].stockBreakdownId')));
            SET @item_price = JSON_UNQUOTE(JSON_EXTRACT(orderItems, CONCAT('$[', i, '].price')));


            UPDATE tbl_rep_stock_breakdowns
            SET remainingQty =remainingQty - @item_quantity,
                soldQty      = soldQty + @item_quantity
            WHERE id = @item_rep_stock_id;

            INSERT INTO tbl_order_item (quantity, orderId, status, price, totalPrice, variantId, createdAt,
                                        createdBy,
                                        repStockId)
            VALUES (@item_quantity, @OrderId, 'active', @item_price, (@item_quantity * @item_price),
                    @item_variant_id,
                    DATE_FORMAT(NOW(), '%Y-%m-%d'), created_by, @item_rep_stock_id);

            SELECT remainingQty, salesRepStockId
            INTO @assignQty, @repStockId
            FROM tbl_rep_stock_breakdowns
            WHERE id = @item_rep_stock_id
            LIMIT 1;

            IF @assignQty = 0 THEN
                UPDATE tbl_rep_stock_breakdowns
                SET status       = 'inactive',
                    remainingQty = 0
                WHERE id = @item_rep_stock_id;
            END IF;

            SELECT COUNT(*)
            INTO @hasRemainingQty
            FROM tbl_rep_stock_breakdowns
            WHERE salesRepStockId = @repStockId
              AND remainingQty > 0;

            IF @hasRemainingQty = 0 THEN
                UPDATE tbl_rep_stock
                SET status = 'inactive'
                WHERE id = @repStockId;
            END IF;


            SET i = i + 1;
        END WHILE;


    SELECT SUM(toi.totalPrice) INTO @orderAmount from tbl_order_item toi where toi.orderId = @OrderId;

    IF paid_val >= @orderAmount THEN
        UPDATE tbl_order
        SET orderStatus ='completed'
        WHERE id = @OrderId;
    END IF;

    SELECT @OrderId AS inserted_order_id;
    COMMIT;
END;