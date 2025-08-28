DROP PROCEDURE IF EXISTS rep_stock_get_by_rep;
CREATE PROCEDURE rep_stock_get_by_rep(
    IN rep_id INT,
    IN assign_date VARCHAR(150)
)
BEGIN
    DECLARE effective_date DATE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                @sqlstate = RETURNED_SQLSTATE,
                @errno = MYSQL_ERRNO,
                @message_text = MESSAGE_TEXT;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    #     IF assign_date IS NULL OR assign_date = '' THEN
#         SET effective_date = CURRENT_DATE;
#     ELSE
#         SET effective_date = STR_TO_DATE(assign_date, '%Y-%m-%d');
#     END IF;

    WITH rep_data AS (SELECT rs.salesRepId,
                             p.id                           AS productId,
                             p.name                         AS productName,
                             pv.id                          AS variantId,
                             CONCAT(pv.weight, '', pv.unit) AS variant,
                             rs.assignDate,
                             vs.id AS variantStockId,
                             rs.id   AS stockId,
#                              rsb.variantStockId,
                             rsb.assignedQty,
                             rsb.remainingQty,
                             rsb.id                         AS stockBreakdownId,
                             rsb.soldQty
                      FROM tbl_rep_stock_breakdowns rsb
                               JOIN tbl_rep_stock rs ON rs.id = rsb.salesRepStockId
                               JOIN tbl_variant_stock vs ON vs.id = rsb.variantStockId
                               JOIN tbl_product_variant pv ON pv.id = vs.variantId
                               JOIN tbl_product p ON p.id = pv.productId
                      WHERE rs.salesRepId = rep_id
                        AND rsb.status = 'active'
                        AND DATE(rs.assignDate) = CURDATE()),
         variants_grouped AS (SELECT salesRepId,
                                     productId,
                                     productName,
                                     JSON_ARRAYAGG(
                                             JSON_OBJECT(
                                                     'assignDate', assignDate,
                                                     'repStockId', stockId,
                                                     'variantId', variantId,
                                                     'variant', variant,
                                                     'variantStockId', variantStockId,
                                                     'assignedQty', assignedQty,
                                                     'remainingQty', remainingQty,
                                                     'stockBreakdownId', stockBreakdownId,
                                                     'soldQty', soldQty
                                             )
                                     ) AS variants
                              FROM rep_data
                              GROUP BY salesRepId, productId, productName),
         products_grouped AS (SELECT salesRepId,
                                     JSON_ARRAYAGG(
                                             JSON_OBJECT(
                                                     'productId', productId,
                                                     'productName', productName,
                                                     'variants', variants
                                             )
                                     ) AS availableStock
                              FROM variants_grouped
                              GROUP BY salesRepId)
    SELECT sr.id   AS salesRepId,
           sr.name AS salesRepName,
           pg.availableStock
    FROM tbl_sales_rep sr
             JOIN products_grouped pg ON pg.salesRepId = sr.id
    WHERE sr.id = rep_id;
END;

