DROP PROCEDURE IF EXISTS warehouse_find;
CREATE PROCEDURE warehouse_find (
    IN warehouse_code VARCHAR(255),
    IN warehouse_name VARCHAR(255),
    IN contact_person_name VARCHAR(255),
    IN warehouse_address VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT)
BEGIN
    DECLARE warehouse_code_cond VARCHAR(255) DEFAULT '';
    DECLARE warehouse_name_cond VARCHAR(255) DEFAULT '';
    DECLARE contact_person_name_cond VARCHAR(255) DEFAULT '';
    DECLARE warehouse_address_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS tmp_data;
    CREATE TEMPORARY TABLE tmp_data
    (
        id INT,
        warehouseCode VARCHAR(255),
        warehouseName VARCHAR(255),
        warehouseAddress LONGTEXT,
        contactPersonName VARCHAR(255),
        contactNo VARCHAR(255)
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_count;
    CREATE TEMPORARY TABLE tmp_count
    (
        total_count INT
    );

    IF warehouse_code <> '' THEN
        SET warehouse_code_cond = CONCAT(' AND tw.warehouseCode LIKE "%', warehouse_code, '%"');
    END IF;

    IF warehouse_name <> '' THEN
        SET warehouse_name_cond = CONCAT(' AND tw.warehouseName LIKE "%', warehouse_name, '%"');
    END IF;

    IF contact_person_name <> '' THEN
        SET contact_person_name_cond = CONCAT(' AND tw.contactPersonName LIKE "%', contact_person_name, '%"');
    END IF;

    IF warehouse_address <> '' THEN
        SET warehouse_address_cond = CONCAT(' AND tw.warehouseAddress LIKE "%', warehouse_address, '%"');
    END IF;


    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count) SELECT COUNT(*) FROM tbl_warehouse tw WHERE 1=1 ',
            warehouse_code_cond, warehouse_name_cond, contact_person_name_cond, warehouse_address_cond
                      );

    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @finalQuery = CONCAT(
            'INSERT INTO tmp_data (id, warehouseCode, warehouseName, warehouseAddress, contactPersonName, contactNo) ',
            'SELECT tw.id, tw.warehouseCode, tw.warehouseName, tw.warehouseAddress, tw.contactPersonName, tw.contactNo',
            'FROM tbl_warehouse tw WHERE 1=1 ',
            warehouse_code_cond, warehouse_name_cond, contact_person_name_cond, warehouse_address_cond,
            ' ORDER BY tw.warehouseCode DESC ', limit_cond
                      );

    PREPARE stmt2 FROM @finalQuery;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number                           AS page,
           items_per_page                        AS itemsPerPage,
           (SELECT total_count FROM tmp_count)   AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'warehouseId', td.id,
                                   'warehouseCode', td.warehouseCode,
                                   'warehouseName', td.warehouseName,
                                   'warehouseAddress', td.warehouseAddress,
                                   'contactPersonName', td.contactPersonName,
                                   'contactNo', td.contactNo
                           )) AS json_result
            FROM tmp_data td) AS data;

    DROP TEMPORARY TABLE IF EXISTS tmp_count;
    DROP TEMPORARY TABLE IF EXISTS tmp_data;
END;
