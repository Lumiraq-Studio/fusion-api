DROP PROCEDURE IF EXISTS route_get;
CREATE PROCEDURE route_get(
    IN route_id INT
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

        SELECT r.id                        AS routeId,
               r.name                      AS routeName,
               r.area                      AS routeDescription,
               (SELECT JSON_ARRAYAGG(
                               JSON_OBJECT(
                                       'shopId', s.id,
                                       'shopCode', s.shopCode,
                                       'fullName', s.fullName,
                                       'shortName', s.shortName,
                                       'mobile', s.mobile,
                                       'address', s.address
                               )
                       )
                FROM tbl_shop s
                WHERE (s.routeId = r.id OR s.routeId = 11)
                  AND s.status = 'active') AS shops
        FROM tbl_route r
        WHERE r.id = route_id;

    COMMIT;
END;
