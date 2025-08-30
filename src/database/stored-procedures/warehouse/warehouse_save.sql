DROP PROCEDURE IF EXISTS warehouse_save;
CREATE PROCEDURE warehouse_save(
    IN warehouse_code VARCHAR(255),
    IN warehouse_name VARCHAR(255),
    IN warehouse_address VARCHAR(255),
    IN contact_person_name VARCHAR(255),
    IN contact_no VARCHAR(50),
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


    INSERT INTO tbl_warehouse (warehouseCode, warehouseName, warehouseAddress, contactPersonName, contactNo, createdBy)
    VALUES (warehouse_code, warehouse_name, warehouse_address, contact_person_name, contact_no, created_by);

    SET @InsertedWarehouseID = LAST_INSERT_ID();
    SELECT @InsertedWarehouseID AS inserted_warehouse_id;

    COMMIT;
END;
