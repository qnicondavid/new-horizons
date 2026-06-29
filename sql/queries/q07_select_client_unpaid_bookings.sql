SELECT
    c.first_name || ' ' || c.last_name AS client_name,
    vb.package_name,
    vb.amount_due,
    vb.amount_paid,
    vb.balance,
    vb.payment_status
FROM v_booking_billing vb
JOIN booking b ON b.booking_id = vb.booking_id
JOIN client c ON c.client_id = b.client_id
WHERE vb.balance > 0
ORDER BY vb.balance DESC, vb.booking_id;
