DROP PROCEDURE IF EXISTS sales_order_report;
CREATE PROCEDURE sales_order_report(
    IN route_id INT,
    IN sales_rep_id INT,
    IN customer_id INT,
    IN status_val VARCHAR(80),
    IN start_date VARCHAR(50),
    IN end_date VARCHAR(50)
)
BEGIN
    DECLARE route_cond VARCHAR(255) DEFAULT '';
    DECLARE rep_cond VARCHAR(255) DEFAULT '';
    DECLARE customer_cond VARCHAR(255) DEFAULT '';
    DECLARE status_cond VARCHAR(255) DEFAULT '';
    DECLARE date_range_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS tmp_data;
    CREATE TEMPORARY TABLE tmp_data
    (
        routeName      VARCHAR(255),
        salesRepName   VARCHAR(255),
        shopName       VARCHAR(100),
        productName    VARCHAR(255),
        weight         INT,
        unit           VARCHAR(255),
        orderDate      VARCHAR(255),
        orderTime      VARCHAR(255),
        orderReference VARCHAR(255),
        orderStatus    VARCHAR(255),
        variants       VARCHAR(255),
        price          DECIMAL(15, 2),
        qty            INT,
        paidValue      VARCHAR(255),
        orderValue          DECIMAL(15, 2)
    );

    IF route_id > 0  THEN
        SET route_cond = CONCAT(' AND tr.id = ', route_id);
    END IF;

    IF sales_rep_id > 0  THEN
        SET rep_cond = CONCAT(' AND so.salesRepId = ', sales_rep_id);
    END IF;

    IF customer_id > 0  THEN
        SET customer_cond = CONCAT(' AND so.shopId = ', customer_id);
    END IF;

    IF status_val <> '' THEN
        SET status_cond = CONCAT(' AND so.orderStatus = "', status_val, '"');
    END IF;

    IF start_date IS NOT NULL AND end_date IS NOT NULL THEN
        SET date_range_cond = CONCAT(' AND so.orderDate BETWEEN "', start_date, '" AND "', end_date, '"');
    END IF;

#
    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (routeName, salesRepName, shopName, productName,
            weight, unit, orderDate, orderReference, orderStatus, variants, price, qty, paidValue, orderValue, orderTime)
            SELECT
                tr.name AS routeName,
                sr.name AS salesRepName,
                ts.fullName AS shopName,
                tp.name AS productName,
                pv.weight AS weight,
                pv.unit AS unit,
                so.orderDate AS orderDate,
                so.orderReference AS orderReference,
                so.orderStatus AS orderStatus,
                GROUP_CONCAT(pv.variantReference SEPARATOR ", ") AS variants,
                SUM(soi.price) AS price,
                SUM(soi.quantity) AS qty,
                so.paid AS paidValue,
                SUM(soi.quantity * soi.price) AS value,
                so.createdTime
            FROM
                tbl_order_item soi
                INNER JOIN tbl_order so ON soi.orderId = so.id
                INNER JOIN tbl_shop ts ON so.shopId = ts.id
                INNER JOIN tbl_sales_rep sr ON so.salesRepId = sr.id
                INNER JOIN tbl_product_variant pv ON soi.variantId = pv.id
                INNER JOIN tbl_product tp ON pv.productId = tp.id
                INNER JOIN tbl_route tr ON ts.routeId = tr.id
            WHERE 1=1 ',
            route_cond, rep_cond, customer_cond, status_cond, date_range_cond, '
        GROUP BY
            tr.name, sr.name, ts.fullName, tp.name, pv.weight, pv.unit, so.orderDate, so.orderReference, so.orderStatus, so.paid, so.id
        ORDER BY so.orderDate, so.id'
                       );

    PREPARE stmt FROM @final_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    SELECT * FROM tmp_data;

    DROP TEMPORARY TABLE IF EXISTS tmp_data;
END;
