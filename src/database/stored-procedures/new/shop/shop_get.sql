DROP PROCEDURE IF EXISTS shop_data_get;
CREATE PROCEDURE shop_data_get(
    IN shop_id INT
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

    SELECT s.id        AS id,
           s.shopCode  AS cRef,
           s.fullName  AS fullName,
           s.shortName AS shortName,
           s.address   AS address,
           s.mobile    AS mobile,
           s.status    AS status,
           tr.id       AS routeId,
           tr.name     AS routeName,
           st.name     AS shopTypeName,
           st.id       AS shopTypeId,
           tr.area     AS routeArea
    FROM tbl_shop s
             INNER JOIN tbl_shop_type st ON s.shopTypeId = st.id
             INNER JOIN tbl_route tr on tr.id = s.routeId
    WHERE s.id = shop_id;
    COMMIT;
END;
