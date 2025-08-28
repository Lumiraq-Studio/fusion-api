DROP PROCEDURE IF EXISTS user_save;
CREATE PROCEDURE user_save(
    IN full_name_val VARCHAR(255),
    IN designation_val VARCHAR(255),
    IN nic_val VARCHAR(20),
    IN email_val VARCHAR(255),
    IN phone_number_val VARCHAR(20),
    IN created_by VARCHAR(255)
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

    SELECT COUNT(*) INTO @record_count FROM tbl_user WHERE nic = nic_val;
    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NIC already exists.';
        ROLLBACK;
    END IF;

    INSERT INTO tbl_user ( fullName,designation,status, nic, email, phoneNumber, createdBy, createdAt)
    VALUES (full_name_val, designation_val,'active',nic_val, email_val, phone_number_val, created_by, NOW());

    SET @InsertedUserID = LAST_INSERT_ID();
    SELECT @InsertedUserID AS inserted_user_id;

    COMMIT;
END;
