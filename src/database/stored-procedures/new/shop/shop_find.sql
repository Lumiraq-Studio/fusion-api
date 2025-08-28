DROP PROCEDURE IF EXISTS shop_find;
CREATE PROCEDURE shop_find(
    IN shop_code VARCHAR(255),
    IN full_name VARCHAR(255),
    IN type_id INT,
    IN route_id INT,
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE shop_code_cond VARCHAR(255) DEFAULT '';
    DECLARE full_name_cond VARCHAR(255) DEFAULT '';
    DECLARE route_id_cond VARCHAR(255) DEFAULT '';
    DECLARE type_id_cond VARCHAR(255) DEFAULT '';
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
        shopCode  VARCHAR(255),
        fullName  VARCHAR(255),
        shortName VARCHAR(255),
        status    VARCHAR(255),
        contact   VARCHAR(255),
        routeName VARCHAR(255),
        shopType  VARCHAR(255)
    );

    IF shop_code <> '' THEN
        SET shop_code_cond = CONCAT(' AND s.shopCode LIKE "%', shop_code, '%"');
    END IF;

    IF full_name <> '' THEN
        SET full_name_cond =
                CONCAT(' AND (s.shortName LIKE "%', full_name, '%" OR s.fullName LIKE "%', full_name, '%")');
    END IF;

    IF route_id IS NOT NULL AND route_id > 0 THEN
        SET route_id_cond = CONCAT(' AND s.routeId = ', route_id);  -- changed condition
    END IF;

    IF type_id IS NOT NULL AND type_id > 0 THEN
        SET type_id_cond = CONCAT(' AND s.shopTypeId = ', type_id);
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_shop s
             LEFT JOIN tbl_route r ON s.routeId = r.id
             LEFT JOIN tbl_shop_type t ON s.shopTypeId = t.id
             WHERE s.id > 0', shop_code_cond, full_name_cond, route_id_cond, type_id_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, shopCode, fullName, shortName, status, contact, routeName, shopType)
             SELECT s.id, s.shopCode, s.fullName, s.shortName, s.status, s.mobile, r.name AS routeName, t.name AS shopType
             FROM tbl_shop s
             LEFT JOIN tbl_route r ON s.routeId = r.id
             LEFT JOIN tbl_shop_type t ON s.shopTypeId = t.id
             WHERE s.id > 0', shop_code_cond, full_name_cond, route_id_cond, type_id_cond, limit_cond, ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number                         AS page,
           items_per_page                      AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'id', td.id,
                                   'cRef', td.shopCode,
                                   'fullName', td.fullName,
                                   'status', td.status,
                                   'contact', td.contact,
                                   'shortName', td.shortName,
                                   'routeName', td.routeName,
                                   'shopType', td.shopType
                           )
                   )
            FROM tmp_data td)                  AS data;

    COMMIT;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
