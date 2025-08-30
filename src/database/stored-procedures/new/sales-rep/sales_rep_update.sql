DROP PROCEDURE IF EXISTS sales_rep_update;
CREATE PROCEDURE sales_rep_update(
    IN sales_rep_id INT,
    IN name_val VARCHAR(255),
    IN status_val VARCHAR(2),
    IN contact_details_val VARCHAR(255),
    IN user_id INT,
    IN updated_by VARCHAR(255)
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

    SELECT COUNT(*) INTO @record_count FROM tbl_sales_rep WHERE name = name_val AND id <> sales_rep_id;
    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sales Representative name already exists for another record.';
        ROLLBACK;
    END IF;


    UPDATE tbl_sales_rep
    SET name = name_val,
        status = status_val,
        contactDetails = contact_details_val,
        userId = user_id,
        updatedBy = updated_by,
        updatedAt = NOW()
    WHERE id = sales_rep_id;

    SELECT sales_rep_id AS updated_sales_rep_id;

    COMMIT;
END;
