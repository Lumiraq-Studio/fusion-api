DROP PROCEDURE IF EXISTS material_update;
CREATE PROCEDURE material_update(
    IN material_id INT,
    IN material_name VARCHAR(255),
    IN material_unitCost DECIMAL(10, 2),
    IN material_quantity INT,
    IN material_availableQty INT
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

    UPDATE tbl_material
    SET name         = IFNULL(material_name, name),
        unitCost     = IFNULL(material_unitCost, unitCost),
        quantity     = IFNULL(material_quantity, quantity),
        availableQty = IFNULL(material_availableQty, availableQty)
    WHERE id = material_id;

    SELECT material_id AS updatedId;
    COMMIT;
END;