SELECT
    c.first_name || ' ' || c.last_name AS client_name,
    vb.booking_id,
    vb.package_name,
    vb.amount_due,
    vb.amount_paid,
    vb.balance,
    vb.payment_status
FROM v_booking_billing vb
JOIN client c ON c.client_id = vb.client_id
WHERE vb.balance > 0
ORDER BY vb.balance DESC, vb.booking_id;
