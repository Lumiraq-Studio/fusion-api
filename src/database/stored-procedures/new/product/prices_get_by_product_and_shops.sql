DROP PROCEDURE IF EXISTS price_get_by_shop_id;
CREATE PROCEDURE price_get_by_shop_id(
    IN shop_id INT,
    IN rep_id INT
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

    WITH distinct_products AS (
        SELECT
            tp.name AS productName,
            tp.id AS productId,
            tpv.weight,
            tpv.variantReference AS sku,
            tpv.unit,
            tsp.variantId,
            tsp.shopId,
            tsp.price,
            tsp.status,
            ROUND(tpv.cost, 2) AS cost,
            SUM(COALESCE(trs.remainingQty, 0)) AS qty,
            IF(tsp.isGlobal = 1, true, false) AS forAll
        FROM
            tbl_shop_price tsp
                JOIN tbl_product_variant tpv ON tpv.id = tsp.variantId
                JOIN tbl_product tp ON tp.id = tpv.productId
                LEFT JOIN tbl_variant_stock tvs ON tpv.id = tvs.variantId
                LEFT JOIN tbl_rep_stock trs ON trs.productVariantId = tpv.id
        WHERE
            tsp.status = 'active'
          AND (
            tsp.shopId = shop_id
                OR (tsp.isGlobal = 1 AND NOT EXISTS (
                SELECT 1
                FROM tbl_shop_price tsp2
                WHERE tsp2.variantId = tsp.variantId
                  AND tsp2.shopId = shop_id
            ))
            )
          AND trs.salesRepId = rep_id
        GROUP BY
            tp.name, tp.id, tpv.weight, tpv.variantReference, tpv.unit,
            tsp.variantId, tsp.shopId, tsp.price, tsp.status, tpv.cost, tsp.isGlobal
    )
    SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'productName', productName,
                           'productId', productId,
                           'weight', weight,
                           'sku', sku,
                           'unit', unit,
                           'variantId', variantId,
                           'shopId', shopId,
                           'price', price,
                           'status', status,
                           'cost', cost,
                           'qty', qty,
                           'forAll', forAll
                   )
           ) AS data
    FROM distinct_products
    ORDER BY IF(shopId = shop_id, 1, 2);

    COMMIT;
END;
