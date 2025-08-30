DROP PROCEDURE IF EXISTS route_save;
CREATE PROCEDURE route_save(
    IN route_name VARCHAR(255),
    IN route_area VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            ROLLBACK;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;



    INSERT INTO tbl_route (name, area)
    VALUES (route_name, route_area);

    SET @InsertedRouteID = LAST_INSERT_ID();
    SELECT @InsertedRouteID AS inserted_route_id;

    COMMIT;
END;
