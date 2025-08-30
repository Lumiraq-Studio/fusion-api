DROP EVENT IF EXISTS event_auto_remove_stock;
CREATE EVENT event_auto_remove_stock
    ON SCHEDULE EVERY 1 DAY
        STARTS TIMESTAMP(CURRENT_DATE + INTERVAL 23 HOUR)
    DO
    CALL auto_remove_stock_new();
