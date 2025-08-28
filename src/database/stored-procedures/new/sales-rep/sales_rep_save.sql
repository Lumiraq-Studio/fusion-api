DROP PROCEDURE IF EXISTS sales_rep_save;
CREATE PROCEDURE sales_rep_save(
    IN name_val VARCHAR(255),
    IN contact_details_val VARCHAR(255),
    IN user_id INT,
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

    SELECT COUNT(*) INTO @record_count FROM tbl_sales_rep WHERE name = name_val;
    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sales Representative name already exists.';
        ROLLBACK;
    END IF;


    INSERT INTO tbl_sales_rep (name, status, contactDetails, userId, createdBy, createdAt)
    VALUES (name_val, 'A', contact_details_val, user_id, created_by, NOW());

    SET @InsertedSalesRepID = LAST_INSERT_ID();
    SELECT @InsertedSalesRepID AS inserted_sales_rep_id;

    COMMIT;
END;
