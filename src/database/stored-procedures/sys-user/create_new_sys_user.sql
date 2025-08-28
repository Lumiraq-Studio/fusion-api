DROP PROCEDURE IF EXISTS new_sys_user_save;
CREATE PROCEDURE new_sys_user_save(
    IN user_name_val VARCHAR(255),
    IN password_val VARCHAR(255),
    IN role_val VARCHAR(255),
    IN permission_val VARCHAR(20),
    IN user_val INT
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


    INSERT INTO tbl_system_user ( username, password, role, permissions, userId)
    VALUES (user_name_val,password_val,role_val,permission_val,user_val);

    SET @InsertedUserID = LAST_INSERT_ID();
    SELECT @InsertedUserID AS inserted_user_id;

    COMMIT;
END;
