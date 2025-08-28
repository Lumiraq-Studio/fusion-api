DROP PROCEDURE IF EXISTS auto_remove_stock_new;
CREATE PROCEDURE auto_remove_stock_new()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE today DATE;
    DECLARE repStockId INT;

    DECLARE rep_cursor CURSOR FOR
        SELECT id
        FROM tbl_rep_stock
        WHERE assignDate = CURDATE()
          AND status = 'active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    SET today = CURDATE();

    START TRANSACTION;

    OPEN rep_cursor;

    read_loop:
    LOOP
        FETCH rep_cursor INTO repStockId;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE tbl_variant_stock vs
            JOIN tbl_rep_stock_breakdowns bd
            ON vs.id = bd.variantStockId
        SET vs.availableQty = vs.availableQty + bd.remainingQty
        WHERE bd.salesRepStockId = repStockId
          AND bd.status = 'active';

        UPDATE tbl_rep_stock_breakdowns
        SET status       = 'inactive',
            remainingQty = 0
        WHERE salesRepStockId = repStockId;


        UPDATE tbl_rep_stock
        SET status    = 'inactive',
            updatedBy = 'system'
        WHERE id = repStockId;
    END LOOP;

    CLOSE rep_cursor;
    SELECT 'Successfully unassigned' AS message;
    COMMIT;
END;
