DROP PROCEDURE IF EXISTS material_find;
CREATE PROCEDURE material_find(
    IN material_name VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE name_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';
    DECLARE _offset INT DEFAULT 0;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        id           INT,
        name         VARCHAR(255),
        unitCost     DECIMAL(10, 2),
        quantity     INT,
        availableQty INT
    );

    -- Condition for material name
    IF material_name <> '' THEN
        SET name_cond = CONCAT(' AND m.name LIKE ', QUOTE(CONCAT('%', material_name, '%')));
    END IF;


    IF items_per_page > 0 AND page_number > 0 THEN
        SET _offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', _offset, ', ', items_per_page);
    END IF;

    -- Total count query
    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_material m
             WHERE m.id > 0', name_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;


    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, name, unitCost, quantity, availableQty)
             SELECT m.id, m.name, m.unitCost, m.quantity, m.availableQty
             FROM tbl_material m
             WHERE m.id > 0', name_cond, limit_cond, ';'
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
                                   'unitCost', td.unitCost,
                                   'quantity', td.quantity,
                                   'availableQty', td.availableQty
                           )
                   )
            FROM tmp_data td)                  AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END