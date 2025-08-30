DROP PROCEDURE IF EXISTS new_save_rep_stock_with_breakdowns;
CREATE PROCEDURE new_save_rep_stock_with_breakdowns(
    IN in_rep_stock_id INT,
    IN created_by VARCHAR(255),
    IN sales_rep_id INT,
    IN breakdowns_json JSON
)
BEGIN
    DECLARE new_rep_stock_id INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE total INT DEFAULT 0;
    DECLARE breakdownId INT DEFAULT 0;
    DECLARE variant_stock_id INT DEFAULT 0;
    DECLARE assigned_qty INT DEFAULT 0;



    IF in_rep_stock_id > 0 THEN
        UPDATE tbl_rep_stock
        SET
            updatedBy = created_by,
            updatedAt = NOW()
        WHERE id = in_rep_stock_id;

        SET new_rep_stock_id = in_rep_stock_id;
    ELSE
        INSERT INTO tbl_rep_stock (assignDate, status, createdBy, salesRepId)
        VALUES (CURDATE(), 'active', created_by, sales_rep_id);

        SET new_rep_stock_id = LAST_INSERT_ID();
    END IF;


    SET total = JSON_LENGTH(breakdowns_json);

    WHILE i < total
        DO
            SET breakdownId = JSON_EXTRACT(breakdowns_json, CONCAT('$[', i, '].breakdownId'));
            SET variant_stock_id = JSON_EXTRACT(breakdowns_json, CONCAT('$[', i, '].variantStockId'));
            SET assigned_qty = JSON_EXTRACT(breakdowns_json, CONCAT('$[', i, '].assignedQty'));

            IF breakdownId > 0 THEN
                UPDATE tbl_rep_stock_breakdowns
                SET
                    assignedQty = assignedQty + assigned_qty,
                    remainingQty = remainingQty + assigned_qty
                WHERE id = breakdownId;
            ELSE
                INSERT INTO tbl_rep_stock_breakdowns (
                    assignedQty,
                    status,
                    salesRepStockId,
                    remainingQty,
                    variantStockId
                )
                VALUES (
                           assigned_qty,
                           'active',
                           new_rep_stock_id,
                           assigned_qty,
                           variant_stock_id
                       );
            END IF;

            UPDATE tbl_variant_stock
            SET availableQty = availableQty - assigned_qty
            WHERE id = variant_stock_id;

            SET i = i + 1;
        END WHILE;

    SELECT sales_rep_id AS repId;

    COMMIT;
END;
