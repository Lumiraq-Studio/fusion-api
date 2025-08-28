DROP PROCEDURE IF EXISTS return_save;
CREATE PROCEDURE return_save(
    IN return_reason VARCHAR(255),
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


    INSERT INTO tbl_return ( returnReason, returnDate, createdBy, createdAt)
    VALUES ( return_reason, NOW(), created_by, NOW());


    SET @InsertedReturnID = LAST_INSERT_ID();
    SELECT @InsertedReturnID AS inserted_return_id;

    COMMIT;
END;
