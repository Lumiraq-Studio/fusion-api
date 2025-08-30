DROP PROCEDURE IF EXISTS sales_rep_find;
CREATE PROCEDURE sales_rep_find(
    IN rep_name VARCHAR(255),
    IN rep_status VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE name_cond VARCHAR(255) DEFAULT '';
    DECLARE status_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';


    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );


    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        id             INT,
        name           VARCHAR(255),
        status         VARCHAR(5),
        contactDetails VARCHAR(255),
        userName VARCHAR(255)
    );


    IF rep_name <> '' THEN
        SET name_cond = CONCAT(' AND sr.name LIKE "%', rep_name, '%"');
    END IF;
    IF rep_status <> '' THEN
        SET status_cond = CONCAT(' AND sr.status = "', rep_status, '"');
    END IF;


    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;


    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_sales_rep sr
             WHERE sr.id > 0', name_cond, status_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;


    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, name, status, contactDetails,userName)
             SELECT sr.id, sr.name, sr.status, sr.contactDetails,tsu.username
        FROM tbl_sales_rep sr
INNER JOIN tbl_user usr ON sr.userId = usr.id
INNER JOIN tbl_system_user tsu ON sr.systemUserId = tsu.id
        WHERE sr.id > 0 and sr.status=''A''  ', name_cond, status_cond, limit_cond, ';'
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
                                   'status', td.status,
                                   'contactDetails', td.contactDetails,
                                   'userName', td.userName
                           )
                   )
            FROM tmp_data td)                  AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
