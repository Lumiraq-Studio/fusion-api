DROP PROCEDURE IF EXISTS product_find;
CREATE PROCEDURE product_find(
    IN product_name VARCHAR(255),
    IN warehouse_code VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE name_cond VARCHAR(255) DEFAULT '';
    DECLARE warehouse_code_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        id                INT,
        name              VARCHAR(255),
        description       VARCHAR(255),
        warehouseCode     VARCHAR(255),
        sku               VARCHAR(255),
        totalAssignedQty  INT,
        totalSoldQty      INT,
        totalRemainingQty INT
    );

    IF product_name <> '' THEN
        SET name_cond = CONCAT(' AND p.name LIKE "%', product_name, '%"');
    END IF;

    IF warehouse_code <> '' THEN
        SET warehouse_code_cond = CONCAT(' AND w.warehouseCode LIKE "%', warehouse_code, '%"');
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
FROM tbl_product p
         JOIN
     tbl_warehouse w ON p.warehouseId = w.id
         LEFT JOIN tbl_product_variant pv ON pv.productId = p.id
         LEFT JOIN tbl_variant_stock vs ON pv.id=vs.variantId
        LEFT JOIN tbl_rep_stock_breakdowns rsb ON vs.id =rsb.variantStockId
                WHERE p.id > 0', name_cond, warehouse_code_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (id, name, description, warehouseCode,sku, totalAssignedQty, totalSoldQty, totalRemainingQty)
            SELECT p.id                               AS productId,
       p.name                             AS productName,
       p.description                       ,
       w.warehouseCode,
       p.productReference,
       COALESCE(SUM(rsb.assignedQty), 0)  AS totalAssignedQty,
       COALESCE(SUM(rsb.soldQty), 0)      AS totalSoldQty,
       COALESCE(SUM(vs.availableQty), 0) AS totalAvailableQty
FROM tbl_product p
         JOIN
     tbl_warehouse w ON p.warehouseId = w.id
         LEFT JOIN tbl_product_variant pv ON pv.productId = p.id
        LEFT JOIN tbl_variant_stock vs ON pv.id=vs.variantId
        LEFT JOIN tbl_rep_stock_breakdowns rsb ON vs.id =rsb.variantStockId
                WHERE p.id > 0', name_cond, warehouse_code_cond,
           ' GROUP BY p.id, p.name', limit_cond, ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number                         AS page,
           items_per_page                      AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'id', td.id,
                                   'name', td.name,
                                   'description', td.description,
                                   'warehouseCode', td.warehouseCode,
                                   'sku', td.sku,
                                   'totalAssignedQty', td.totalAssignedQty,
                                   'totalSoldQty', td.totalSoldQty,
                                   'totalRemainingQty', td.totalRemainingQty
                           )
                   )
            FROM tmp_data td)                  AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
