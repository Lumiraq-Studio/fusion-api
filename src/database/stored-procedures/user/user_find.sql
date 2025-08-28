DROP PROCEDURE IF EXISTS user_find;
CREATE PROCEDURE user_find(
    IN search_fullName VARCHAR(255),
    IN search_designation VARCHAR(40),
    IN search_nic VARCHAR(255),
    IN search_email VARCHAR(255),
    IN search_status VARCHAR(50),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN


    DECLARE fullName_cond VARCHAR(255) DEFAULT '';
    DECLARE designation_cond VARCHAR(255) DEFAULT '';
    DECLARE nic_cond VARCHAR(255) DEFAULT '';
    DECLARE email_cond VARCHAR(255) DEFAULT '';
    DECLARE status_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';


    DROP TEMPORARY TABLE IF EXISTS tmp_data;
    CREATE TEMPORARY TABLE tmp_data (
                                          id INT,
                                          fullName VARCHAR(250),
                                          nic VARCHAR(20),
                                          designation VARCHAR(80),
                                          email VARCHAR(50),
                                          status VARCHAR(50)
    );


    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count` (
                                           total_count INT
    );


    IF search_fullName IS NOT NULL AND search_fullName <> '' THEN
        SET fullName_cond = CONCAT(' AND tu.fullName LIKE "', search_fullName, '%"');
    END IF;

    IF search_nic IS NOT NULL AND search_nic <> '' THEN
        SET nic_cond = CONCAT(' AND tu.nic LIKE "', search_nic, '%"');
    END IF;

    IF search_email IS NOT NULL AND search_email <> '' THEN
        SET email_cond = CONCAT(' AND tu.email LIKE "', search_email, '%"');
    END IF;

    IF search_designation IS NOT NULL AND search_designation <> '' THEN
        SET designation_cond = CONCAT(' AND tu.designation = "', designation_cond, '"');
    END IF;

    IF search_status IS NOT NULL AND search_status <> '' THEN
        SET status_cond = CONCAT(' AND tu.status = "', search_status, '"');
    END IF;


    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;


    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count) SELECT COUNT(*) FROM tbl_user tu WHERE tu.id > 0',
            fullName_cond, nic_cond, designation_cond,email_cond , status_cond,  ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @finalQuery = CONCAT(
            'INSERT INTO tmp_data (id, fullName, nic, designation, email, status)
             SELECT tu.id, tu.fullName, tu.nic, tu.designation, tu.email, tu.status
             FROM tbl_user tu
             WHERE tu.id > 0',
             fullName_cond, nic_cond, designation_cond,email_cond , status_cond, limit_cond
                      );
    PREPARE stmt2 FROM @finalQuery;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number AS page,
           items_per_page AS itemsPerPage,
           (SELECT total_count FROM `tmp_count`) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'userId', td.id,
                                   'fullName', td.fullName,
                                   'nic', td.nic,
                                   'designation', td.designation,
                                   'email', td.email,
                                   'status', td.status
                           )
                   ) AS json_result
            FROM tmp_data td) AS data;


    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;

END;
