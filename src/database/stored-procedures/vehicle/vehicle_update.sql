DROP PROCEDURE IF EXISTS vehicle_update;
CREATE PROCEDURE vehicle_update(
    IN vehicle_id INT,
    IN registration_no VARCHAR(255),
    IN type_val VARCHAR(255),
    IN capacity_val INT,
    IN sales_rep_id INT
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

    UPDATE tbl_vehicle
    SET registrationNo = registration_no,
        type = type_val,
        capacity = capacity_val,
        salesRepId = sales_rep_id
    WHERE id = vehicle_id;

    SELECT vehicle_id AS updated_vehicle_id;

    COMMIT;
END;
