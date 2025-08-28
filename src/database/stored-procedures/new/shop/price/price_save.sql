DROP PROCEDURE IF EXISTS shop_product_price_save;
CREATE PROCEDURE shop_product_price_save(
    IN price_val JSON
)
BEGIN
    DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE oldId INT DEFAULT 0;
    DECLARE _shop_id INT;
    DECLARE _variant_id INT;
    DECLARE _price_val DECIMAL(10, 2);
    DECLARE _created_by VARCHAR(100);
    DECLARE _PriceCount INT;

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

    SET n = JSON_LENGTH(price_val);

    WHILE i < n DO
            SET _shop_id = JSON_UNQUOTE(JSON_EXTRACT(price_val, CONCAT('$[', i, '].shopId')));
            SET _variant_id = JSON_UNQUOTE(JSON_EXTRACT(price_val, CONCAT('$[', i, '].variantId')));
            SET _price_val = JSON_UNQUOTE(JSON_EXTRACT(price_val, CONCAT('$[', i, '].priceValue')));
            SET _created_by = JSON_UNQUOTE(JSON_EXTRACT(price_val, CONCAT('$[', i, '].createdBy')));

            SELECT COUNT(*) INTO _PriceCount
            FROM tbl_shop_price
            WHERE shopId = _shop_id
              AND variantId = _variant_id
              AND status = 'active';

            IF _PriceCount > 0 THEN
                SELECT id INTO oldId
                FROM tbl_shop_price
                WHERE shopId = _shop_id
                  AND variantId = _variant_id
                  AND status = 'active'
                LIMIT 1;

                UPDATE tbl_shop_price
                SET status = 'inactive',
                    updatedBy = _created_by,
                    updatedAt = NOW()
                WHERE id = oldId;
            END IF;

            INSERT INTO tbl_shop_price (shopId, variantId, status, price, createdAt, createdBy)
            VALUES (_shop_id, _variant_id, 'active', _price_val, NOW(), _created_by);

            SET i = i + 1;
        END WHILE;

    SELECT n AS NumberOfPrices;
    COMMIT;
END;
