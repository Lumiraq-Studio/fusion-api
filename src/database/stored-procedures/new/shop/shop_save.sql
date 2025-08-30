DROP PROCEDURE IF EXISTS shop_save;
CREATE PROCEDURE shop_save(
    IN full_name VARCHAR(255),
    IN short_name VARCHAR(255),
    IN address_val VARCHAR(255),
    IN city_val VARCHAR(255),
    IN mobile_val VARCHAR(15),
    IN route_id INT,
    IN type_id INT,
    IN created_by VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            ROLLBACK;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;

    SET @year_month = DATE_FORMAT(CURRENT_DATE, '%Y%m');
    SET @last_code = (SELECT shopCode
                      FROM tbl_shop
                      WHERE shopCode LIKE CONCAT('CU', @year_month, '/%')
                      ORDER BY shopCode DESC
                      LIMIT 1);
    IF @last_code IS NOT NULL THEN
        SET @last_number = CAST(SUBSTRING_INDEX(@last_code, '/', -1) AS UNSIGNED);
        SET @new_code_num = @last_number + 1;
    ELSE
        SET @new_code_num = 1;
    END IF;

    SET @shop_code = CONCAT('CU', @year_month, '/', LPAD(@new_code_num, 5, '0'));
    INSERT INTO tbl_shop (shopCode, fullName, shortName, address, mobile, routeId, createdBy, city, shopTypeId)
    VALUES (@shop_code, full_name, short_name, address_val, mobile_val, route_id, created_by, city_val, type_id);
    SET @InsertedShopID = LAST_INSERT_ID();
    SELECT @InsertedShopID AS inserted_shop_id;
    COMMIT;
END;
