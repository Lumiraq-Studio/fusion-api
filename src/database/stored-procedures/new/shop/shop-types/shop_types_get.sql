DROP PROCEDURE IF EXISTS shop_types_get;
CREATE PROCEDURE shop_types_get()
BEGIN
    SELECT st.id,
           st.name
    FROM tbl_shop_type st;
    COMMIT;
END;
