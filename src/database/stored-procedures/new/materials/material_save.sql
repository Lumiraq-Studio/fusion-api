DROP PROCEDURE IF EXISTS material_save;
CREATE PROCEDURE material_save(
    IN material_name VARCHAR(255),
    IN material_unitCost DECIMAL(10, 2),
    IN material_quantity INT
)
BEGIN
    DECLARE
        EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @sqlstate = RETURNED_SQLSTATE,
                @errno = MYSQL_ERRNO,
                @message_text = MESSAGE_TEXT;
            ROLLBACK;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;

    INSERT INTO tbl_material (name, unitCost, quantity, availableQty)
    VALUES (material_name, material_unitCost, material_quantity, material_quantity);

    SET
        @InsertedMaterialID = LAST_INSERT_ID();
    SELECT @InsertedMaterialID AS inserted_material_id;
    COMMIT;

END;