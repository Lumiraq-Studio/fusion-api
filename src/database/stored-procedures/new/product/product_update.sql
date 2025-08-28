DROP PROCEDURE IF EXISTS product_update;
CREATE PROCEDURE product_update(
    IN product_id INT,
    IN product_name VARCHAR(255),
    IN description_val TEXT,
    IN warehouse_id INT,
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


    SELECT COUNT(*)
    INTO @record_count
    FROM tbl_product
    WHERE name = product_name
      AND warehouseId = warehouse_id
      AND id <> product_id;

    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product name already exists in this warehouse.';
        ROLLBACK;
    ELSE

        UPDATE tbl_product
        SET name        = product_name,
            description = description_val,
            warehouseId = warehouse_id,
            updatedBy   = updated_by
        WHERE id = product_id;


        SELECT product_id AS updated_product_id;
        COMMIT;
    END IF;
END;
