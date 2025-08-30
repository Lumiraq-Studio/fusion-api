DROP PROCEDURE IF EXISTS payment_type_find;
CREATE PROCEDURE payment_type_find(
    IN type_val VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE type_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count` (total_count INT);

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data` (
                                          id INT,
                                          type VARCHAR(255),
                                          description VARCHAR(255)
    );


    IF type_val <> '' THEN
        SET type_cond = CONCAT(' AND type LIKE "%', type_val, '%"');
    END IF;


    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;


    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_payment_type
             WHERE id > 0', type_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;


    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, type, description)
             SELECT id, type, description
             FROM tbl_payment_type
             WHERE id > 0', type_cond, limit_cond, ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number AS page,
           items_per_page AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'id', td.id,
                                   'type', td.type,
                                   'description', td.description
                           )
                   ) FROM tmp_data td) AS data;
    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
