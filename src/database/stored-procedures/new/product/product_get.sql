DROP PROCEDURE IF EXISTS product_get_id;
CREATE PROCEDURE product_get_id(
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

    SELECT p.id                          AS productId,
           p.name                        AS productName,
           p.description                 AS description,
           p.warehouseId                 AS warehouseId,
           p.productReference            AS sku,
           (SELECT JSON_OBJECT(
                           'warehouseId', tw.id,
                           'warehouseCode', tw.warehouseCode,
                           'warehouseName', tw.warehouseName,
                           'warehouseAddress', tw.warehouseAddress,
                           'contactNo', tw.contactNo,
                           'contactPersonName', tw.contactPersonName
                   )
            FROM tbl_warehouse tw
            WHERE tw.id = p.warehouseId) AS warehouseDetails,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'variantId', pv.id,
                                   'sku', pv.variantReference,
                                   'weight', pv.weight,
                                   'unit', pv.unit,
                                   'basePrice', ROUND(pv.basePrice, 2),
                                   'cost', ROUND(pv.cost, 2),
                                   'stockId', vs.id,
                                   'availableQTY', COALESCE(vs.availableQty, 0)
                           )
                   )
            FROM tbl_product_variant pv
                     LEFT JOIN tbl_variant_stock vs ON vs.variantId = pv.id AND vs.status = 'active'
            WHERE pv.productId = p.id)   AS variants
    FROM tbl_product p
    WHERE p.id = product_id;
    COMMIT;
    COMMIT;
END;
