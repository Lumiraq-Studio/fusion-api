DROP PROCEDURE IF EXISTS variant_save;
CREATE PROCEDURE variant_save(
    IN variant_val JSON
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

    SET @variant_count = JSON_LENGTH(variant_val);
    WHILE i < @variant_count
        DO
            SET @item_weight = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].weight')));
            SET @item_base_price = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].basePrice')));
            SET @item_cost = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].cost')));
            SET @item_product_id = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].productId')));
            SET @item_product_name = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].productName')));
            SET @item_created_by = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].createdBy')));
            SET @item_unit = JSON_UNQUOTE(JSON_EXTRACT(variant_val, CONCAT('$[', i, '].unit')));


            SELECT variantReference
            INTO @last_reference
            FROM tbl_product_variant
            ORDER BY id DESC
            LIMIT 1;

            SET @product_prefix = UPPER(LEFT(@item_product_name, 2));


            IF @last_reference IS NULL THEN
                SET @variant_reference = CONCAT('NVD-', @product_prefix, '-', @item_weight);
            ELSE

                SET @variant_reference = CONCAT('NVD-', @product_prefix, '-', @item_weight);
            END IF;


            INSERT INTO tbl_product_variant (weight, variantReference, basePrice, cost, createdby, createdat, productid,
                                             unit)
            VALUES (@item_weight, @variant_reference, @item_base_price, @item_cost, @item_created_by, NOW(),
                    @item_product_id, @item_unit);

            SET @InsertedProductID = LAST_INSERT_ID();
            SELECT @InsertedProductID AS inserted_product_variant_id;

            SET i = i + 1;
        END WHILE;
    COMMIT;

END
