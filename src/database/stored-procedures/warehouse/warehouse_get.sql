DROP PROCEDURE IF EXISTS warehouse_get;
CREATE PROCEDURE warehouse_get(
    IN warehouse_id INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;

    SELECT COUNT(*) INTO @record_count FROM tbl_warehouse tw WHERE tw.id = warehouse_id;

    IF @record_count > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Multiple records found. Please contact system administrator.';
    ELSEIF @record_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Records not found. Please contact system administrator.';
    ELSE
        SELECT tw.id AS warehouseId,
               tw.warehouseCode AS warehouseCode,
               tw.warehouseName AS warehouseName,
               tw.warehouseAddress AS warehouseAddress,
               tw.contactPersonName AS warehouseContactPersonName,
               tw.contactNo AS contactNo
        FROM tbl_warehouse tw
        WHERE tw.id = warehouse_id;
    END IF;
    COMMIT;

END
