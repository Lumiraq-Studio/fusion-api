DROP PROCEDURE IF EXISTS product_save;
CREATE PROCEDURE product_save(
    IN product_name VARCHAR(255),
    IN description_val TEXT,
    IN warehouse_id INT,
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

    SELECT COUNT(*)
    INTO @record_count
    FROM tbl_product
    WHERE name = product_name
      AND warehouseId = warehouse_id;

    IF @record_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product name already exists in this warehouse.';
        ROLLBACK;
    ELSE
        SET @product_prefix = DATE_FORMAT(CURRENT_DATE, '%Y%m');
        SELECT MAX(
                       CAST(SUBSTRING_INDEX(productReference, '/', -1) AS UNSIGNED)
               )
        INTO @last_number
        FROM tbl_product
        WHERE productReference LIKE CONCAT('NVD', @product_prefix, '/%')
          AND warehouseId = warehouse_id;

        IF @last_number IS NULL THEN
            SET @last_number = 0;
        END IF;

        SET @last_number = @last_number + 1;
        SET @new_reference_number = CONCAT(
                'NVD',
                @product_prefix,
                '/',
                LPAD(@last_number, 5, '0')
                                    );
        INSERT INTO tbl_product (name, productReference, description, warehouseId, createdBy)
        VALUES (product_name, @new_reference_number, description_val, warehouse_id, created_by);

        SET @InsertedProductID = LAST_INSERT_ID();
        SELECT @InsertedProductID AS inserted_product_id;

        COMMIT;
    END IF;
END;
