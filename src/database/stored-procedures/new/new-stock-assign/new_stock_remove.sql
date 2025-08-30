DROP PROCEDURE IF EXISTS unassign_rep_stock_with_breakdowns_json;
CREATE PROCEDURE unassign_rep_stock_with_breakdowns_json(
    IN in_rep_stock_id INT,
    IN updated_by VARCHAR(255),
    IN breakdowns_json JSON
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE total INT DEFAULT 0;
    DECLARE breakdown_id INT;
    DECLARE variant_stock_id INT;
    DECLARE remain_qty INT;
    DECLARE active_count INT DEFAULT 0;

    START TRANSACTION;

    SET total = JSON_LENGTH(breakdowns_json);

    WHILE i < total
        DO
            SET breakdown_id = JSON_UNQUOTE(JSON_EXTRACT(breakdowns_json, CONCAT('$[', i, '].breakdownId')));
            SET variant_stock_id = JSON_UNQUOTE(JSON_EXTRACT(breakdowns_json, CONCAT('$[', i, '].variantStockId')));
            SET remain_qty = JSON_UNQUOTE(JSON_EXTRACT(breakdowns_json, CONCAT('$[', i, '].remainQty')));

            UPDATE tbl_variant_stock
            SET availableQty = availableQty + remain_qty
            WHERE id = variant_stock_id;

            UPDATE tbl_rep_stock_breakdowns
            SET status       = 'inactive',
                remainingQty = 0
            WHERE id = breakdown_id;

            SET i = i + 1;
        END WHILE;

    SELECT COUNT(*)
    INTO active_count
    FROM tbl_rep_stock_breakdowns
    WHERE salesRepStockId = in_rep_stock_id
      AND status = 'Active';

    IF active_count = 0 THEN
        UPDATE tbl_rep_stock
        SET status    = 'inactive',
            updatedBy = updated_by,
            updatedAt = NOW()
        WHERE id = in_rep_stock_id;
    END IF;
    SELECT in_rep_stock_id AS repStockId;
    COMMIT;
END;
