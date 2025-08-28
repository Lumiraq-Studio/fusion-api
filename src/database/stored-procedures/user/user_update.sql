DROP PROCEDURE IF EXISTS user_update;
CREATE PROCEDURE user_update(
    IN user_id INT,
    IN full_name_val VARCHAR(255),
    IN designation_val VARCHAR(255),
    IN nic_val VARCHAR(20),
    IN email_val VARCHAR(255),
    IN status_val VARCHAR(255),
    IN phone_number_val VARCHAR(20)
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


    SELECT COUNT(*) INTO @record_count FROM tbl_user WHERE nic = nic_val AND id <> user_id;
    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIC already exists for another user.';
        ROLLBACK;
    END IF;


    UPDATE tbl_user
    SET fullName    = full_name_val,
        designation = designation_val,
        nic         = nic_val,
        email       = email_val,
        status      = status_val,
        phoneNumber = phone_number_val
    WHERE id = user_id;

    SELECT user_id AS updated_user_id;
    COMMIT;
END;
