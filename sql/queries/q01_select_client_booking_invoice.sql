SELECT
    v.booking_id,
    c.first_name || ' ' || c.last_name AS client_name,
    v.package_name,
    v.booking_date,
    v.travel_start_date,
    v.travel_end_date,
    v.status,
    v.total_amount,
    v.payment_status
FROM v_booking_total v
JOIN client c ON v.client_id = c.client_id;
