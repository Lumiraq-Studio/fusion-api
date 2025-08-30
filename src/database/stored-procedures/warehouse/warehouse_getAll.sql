DROP PROCEDURE IF EXISTS warehouse_getAll;
CREATE PROCEDURE warehouse_getAll(
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;
    SELECT tw.id                AS warehouseId,
           tw.warehouseCode     AS warehouseCode,
           tw.warehouseName     AS warehouseName,
           tw.warehouseAddress  AS warehouseAddress,
           tw.contactPersonName AS warehouseContactPersonName,
           tw.contactNo         AS contactNo
    FROM tbl_warehouse tw;
    COMMIT;

END
