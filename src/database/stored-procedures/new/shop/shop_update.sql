DROP PROCEDURE IF EXISTS shop_update;
CREATE PROCEDURE shop_update(
    IN shop_id INT,
    IN full_name VARCHAR(255),
    IN short_name VARCHAR(255),
    IN address_val VARCHAR(255),
    IN mobile_val VARCHAR(15),
    IN status_val VARCHAR(15),
    IN route_id INT,
    IN type_id INT,
    IN updated_by VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            ROLLBACK;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;

    SELECT COUNT(*) INTO @record_count FROM tbl_shop ts WHERE ts.id = shop_id;

    IF @record_count > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Multiple records found (Shop). Please contact system administrator.';
    ELSEIF @record_count < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Records not found (Shop). Please contact system administrator.';
    END IF;


    UPDATE tbl_shop
    SET fullName   = full_name,
        shortName  = short_name,
        address    = address_val,
        mobile     = mobile_val,
        status = IFNULL(status_val, status),
        routeId    = route_id,
        shopTypeId = type_id,
        updatedBy  = updated_by
    WHERE id = shop_id;


    SELECT shop_id AS updated_shop_id;
    COMMIT;

END;
