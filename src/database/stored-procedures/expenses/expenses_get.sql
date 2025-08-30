DROP PROCEDURE IF EXISTS expenses_get;
CREATE PROCEDURE expenses_get(
    IN expenses_id INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;

    SELECT COUNT(*) INTO @record_count FROM tbl_expense te WHERE te.id = expenses_id;

    IF @record_count > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Multiple records found. Please contact system administrator.';
    ELSEIF @record_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Records not found. Please contact system administrator.';
    ELSE
        SELECT te.id                          AS salesOrderId,
               te.description                 AS salesOrderReference,
               te.amount                      AS salesOrderDate,
               (SELECT JSON_OBJECT(
                               'salesRepId', tsr.id,
                               'salesRepName', tsr.name,
                               'contactDetails', tsr.contactDetails
                       ) AS json_result
                FROM tbl_sales_rep tsr
                WHERE tsr.id = te.salesRepId) AS 'salesRep'

        FROM tbl_expense te
        WHERE te.id = expenses_id;
    END IF;
    COMMIT;

END

