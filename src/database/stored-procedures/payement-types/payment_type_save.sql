DROP PROCEDURE IF EXISTS payment_type_save;
CREATE PROCEDURE payment_type_save(
    IN p_type VARCHAR(255),
    IN p_description TEXT
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
    WHERE type = p_type;

    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment type already exists.';
        ROLLBACK;
    ELSE
        INSERT INTO tbl_payment_type (type, description)
        VALUES (p_type, p_description);

        SET @InsertedPaymentTypeID = LAST_INSERT_ID();
        SELECT @InsertedPaymentTypeID AS inserted_payment_type_id;

        COMMIT;
    END IF;
END;
