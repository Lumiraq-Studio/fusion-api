DROP PROCEDURE IF EXISTS variant_stock_get_by_product;
CREATE PROCEDURE variant_stock_get_by_product(
    IN product_id INT
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

    SELECT v.id         AS variantId,
           v.availableQty,
           v.disposeQty,
           v.returnQty,
           v.availableQty,
           v.basePrice,
           v.stockQty,
           v.status,
           v.variantRef AS sku,
           pv.weight,
           pv.unit
    FROM tbl_variant_stock v
             JOIN tbl_product_variant pv ON v.variantId = pv.id
             JOIN tbl_product p ON pv.productId = p.id
    WHERE p.id = product_id
      ANd v.status = 'active';
    COMMIT;
END;
