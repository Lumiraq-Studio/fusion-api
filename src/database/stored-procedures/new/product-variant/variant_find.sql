DROP PROCEDURE IF EXISTS product__variant_find;
CREATE PROCEDURE product__variant_find(
    IN search_term VARCHAR(255),
    IN weight_val INT,
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE name_cond VARCHAR(255) DEFAULT '';
    DECLARE weight_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        id        INT,
        name      VARCHAR(255),
        sku       VARCHAR(255),
        basePrice VARCHAR(255),
        weight    INT,
        unit      VARCHAR(255)
    );

    IF search_term <> '' THEN
        SET name_cond = CONCAT(' AND (p.name LIKE "%', search_term, '%" OR p.productReference LIKE "%', search_term, '%")');
    END IF;


    IF weight_val > 0 THEN
        SET weight_cond = CONCAT(' AND pv.weight = ', weight_val);
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
            SELECT COUNT(DISTINCT p.id)
             FROM tbl_product p
             JOIN tbl_product_variant pv ON p.id = pv.productId
             WHERE p.id > 0', name_cond, weight_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

#     LEFT JOIN tbl_product_stock ps ON pv.id = ps.productVariantId
    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, name, sku, basePrice, weight, unit)
             SELECT p.id, p.name, pv.variantReference, pv.basePrice, pv.weight, pv.unit
             FROM tbl_product p
             LEFT JOIN tbl_product_variant pv ON p.id = pv.productId

             WHERE p.id > 0',
            name_cond,
            weight_cond,
            ' GROUP BY p.id, pv.variantReference, pv.basePrice, pv.weight, pv.unit',
            limit_cond,
            ';'
                       );


    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    CREATE TEMPORARY TABLE tmp_distinct_products AS
    SELECT DISTINCT id, name, sku FROM tmp_data;

    SELECT page_number                         AS page,
           items_per_page                      AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'id', dp.id,
                                   'name', dp.name,
                                   'variants', (
                                       SELECT JSON_ARRAYAGG(
                                                      JSON_OBJECT(
                                                              'sku', dp.sku,
                                                              'unit', td.unit,
                                                              'weight', td.weight,
                                                              'basePrice', td.basePrice
                                                      )
                                              )
                                       FROM tmp_data td
                                       WHERE td.id = dp.id
                                   )
                           )
                   )
            FROM tmp_distinct_products dp) AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_distinct_products`;

#     SELECT page_number                         AS page,
#            items_per_page                      AS itemsPerPage,
#            (SELECT total_count FROM tmp_count) AS totalItems,
#            (SELECT JSON_ARRAYAGG(
#                            JSON_OBJECT(
#                                    'id', td.id,
#                                    'name', td.name,
#                                    'sku', td.sku,
#                                    'basePrice', td.basePrice,
#                                    'weight', td.weight,
#                                    'unit', td.unit
#                            )
#                    )
#             FROM tmp_data td)                  AS data;

#     DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
#     DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
