DROP PROCEDURE IF EXISTS order_get_id;
CREATE PROCEDURE order_get_id(
    IN order_id INT
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

    SET @record_count = 0;
    SELECT COUNT(*) INTO @record_count FROM tbl_order WHERE id = order_id;

    IF @record_count > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Multiple records found. Please contact system administrator.';
    ELSEIF @record_count = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order not found. Please contact system administrator.';
    ELSE
        SELECT o.id                      AS orderId,
               o.orderType               AS orderType,
               o.orderStatus             AS status,
               o.salesRepId              AS salesRepId,
               o.paid                    AS paidAmount,
               o.orderReference          AS orderReference,
               o.orderDate               AS orderDate,
               o.paymentTypeId           AS paymentType,
               o.uuId                    AS uuId,
               o.shopId                  AS shopId,
               s.shopCode                AS shopCode,
               s.fullName                AS shopName,
               o.createdTime             AS orderTime,

               (SELECT JSON_ARRAYAGG(
                               JSON_OBJECT(
                                       'orderItemId', oi.id,
                                       'quantity', oi.quantity,
                                       'price', oi.price,
                                       'totalPrice', oi.totalPrice,
                                       'status', oi.status,
                                       'variantId', oi.variantId,
                                       'productId', p.id,
                                       'productName', p.name,
                                       'variantId', pv.id,
                                       'weight', pv.weight,
                                       'unit', pv.unit
                               )
                       )
                FROM tbl_order_item oi
                         INNER JOIN tbl_product_variant pv ON oi.variantId = pv.id
                         INNER JOIN tbl_product p ON pv.productId = p.id
                WHERE oi.orderId = o.id) AS orderItems,
               (SELECT COALESCE(SUM(oi.totalPrice), 0)
                FROM tbl_order_item oi
                WHERE oi.orderId = o.id) AS orderAmount
        FROM tbl_order o
                 JOIN tbl_shop s ON s.id = o.shopId
        WHERE o.id = order_id;
    END IF;
    COMMIT;
END;
