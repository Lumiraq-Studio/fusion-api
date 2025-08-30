DROP PROCEDURE IF EXISTS variant_update;
CREATE PROCEDURE variant_update(
    IN id_val INT,
    IN weight_val INT,
    IN unit_val TEXT,
    IN updated_by VARCHAR(255),
    IN base_price INT,
    IN cost_val INT
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

    UPDATE tbl_product_variant
    SET weight=weight_val,
        unit=unit_val,
        updatedBy=updated_by,
        cost = IFNULL(cost_val, cost),
        basePrice = IFNULL(base_price, basePrice),
        updatedAt=NOW()
    WHERE id = id_val;

    SELECT id_val AS updatedVariantId;
    COMMIT;

END;
