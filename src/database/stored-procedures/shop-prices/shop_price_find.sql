DROP PROCEDURE IF EXISTS shop_price_find;
CREATE PROCEDURE shop_price_find(
    IN status VARCHAR(50),
    IN product_name VARCHAR(255),
    IN shop_name VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE price_cond VARCHAR(255) DEFAULT '';
    DECLARE status_cond VARCHAR(255) DEFAULT '';
    DECLARE product_cond VARCHAR(255) DEFAULT '';
    DECLARE shop_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS tmp_count;
    CREATE TEMPORARY TABLE tmp_count (total_count INT);

    DROP TEMPORARY TABLE IF EXISTS tmp_data;
    CREATE TEMPORARY TABLE tmp_data (
                                        id INT,
                                        price DECIMAL(10, 2),
                                        status VARCHAR(50),
                                        product_name VARCHAR(255),
                                        shop_name VARCHAR(255)
    );



    IF status <> '' THEN
        SET status_cond = CONCAT(' AND sp.status = "', status, '"');
    END IF;

    IF product_name <> '' THEN
        SET product_cond = CONCAT(' AND p.name LIKE "%', product_name, '%"');
    END IF;

    IF shop_name <> '' THEN
        SET shop_cond = CONCAT(' AND s.fullName LIKE "%', shop_name, '%"');
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_shop_price sp
              JOIN tbl_product_variant pv ON sp.variantId = pv.id
              JOIN tbl_product p ON pv.productId = p.id
              JOIN tbl_shop s ON sp.shopId = s.id
             WHERE sp.id > 0', price_cond, status_cond, product_cond, shop_cond
                      );

    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, price, status, product_name, shop_name)
             SELECT sp.id, sp.price, sp.status, p.name, s.fullName
             FROM tbl_shop_price sp
             LEFT JOIN tbl_product_variant pv ON sp.variantId = pv.id
             LEFT JOIN tbl_product p ON pv.productId = p.id
             LEFT JOIN tbl_shop s ON sp.shopId = s.id
             WHERE sp.id > 0', price_cond, status_cond, product_cond, shop_cond, limit_cond
                       );

    PREPARE stmt2 FROM @final_query;

    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;


    SELECT
        page_number AS page,
        items_per_page AS itemsPerPage,
        (SELECT total_count FROM tmp_count) AS totalItems,
        (SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                                'id', td.id,
                                'price', td.price,
                                'status', td.status,
                                'product_name', td.product_name,
                                'shop_name', td.shop_name
                        )
                ) FROM tmp_data td) AS data;

    DROP TEMPORARY TABLE IF EXISTS tmp_count;
    DROP TEMPORARY TABLE IF EXISTS tmp_data;
END;
