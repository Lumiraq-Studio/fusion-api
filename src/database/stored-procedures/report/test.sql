# DROP PROCEDURE IF EXISTS price_by_route_id;
# CREATE PROCEDURE price_by_route(
#     IN route_id INT,
#     IN start_date VARCHAR(50),
#     IN end_date VARCHAR(50)
# )
# BEGIN
#     DECLARE route_cond VARCHAR(255) DEFAULT '';
#     DECLARE date_range_cond VARCHAR(255) DEFAULT '';
#
#     DROP TEMPORARY TABLE IF EXISTS tmp_price_data;
#     CREATE TEMPORARY TABLE tmp_price_data (
#                                               Price       DECIMAL(10, 2),
#                                               GlobalPrice VARCHAR(10),
#                                               Status      VARCHAR(255),
#                                               Weight      INT,
#                                               Unit        VARCHAR(50),
#                                               ProductName VARCHAR(255),
#                                               ShopCode    VARCHAR(50),
#                                               FullName    VARCHAR(255),
#                                               RouteName   VARCHAR(255)
#     );
#
#
#     IF route_id > 0 THEN
#         SET route_cond = CONCAT(' AND r.id = ', route_id);
#     END IF;
#
#
#     IF start_date IS NOT NULL AND end_date IS NOT NULL THEN
#         SET date_range_cond = CONCAT(' AND sp.createdAt BETWEEN "', start_date, '" AND "', end_date, '"');
#     END IF;
#
#
#     SET @query = CONCAT(
#             'INSERT INTO tmp_price_data (Price, GlobalPrice, Status, Weight, Unit, ProductName, ShopCode, FullName, RouteName)
#              SELECT
#                 sp.price,
#                 CASE WHEN sp.isGlobal = 1 THEN ''Yes'' ELSE ''No'' END AS GlobalPrice,
#                 sp.status,
#                 pv.weight,
#                 pv.unit,
#                 p.name AS ProductName,
#                 s.shopCode,
#                 s.fullName,
#                 r.name AS RouteName
#              FROM tbl_shop_price sp
#              JOIN tbl_product_variant pv ON sp.variantId = pv.id
#              JOIN tbl_product p ON pv.productId = p.id
#              JOIN tbl_shop s ON sp.shopId = s.id
#              JOIN tbl_route r ON s.routeId = r.id
#              WHERE 1=1 ',
#             route_cond, date_range_cond, '
#          ORDER BY sp.isGlobal ASC'
#                  );
#
#
#     PREPARE stmt FROM @query;
#     EXECUTE stmt;
#     DEALLOCATE PREPARE stmt;
#
#     SELECT * FROM tmp_price_data;
#
# END;
