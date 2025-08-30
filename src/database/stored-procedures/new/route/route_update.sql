DROP PROCEDURE IF EXISTS route_update;
CREATE PROCEDURE route_update(
    IN route_id INT,
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

    SELECT COUNT(*)
    INTO @record_count
    FROM tbl_route
    WHERE name = route_name
      AND id <> route_id;

    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Route name already exists.';
        ROLLBACK;
    ELSE

        UPDATE tbl_route
        SET name = route_name,
            area = route_area
        WHERE id = route_id;
        SELECT route_id AS updated_route_id;
        COMMIT;
    END IF;
END;
