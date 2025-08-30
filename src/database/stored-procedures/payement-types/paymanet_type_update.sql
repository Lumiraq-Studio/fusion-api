DROP PROCEDURE IF EXISTS payment_type_update;
CREATE PROCEDURE payment_type_update(
    IN payment_id INT,
    IN type_val VARCHAR(255),
    IN description_val VARCHAR(255)
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

    SELECT COUNT(*)
    INTO @record_count
    FROM tbl_payment_type
    WHERE type = type_val
      AND id <> payment_id;

    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment type already exists.';
        ROLLBACK;
    ELSE
        UPDATE tbl_payment_type
        SET type        = type_val,
            description = description_val
        WHERE id = payment_id;

        SELECT payment_id AS updated_payment_type_id;
        COMMIT;
    END IF;
END;
