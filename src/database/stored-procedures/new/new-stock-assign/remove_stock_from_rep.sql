DROP PROCEDURE IF EXISTS remove_assigned_qty;
CREATE PROCEDURE remove_assigned_qty(
    IN stock_breakdown_id INT,
    IN updated_by VARCHAR(100)
)
BEGIN

    DECLARE salesRepStock INT;


    START TRANSACTION;

    UPDATE tbl_variant_stock vs
        JOIN tbl_rep_stock_breakdowns rsb ON rsb.variantStockId = vs.id
    SET vs.availableQty  = vs.availableQty + rsb.remainingQty,
        rsb.status       = 'inactive',
        rsb.remainingQty = 0
    WHERE rsb.id = stock_breakdown_id
      AND rsb.remainingQty > 0;


    UPDATE tbl_rep_stock rs
    SET rs.status    = 'inactive',
        rs.updatedBy = updated_by
    WHERE rs.id = salesRepStock
      AND NOT EXISTS (SELECT 1
                      FROM tbl_rep_stock_breakdowns rsb
                      WHERE rsb.status = 'active'
                        AND rsb.remainingQty > 0
                        AND rsb.salesRepStockId = rs.id);
    COMMIT;
    SELECT stock_breakdown_id AS updatedId;
END;
