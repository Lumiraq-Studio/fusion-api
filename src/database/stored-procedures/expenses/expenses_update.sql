DROP PROCEDURE IF EXISTS expense_update;
CREATE PROCEDURE expense_update(
    IN expense_id INT,
    IN description_val VARCHAR(255),
    IN amount_val DECIMAL(10, 2),
    IN sales_rep_id INT,
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


    UPDATE tbl_expense
    SET description = description_val,
        amount = amount_val,
        salesRepId = sales_rep_id,
        updatedBy = updated_by,
        updatedAt = NOW()
    WHERE id = expense_id;

    SELECT expense_id AS updated_expense_id;

    COMMIT;
END;
