DROP PROCEDURE IF EXISTS customer_screen;
CREATE PROCEDURE customer_screen(
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


    SELECT

        (SELECT COUNT(*) FROM tbl_shop WHERE status = 'active') AS totalShops,

        (SELECT COUNT(*)
            FROM tbl_shop
            WHERE createdAt >= DATE_FORMAT(CURRENT_DATE, '%Y-%m-01')
              AND status = 'active')AS newThisMonth,

        (SELECT ROUND(COUNT(*) / (SELECT COUNT(*) FROM tbl_shop WHERE status = 'active') * 100, 2)
            FROM tbl_shop
            WHERE status = 'active')AS activePercentage,

        (SELECT ROUND(COUNT(*) / (SELECT COUNT(*) FROM tbl_shop WHERE status = 'active') * 100, 2)
            FROM tbl_shop
            WHERE status = 'inactive')AS inactivePercentage;

END;

