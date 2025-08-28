DROP PROCEDURE IF EXISTS sales_rep_get;
CREATE PROCEDURE sales_rep_get(
    IN rep_id INT
)
BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @message_text = MESSAGE_TEXT;
            SELECT CONCAT('Error: [', @sqlstate, '] ', @message_text) AS error_message;
        END;

    START TRANSACTION;

    SELECT tsr.id,
           tsr.name,
           tsr.contactDetails,
           tsr.status,
           (SELECT JSON_OBJECT(
                           'userId', tu.id,
                           'role', tu.designation,
                           'mobile', tu.phoneNumber,
                           'fullName', tu.fullName,
                           'nic', tu.nic,
                           'status', tu.status,
                           'email', tu.email,
                           'phoneNumber', tu.phoneNumber
                   ) AS json_result
            FROM tbl_user tu
            WHERE tu.id = tsr.userId) AS 'user'
    FROM tbl_sales_rep tsr
    WHERE tsr.id = rep_id;

END;