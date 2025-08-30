DROP PROCEDURE IF EXISTS user_get;
CREATE PROCEDURE user_get(
    IN user_id INT
)
BEGIN
    SELECT tu.id          AS userId,
           tu.fullName    AS fullName,
           tu.nic         AS nic,
           tu.email       AS email,
           tu.status      AS status,
           tu.phoneNumber AS phoneNumber,
           tu.designation AS designation,
           tu.createdAt   AS joinDate

    FROM tbl_user tu
    WHERE tu.id = user_id;
END
