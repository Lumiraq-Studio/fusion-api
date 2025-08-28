DROP PROCEDURE IF EXISTS order_find;
CREATE PROCEDURE order_find(
    IN order_date VARCHAR(255),
    IN order_type VARCHAR(255),
    IN status_val VARCHAR(255),
    IN order_reference_val VARCHAR(255),
    IN shop_name_val VARCHAR(255),
    IN sales_rep_name_val VARCHAR(255),
    IN payment_type_val VARCHAR(255),
    IN route_id INT,
    IN items_per_page INT,
    IN page_number INT
)
BEGIN
    DECLARE order_date_cond VARCHAR(255) DEFAULT '';
    DECLARE order_type_cond VARCHAR(255) DEFAULT '';
    DECLARE status_val_cond VARCHAR(255) DEFAULT '';
    DECLARE order_reference_cond VARCHAR(255) DEFAULT '';
    DECLARE shop_name_cond VARCHAR(255) DEFAULT '';
    DECLARE route_id_cond VARCHAR(255) DEFAULT '';
    DECLARE sales_rep_name_cond VARCHAR(255) DEFAULT '';
    DECLARE payment_type_cond VARCHAR(255) DEFAULT '';
    DECLARE limit_cond VARCHAR(255) DEFAULT '';

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    CREATE TEMPORARY TABLE `tmp_count`
    (
        total_count INT
    );

    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
    CREATE TEMPORARY TABLE `tmp_data`
    (
        orderId        INT,
        orderType      VARCHAR(255),
        orderDate      VARCHAR(255),
        orderStatus    VARCHAR(255),
        orderReference VARCHAR(255),
        shopName       VARCHAR(255),
        salesRepName   VARCHAR(255),
        paymentType    VARCHAR(255),
        totalAmount    DECIMAL(10, 2),
        orderTime      VARCHAR(255)
    );

    IF order_date <> '' THEN
        SET order_date_cond = CONCAT(' AND o.orderDate = "', order_date, '"');
    END IF;

    IF order_type <> '' THEN
        SET order_type_cond = CONCAT(' AND o.orderType = "', order_type, '"');
    END IF;

    IF status_val <> '' THEN
        SET status_val_cond = CONCAT(' AND o.orderStatus = "', status_val, '"');
    END IF;

    IF order_reference_val <> '' THEN
        SET order_reference_cond = CONCAT(' AND o.orderReference LIKE "%', order_reference_val, '%"');
    END IF;

    IF shop_name_val <> '' THEN
        SET shop_name_cond = CONCAT(' AND s.fullName LIKE "%', shop_name_val, '%"');
    END IF;

    IF route_id IS NOT NULL AND route_id > 0 THEN
        SET route_id_cond = CONCAT(' AND r.id = ', route_id);  -- changed condition
    END IF;

    IF sales_rep_name_val <> '' THEN
        SET sales_rep_name_cond = CONCAT(' AND sr.name LIKE "%', sales_rep_name_val, '%"');
    END IF;

    IF payment_type_val <> '' THEN
        SET payment_type_cond = CONCAT(' AND pt.type LIKE "%', payment_type_val, '%"');
    END IF;

    IF items_per_page > 0 AND page_number > 0 THEN
        SET @offset = (page_number - 1) * items_per_page;
        SET limit_cond = CONCAT(' LIMIT ', @offset, ', ', items_per_page);
    END IF;

    SET @countQuery = CONCAT(
            'INSERT INTO tmp_count (total_count)
             SELECT COUNT(*)
             FROM tbl_order o
             LEFT JOIN tbl_shop s ON o.shopId = s.id
             LEFT JOIN tbl_route r ON s.routeId = r.id
             LEFT JOIN tbl_sales_rep sr ON o.salesRepId = sr.id
             LEFT JOIN tbl_payment_type pt ON o.paymentTypeId = pt.id
             WHERE o.id > 0', order_date_cond, order_type_cond, status_val_cond, order_reference_cond, shop_name_cond,
            sales_rep_name_cond,route_id_cond, payment_type_cond, ';'
                      );
    PREPARE stmt1 FROM @countQuery;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    SET @final_query = CONCAT(
            'INSERT INTO tmp_data (orderId, orderType, orderDate, orderStatus, orderReference, shopName, salesRepName, paymentType,totalAmount,orderTime)
             SELECT o.id, o.orderType, o.orderDate, o.orderStatus, o.orderReference, s.fullName AS shopName, sr.name AS salesRepName, pt.type AS paymentType,COALESCE(SUM(oi.totalPrice), 0) AS totalAmount, o.createdTime
             FROM tbl_order o
             LEFT JOIN tbl_shop s ON o.shopId = s.id
             LEFT JOIN tbl_route r ON s.routeId = r.id
             LEFT JOIN tbl_sales_rep sr ON o.salesRepId = sr.id
             LEFT JOIN tbl_payment_type pt ON o.paymentTypeId = pt.id
             LEFT JOIN tbl_order_item oi ON oi.orderId = o.id
             WHERE o.id > 0', order_date_cond, order_type_cond, status_val_cond, order_reference_cond, shop_name_cond,
            sales_rep_name_cond,route_id_cond, payment_type_cond, ' GROUP BY o.id ORDER BY o.id DESC', limit_cond, ';'
                       );
    PREPARE stmt2 FROM @final_query;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;

    SELECT page_number                         AS page,
           items_per_page                      AS itemsPerPage,
           (SELECT total_count FROM tmp_count) AS totalItems,
           (SELECT JSON_ARRAYAGG(
                           JSON_OBJECT(
                                   'orderId', td.orderId,
                                   'orderType', td.orderType,
                                   'orderDate', td.orderDate,
                                   'status', td.orderStatus,
                                   'orderReference', td.orderReference,
                                   'customerName', td.shopName,
                                   'salesRepName', td.salesRepName,
                                   'paymentType', td.paymentType,
                                   'orderAmount', td.totalAmount,
                                   'orderTime', td.orderTime
                           )
                   )
            FROM tmp_data td)                  AS data;

    DROP TEMPORARY TABLE IF EXISTS `tmp_count`;
    DROP TEMPORARY TABLE IF EXISTS `tmp_data`;
END;
