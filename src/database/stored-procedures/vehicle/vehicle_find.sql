DROP PROCEDURE IF EXISTS vehicle_find;
CREATE PROCEDURE vehicle_find(
    IN registration_no VARCHAR(255),
    IN type_val VARCHAR(255),
    IN capacity_val INT,
    IN items_per_page INT,
    IN page_number INT
)
BEGIN

    DECLARE registrationNo_cond VARCHAR(255) DEFAULT '';
    DECLARE type_cond VARCHAR(255) DEFAULT '';
    DECLARE capacity_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data` (
                                          id INT,
                                          registrationNo VARCHAR(255),
                                          type VARCHAR(255),
                                          capacity INT,
                                          salesRepId INT
    );


    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count` (
                                           total_count INT
    );

    IF registration_no IS NOT NULL AND registration_no <> '' THEN
        SET registrationNo_cond = CONCAT(' AND tv.registrationNo LIKE "', registration_no, '%"');
    END IF;

    IF type_val IS NOT NULL AND type_val <> '' THEN
        SET type_cond = CONCAT(' AND tv.type LIKE "', type_val, '%"');
    END IF;

    IF capacity_val IS NOT NULL AND capacity_val > 0 THEN
        SET capacity_cond = CONCAT(' AND tv.capacity = ', capacity_val);
    END IF;



    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;


    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count) SELECT COUNT(*) FROM tbl_vehicle tv WHERE tv.id > 0',
            registrationNo_cond, type_cond, capacity_cond,
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;


    SET @finalQuery = CONCAT(
            'INSERT INTO tmp_data (id, registrationNo, type, capacity, salesRepId)
             SELECT tv.id, tv.registrationNo, tv.type, tv.capacity, tv.salesRepId
             FROM tbl_vehicle tv
             WHERE tv.id > 0',
            registrationNo_cond, type_cond, capacity_cond, limit_cond
                      );
    PREPARE stmt2 FROM @finalQuery;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;


    SELECT page_number AS page,
           items_per_page AS itemsPerPage,
           (SELECT total_count FROM `tmp_count`) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'id', td.id,
                                   'registrationNo', td.registrationNo,
                                   'type', td.type,
                                   'capacity', td.capacity,
                                   'salesRepId', td.salesRepId
                           )
                   ) AS json_result
            FROM tmp_data td) AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;

END;
