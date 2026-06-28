CREATE VIEW v_booking_total AS
SELECT
    b.booking_id,
    b.client_id,
    b.package_id,
    tp.package_name,
    b.booking_date,
    b.travel_start_date,
    b.travel_end_date,
    b.status,
    b.payment_status,
    tp.price AS total_amount
FROM booking b
JOIN travel_package tp ON b.package_id = tp.package_id;
