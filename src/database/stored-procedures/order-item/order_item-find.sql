DROP PROCEDURE IF EXISTS order_item_find;
CREATE PROCEDURE order_item_find(
    IN product_name VARCHAR(255),
    IN order_reference VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE product_name_cond VARCHAR(255) DEFAULT '';
    DECLARE order_reference_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        orderItemId    INT,
        orderReference VARCHAR(255),
        productName    VARCHAR(255),
        quantity       INT
    );


    IF product_name <> '' THEN
        SET product_name_cond = CONCAT(' AND p.name LIKE "%', product_name, '%"');
    END IF;

    IF order_reference <> '' THEN
        SET order_reference_cond = CONCAT(' AND o.orderReference LIKE "%', order_reference, '%"');
    END IF;


    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;


    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_order_item oi
             INNER JOIN tbl_product p ON oi.productId = p.id
             INNER JOIN tbl_order o ON oi.orderId = o.id
             WHERE oi.id > 0',
            product_name_cond, order_reference_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;


    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (orderItemId, orderReference, productName, quantity)
             SELECT oi.id AS orderItemId, o.orderReference, p.name AS productName, oi.quantity
             FROM tbl_order_item oi
             INNER JOIN tbl_product p ON oi.productId = p.id
             INNER JOIN tbl_order o ON oi.orderId = o.id
             WHERE oi.id > 0',
            product_name_cond, order_reference_cond, limit_cond, ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number                         AS page,
           items_per_page                      AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'orderItemId', td.orderItemId,
                                   'orderReference', td.orderReference,
                                   'productName', td.productName,
                                   'quantity', td.quantity
                           )
                   )
            FROM tmp_data td)                  AS data;


    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
