DROP PROCEDURE IF EXISTS product_get_by_shop;
CREATE PROCEDURE product_get_by_shop(
    IN product_id INT
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
        SELECT
            p.id AS productId,
            p.name AS productName,
            p.description AS description,
            p.warehouseId AS warehouseId,
            (SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                                    'variantId', pv.id,
                                    'weight', pv.weight,
                                    'basePrice', pv.basePrice,
                                    'unit', pv.unit,
                                    'cost', pv.cost
                            )
            )
             FROM tbl_product_variant pv

             WHERE pv.productId = p.id
            ) AS variants
        FROM
            tbl_product p
        WHERE
            p.id = product_id;

    COMMIT;
END;
