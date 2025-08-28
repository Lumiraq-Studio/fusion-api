DROP PROCEDURE IF EXISTS price_for_route;
CREATE PROCEDURE price_for_route(
    IN route_id INT
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

    SELECT r.name AS routeName,
           JSON_ARRAYAGG(
                   JSON_OBJECT(
                           'shopId', s.id,
                           'shopName', s.fullName,
                           'shopCode', s.shopCode,
                           'products', (SELECT JSON_ARRAYAGG(
                                                       JSON_OBJECT(
                                                               'product', p.name,
                                                               'productId', p.id,
                                                               'variants', (SELECT JSON_ARRAYAGG(
                                                                                           JSON_OBJECT(
                                                                                                   'variantId', pv.id,
                                                                                                   'variant',
                                                                                                   CONCAT(pv.weight, '', pv.unit),
                                                                                                   'price',
                                                                                                   COALESCE(sp.price, pv.basePrice)
                                                                                           )
                                                                                   )
                                                                            FROM tbl_product_variant pv
                                                                                     LEFT JOIN tbl_shop_price sp
                                                                                               ON sp.variantId = pv.id AND sp.shopId = s.id AND sp.status = 'active'
                                                                            WHERE pv.productId = p.id)
                                                       )
                                               )
                                        FROM tbl_product p)
                   )
           )      AS variantPrices
    FROM tbl_route r
             INNER JOIN tbl_shop s ON s.routeId = r.id AND s.status = 'active'
    WHERE r.id = route_id
    GROUP BY r.id, r.name;
    COMMIT;
END;
