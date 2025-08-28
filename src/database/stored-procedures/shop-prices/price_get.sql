DROP PROCEDURE IF EXISTS price_get_id;
CREATE PROCEDURE price_get_id(
    IN price_id INT
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
    SELECT sp.id                                 AS priceId,
           sp.price                              AS variantPrice,
           sp.status                             AS priceStatus,
           DATE_FORMAT(sp.createdAt, '%Y-%m-%d') AS priceCreatedAt,
           DATE_FORMAT(sp.updatedAt, '%Y-%m-%d') AS priceUpdatedAt,
           sp.createdBy                          AS priceCreatedBy,
           sp.updatedBy                          AS priceUpdatedBy,
           s.id                                  AS shopId,
           s.shopCode                            AS shopCode,
           s.fullName                            AS shopName,
           s.status                              AS shopStatus,
           pv.id                                 AS productVariantId,
           pv.weight                             AS variantWeight,
           pv.unit                               AS variantUnit,
           pv.cost                               AS variantCost,
           pv.basePrice                          AS variantBasePrice,
           p.id                                  AS productId,
           p.name                                AS productName,
           p.description                         AS productDescription,
           p.warehouseId                         AS productWarehouseId
    FROM tbl_shop_price sp
             LEFT JOIN tbl_shop s ON sp.shopId = s.id
             LEFT JOIN tbl_product_variant pv ON sp.variantId = pv.id
             LEFT JOIN tbl_product p ON pv.productId = p.id
    WHERE sp.id = price_id;

END;

