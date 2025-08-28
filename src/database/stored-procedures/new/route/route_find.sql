DROP PROCEDURE IF EXISTS route_find;
CREATE PROCEDURE route_find(
    IN route_name VARCHAR(255),
    IN area_name VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE name_cond VARCHAR(255) DEFAULT '';
    DECLARE area_cond VARCHAR(255) DEFAULT '';
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
        area      VARCHAR(255),
        shopCount INT
    );


    IF route_name <> '' THEN
        SET name_cond = CONCAT(' AND r.name LIKE ', QUOTE(CONCAT('%', route_name, '%')));
    END IF;
    IF area_name <> '' THEN
        SET area_cond = CONCAT(' AND r.area LIKE ', QUOTE(CONCAT('%', area_name, '%')));
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_route r
             WHERE r.id > 0', name_cond, area_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, name, area, shopCount)
             SELECT r.id, r.name, r.area, COUNT(s.id) AS shopCount
             FROM tbl_route r
             LEFT JOIN tbl_shop s ON r.id = s.routeId
             WHERE r.id > 0', name_cond, area_cond,
            ' GROUP BY r.id, r.name, r.area', limit_cond, ';'
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
                                   'name', td.name,
                                   'area', td.area,
                                   'shopCount', td.shopCount
                           )
                   )
            FROM tmp_data td)                  AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
