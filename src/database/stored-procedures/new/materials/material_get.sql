DROP PROCEDURE IF EXISTS material_get_by_id;
CREATE PROCEDURE material_get_by_id(
    IN material_id INT
)
BEGIN
    SELECT id, name, unitCost, quantity, availableQty
    FROM tbl_material
    WHERE id = material_id;
END;
