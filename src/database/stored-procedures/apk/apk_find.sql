DROP PROCEDURE IF EXISTS apk_find;
CREATE PROCEDURE apk_find(
    IN version_name VARCHAR(255),
    IN platform_val VARCHAR(255),
    IN status_val VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE version_name_cond VARCHAR(255) DEFAULT '';
    DECLARE platform_val_cond VARCHAR(255) DEFAULT '';
    DECLARE status_val_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        id                INT,
        version              VARCHAR(255),
        platform       VARCHAR(255),
        status     VARCHAR(255),
        size               VARCHAR(255),
        releaseDate    VARCHAR(255),
        link    VARCHAR(255)

    );

    IF version_name <> '' THEN
        SET version_name_cond =  CONCAT(' AND apk.version = "', version_name, '"');
    END IF;

    IF platform_val <> '' THEN

        SET platform_val_cond =  CONCAT(' AND apk.platform = "', platform_val, '"');
    END IF;

    IF status_val <> '' THEN
        SET status_val_cond =  CONCAT(' AND apk.status = "', status_val, '"');
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_apk_details apk
                WHERE apk.id > 0', version_name_cond, platform_val_cond,status_val_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, version, platform, status, size, releaseDate,link)
             SELECT apk.id, apk.version, apk.platform, apk.status, apk.apkSize, apk.releaseDate, apk.apkLink
             FROM tbl_apk_details apk
             WHERE apk.id > 0', version_name_cond, platform_val_cond, status_val_cond,
            ' GROUP BY apk.id', limit_cond, ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    -- Return results
    SELECT
        page_number AS page,
        items_per_page AS itemsPerPage,
        (SELECT total_count FROM tmp_count) AS totalItems,
        (SELECT JSON_ARRAYAGG(
                        JSON_OBJECT(
                                'id', td.id,
                                'version', td.version,
                                'platform', td.platform,
                                'status', td.status,
                                'size', td.size,
                                'releaseDate', td.releaseDate,
                                'link', td.link
                        )
                )
         FROM tmp_data td) AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
