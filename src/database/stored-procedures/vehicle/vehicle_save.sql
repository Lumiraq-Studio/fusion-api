DROP PROCEDURE IF EXISTS vehicle_save;
CREATE PROCEDURE vehicle_save(
    IN registration_no VARCHAR(255),
    IN type_val VARCHAR(255),
    IN capacity_val INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @sqlstate = RETURNED_SQLSTATE,
                @errno = MYSQL_ERRNO,
                @message_text = MESSAGE_TEXT;
            ROLLBACK;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;


    INSERT INTO tbl_vehicle (registrationNo, type, capacity, salesRepId)
    VALUES (registration_no, type_val, capacity_val, 1);


    SET @InsertedVehicleID = LAST_INSERT_ID();
    SELECT @InsertedVehicleID AS inserted_vehicle_id;
    COMMIT;
END;
