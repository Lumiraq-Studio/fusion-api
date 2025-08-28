DROP PROCEDURE IF EXISTS expense_save;
CREATE PROCEDURE expense_save(
    IN description_val VARCHAR(255),
    IN type_val VARCHAR(255),
    IN amount_val DECIMAL(10, 2),
    IN sales_rep_id INT,
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

    INSERT INTO tbl_expense
    (
        expensesDate,
        description,
        amount,
        expendAmount,
        incomeAmount,
        salesRepId,
        createdBy,
        createdAt,
        expensesType
    )
    VALUES
        (
            DATE_FORMAT(NOW(), '%Y-%m-%d'),
            description_val,
            CASE
                WHEN type_val = 'Assigned' THEN amount_val
                ELSE 0
                END,
            CASE
                WHEN type_val = 'Expense' THEN amount_val
                ELSE 0
                END,
            CASE
                WHEN type_val = 'Income' THEN amount_val
                ELSE 0
                END,
            sales_rep_id,
            created_by,
            NOW(),
            type_val
        );



    SET @InsertedExpenseID = LAST_INSERT_ID();
    SELECT @InsertedExpenseID AS inserted_expense_id;
    COMMIT;
END;
