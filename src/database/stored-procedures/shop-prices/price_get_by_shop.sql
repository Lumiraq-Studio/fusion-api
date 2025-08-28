DROP PROCEDURE IF EXISTS price_get_by_shop_id;
CREATE PROCEDURE price_get_by_shop_id(IN shop_id int)
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

    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'productName', tp.name,
                           'productId', tp.id,
                           'weight', tpv.weight,
                           'sku', tpv.variantReference,
                           'unit', tpv.unit,
                           'variantId', tsp.variantId,
                           'shopId', tsp.shopId,
                           'price', tsp.price,
                           'status', tsp.status,
                           'cost', ROUND(tpv.cost, 2),
                           'qty', COALESCE( tvs.availableQty, 0),
                           'forAll', IF(tsp.isGlobal = 1, true, false)
                   )
           ) AS data
    FROM tbl_shop_price tsp
             JOIN tbl_product_variant tpv ON tpv.id = tsp.variantId
             JOIN tbl_product tp ON tp.id = tpv.productId
             LEFT JOIN tbl_variant_stock tvs ON tpv.id = tvs.variantId
    WHERE tsp.status = 'active'
      AND (
        tsp.shopId = shop_id
            OR (tsp.isGlobal = 1 AND NOT EXISTS (SELECT 1
                                                 FROM tbl_shop_price tsp2
                                                 WHERE tsp2.variantId = tsp.variantId
                                                   AND tsp2.shopId = shop_id))
        )
    ORDER BY IF(tsp.shopId = shop_id, 1, 2);
    COMMIT;
END;

