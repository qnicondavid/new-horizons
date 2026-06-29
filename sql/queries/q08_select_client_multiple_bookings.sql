SELECT
    c.first_name || ' ' || c.last_name AS client_name,
    COUNT(b.booking_id) AS bookings_count
FROM client c
JOIN booking b ON c.client_id = b.client_id
GROUP BY c.client_id, c.first_name, c.last_name
HAVING COUNT(b.booking_id) > 1;
