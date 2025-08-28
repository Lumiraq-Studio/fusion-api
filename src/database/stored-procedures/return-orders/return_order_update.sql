DROP PROCEDURE IF EXISTS return_update;
CREATE PROCEDURE return_update(
    IN return_id INT,
#     IN order_id INT,
    IN return_reason TEXT
#     IN updated_by VARCHAR(255)
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

    UPDATE tbl_return
    SET
        returnReason = return_reason,
        updatedAt = NOW()
    WHERE id = return_id;
    SELECT return_id AS updated_return_id;

    COMMIT;
END;
