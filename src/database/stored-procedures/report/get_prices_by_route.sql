DROP PROCEDURE IF EXISTS price_by_route_id;
CREATE PROCEDURE price_by_route_id(
    IN route_id INT
)
BEGIN
    SELECT r.name                                AS RouteName,
           s.fullName                            AS FullName,
           s.shopCode                            AS ShopCode,
           COALESCE(p.name, '-')                 AS productName,
           COALESCE(sp.price, '-')               AS Price,
           COALESCE(sp.status, '-')              AS status,
           COALESCE(pv.basePrice, '-')           AS GlobalPrice,
           COALESCE(pv.weight, '-')              AS Weight,
           COALESCE(pv.unit, '-')                AS Unit,
           COALESCE(DATE_FORMAT(sp.createdAt, '%Y-%m-%d'), '-') AS CreateDate
    FROM tbl_shop s
             JOIN tbl_route r ON s.routeId = r.id
             LEFT JOIN tbl_shop_price sp ON s.id = sp.shopId
             LEFT JOIN tbl_product_variant pv ON sp.variantId = pv.id
             LEFT JOIN tbl_product p ON pv.productId = p.id
    WHERE r.id = route_id;


END
