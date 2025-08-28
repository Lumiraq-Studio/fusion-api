DROP PROCEDURE IF EXISTS expenses_find;
DELIMITER $$

CREATE PROCEDURE expenses_find(
    IN sales_rep_id INT,
    IN expenses_date_val VARCHAR(255),
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE sales_rep_cond VARCHAR(255) DEFAULT '';
    DECLARE expenses_date_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';
    DECLARE offset_val INT DEFAULT 0;

    -- Drop & create temporary tables
    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        salesRepId          INT,
        salesRepName        VARCHAR(255),
        expenseDay          DATE,
        totalExpenseAmount  DECIMAL(10, 2),
        totalAssignedAmount DECIMAL(10, 2),
        balance             DECIMAL(10, 2)
    );

    -- Filters
    IF sales_rep_id > 0 THEN
        SET sales_rep_cond = CONCAT(' AND te.salesRepId = ', sales_rep_id);
    END IF;

    IF expenses_date_val <> '' THEN
        SET expenses_date_cond = CONCAT(' AND DATE(te.expensesDate) = "', expenses_date_val, '"');
    END IF;

    -- Pagination
    IF items_per_page > 0 AND page_number > 0 THEN
        SET offset_val = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', offset_val, ', ', items_per_page);
    END IF;

    -- Count query
    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM (
                 SELECT te.salesRepId, DATE(te.expensesDate) AS expenseDay
                 FROM tbl_expense te
                 WHERE te.id > 0',
            sales_rep_cond,
            expenses_date_cond,
            ' GROUP BY te.salesRepId, DATE(te.expensesDate)
             ) AS summary;'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    -- Data query
    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (salesRepId, salesRepName, expenseDay, totalExpenseAmount, totalAssignedAmount, balance)
             SELECT
                te.salesRepId,
                MAX(sr.name) AS salesRepName,
                DATE(te.expensesDate) AS expenseDay,
                SUM(CASE WHEN te.expensesType = ''Expense'' THEN te.expendAmount ELSE 0 END) AS totalExpenseAmount,
                SUM(CASE WHEN te.expensesType = ''Assigned'' THEN te.amount ELSE 0 END) AS totalAssignedAmount,
                SUM(CASE WHEN te.expensesType = ''Assigned'' THEN te.amount ELSE 0 END) -
                SUM(CASE WHEN te.expensesType = ''Expense'' THEN te.expendAmount ELSE 0 END) AS balance
             FROM tbl_expense te
             LEFT JOIN tbl_sales_rep sr ON te.salesRepId = sr.id
             WHERE te.id > 0',
            sales_rep_cond,
            expenses_date_cond,
            ' GROUP BY te.salesRepId, DATE(te.expensesDate)
              ORDER BY te.salesRepId, DATE(te.expensesDate)',
            limit_cond,
            ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    -- Final JSON result
    SELECT page_number                         AS page,
           items_per_page                      AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'salesRepId', td.salesRepId,
                                   'salesRepName', td.salesRepName,
                                   'expenseDay', td.expenseDay,
                                   'totalExpenseAmount', td.totalExpenseAmount,
                                   'totalAssignedAmount', td.totalAssignedAmount,
                                   'balance', td.balance
                           )
                   )
            FROM tmp_data td)                AS data;

    -- Clean up
    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END$$

DELIMITER ;
