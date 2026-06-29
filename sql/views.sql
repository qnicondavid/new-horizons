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

CREATE VIEW v_package_revenue AS
SELECT
    tp.package_id,
    tp.package_name,
    COUNT(b.booking_id) AS total_bookings,
    COALESCE(SUM(tp.price) FILTER (WHERE b.booking_id IS NOT NULL), 0) AS expected_revenue
FROM travel_package tp
LEFT JOIN booking b ON tp.package_id = b.package_id
GROUP BY tp.package_id, tp.package_name;

CREATE VIEW v_client_summary AS
SELECT
    c.client_id,
    c.first_name || ' ' || c.last_name AS client_name,
    c.loyalty_points,
    COUNT(b.booking_id) AS total_bookings,
    COALESCE(SUM(tp.price), 0) AS total_spend
FROM client c
LEFT JOIN booking b ON c.client_id = b.client_id
LEFT JOIN travel_package tp ON b.package_id = tp.package_id
GROUP BY c.client_id, c.first_name, c.last_name, c.loyalty_points;

CREATE VIEW v_booking_billing AS
SELECT
    b.booking_id,
    tp.package_name,
    tp.price AS amount_due,
    COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0) AS amount_paid,
    tp.price - COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0) AS balance,
    b.payment_status
FROM booking b
JOIN travel_package tp ON b.package_id = tp.package_id
LEFT JOIN invoice i ON i.booking_id = b.booking_id
GROUP BY b.booking_id, tp.package_name, tp.price, b.payment_status;
