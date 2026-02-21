SELECT 
    c.first_name || ' ' || c.last_name AS client_name,
    tp.package_name,
    b.booking_date,
    b.total_amount,
    b.payment_status
FROM booking b
JOIN client c ON b.client_id = c.client_id
JOIN travel_package tp ON b.package_id = tp.package_id
WHERE b.payment_status = 'Unpaid';