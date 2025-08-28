DROP PROCEDURE IF EXISTS varaint_get;
CREATE PROCEDURE varaint_get(
    IN varinat_id INT
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

    SET @record_count = 0;

    SELECT COUNT(*) INTO @record_count FROM tbl_product_variant WHERE id = varinat_id;

    IF @record_count > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Multiple records found. Please contact system administrator.';
    ELSEIF @record_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Record not found. Please contact system administrator.';
    ELSE

        SELECT
            v.id AS variantId,
            v.weight,
            v.unit,
            v.basePrice,
            v.cost,
            p.id AS productId,
            p.name AS productName,
            p.description,
            v.variantReference AS sku
        FROM tbl_product_variant v
                 JOIN tbl_product p ON v.productId = p.id

        WHERE v.id = varinat_id;

    END IF;
    COMMIT;
END;
