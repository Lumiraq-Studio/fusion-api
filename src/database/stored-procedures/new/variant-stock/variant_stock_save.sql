DROP PROCEDURE IF EXISTS variant_stock_save;
CREATE PROCEDURE variant_stock_save(
    IN stock_id INT,
    IN stock_qty_val INT,
    IN created_by VARCHAR(255),
    IN variant_id INT,
    IN warehouse_id_val INT
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

    SELECT pv.variantReference, pv.basePrice
    INTO @variant_ref, @base_price
    FROM tbl_product_variant pv
    WHERE pv.id = variant_id;

    IF stock_id > 0 THEN

#         INSERT INTO tbl_stock_history (addedDate, stockQty, basePrice, availableQty, returnQty, disposeQty, createdAt,
#                                        variantStockId)
#         SELECT DATE_FORMAT(NOW(), '%Y-%m-%d'),
#                stockQty,
#                basePrice,
#                availableQty,
#                returnQty,
#                disposeQty,
#                NOW(),
#                stock_id
#         FROM tbl_variant_stock
#         WHERE id = stock_id;

        UPDATE tbl_variant_stock
        SET stockQty     = stockQty + stock_qty_val,
            availableQty = availableQty + stock_qty_val,
            updatedAt    = NOW()
        WHERE variantId = variant_id
          AND id = stock_id;

        SELECT stock_id AS updatedStockId;
    ELSE

        INSERT INTO tbl_variant_stock (variantRef, status, stockQty, basePrice, availableQty,
                                       createdBy, createdAt, variantId, warehouseId)
        VALUES (@variant_ref, 'active', stock_qty_val, @base_price, stock_qty_val, created_by, NOW(), variant_id,
                warehouse_id_val);

        SET @InsertedShopID = LAST_INSERT_ID();
        SELECT @InsertedShopID AS variant_stock_id;
    END IF;
    COMMIT;
END;
