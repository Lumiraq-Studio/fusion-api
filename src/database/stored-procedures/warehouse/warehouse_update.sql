DROP PROCEDURE IF EXISTS warehouse_update;
CREATE PROCEDURE warehouse_update(
    IN warehouse_id INT,
    IN warehouse_code VARCHAR(255),
    IN warehouse_name VARCHAR(255),
    IN warehouse_address VARCHAR(255),
    IN contact_person_name VARCHAR(255),
    IN contact_no VARCHAR(50),
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
    UPDATE tbl_warehouse tw
    SET tw.warehouseCode = warehouse_code,
        warehouseName = warehouse_name,
        warehouseAddress = warehouse_address,
        contactPersonName = contact_person_name,
        contactNo = contact_no,
        updatedBy = updated_by
    WHERE id = warehouse_id;

    SELECT warehouse_id AS updated_warehouse_id;

    COMMIT;
END;
