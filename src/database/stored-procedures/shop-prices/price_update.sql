DROP PROCEDURE IF EXISTS shop_product_price_update;
CREATE PROCEDURE shop_product_price_update(
    IN price_id INT,
    IN shop_id INT,
    IN variant_id INT,
    IN is_global TINYINT,
    IN updated_by INT,
    IN status_val VARCHAR(50)
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

    UPDATE tbl_shop_price
    SET shopId          =shop_id,
        variantId=variant_id,
        updatedBy=updated_by,
        isGlobal=is_global,
        status=status_val,
        updatedAt=DATE_FORMAT(NOW(), '%Y-%m-%d')

    WHERE id = price_id;

    SELECT price_id AS updated_price_id;
    COMMIT;

END;
