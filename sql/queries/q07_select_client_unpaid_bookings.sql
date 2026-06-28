SELECT
    c.first_name || ' ' || c.last_name AS client_name,
    v.package_name,
    v.booking_date,
    v.total_amount,
    v.payment_status
FROM v_booking_total v
JOIN client c ON v.client_id = c.client_id
WHERE v.payment_status = 'Unpaid';
