DROP PROCEDURE IF EXISTS price_get_by_product_id;
CREATE PROCEDURE price_get_by_product_id(
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
    SELECT JSON_OBJECT(
                   'productId', p.id,
                   'productName', p.name,
                   'productDescription', p.description,
                   'variants', (
                       SELECT JSON_ARRAYAGG(
                                      JSON_OBJECT(
                                              'variantId', pv.id,
                                              'weight', pv.weight,
                                              'unit', pv.unit,
                                              'cost', pv.cost,
                                              'basePrice', pv.basePrice,
                                              'shopPrices', (
                                                  SELECT JSON_ARRAYAGG(
                                                                 JSON_OBJECT(
                                                                         'shopPriceId', sp.id,
                                                                         'price', sp.price,
                                                                         'status', sp.status,
                                                                         'shopId', s.id,
                                                                         'shopCode', s.shopCode,
                                                                         'shopName', s.fullName,
                                                                         'isGlobal', sp.isGlobal
                                                                 )
                                                         )
                                                  FROM tbl_shop_price sp
                                                           LEFT JOIN tbl_shop s ON sp.shopId = s.id
                                                  WHERE sp.variantId = pv.id
                                              )
                                      )
                              )
                       FROM tbl_product_variant pv
                       WHERE pv.productId = p.id
                   )
           ) AS productDetails
    FROM tbl_product p
    WHERE p.id = product_id;


END;

