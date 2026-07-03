SELECT
    tp.package_name,
    tp.price,
    COUNT(b.booking_id) FILTER (WHERE b.status <> 'Cancelled') AS total_bookings
FROM travel_package tp
LEFT JOIN booking b ON tp.package_id = b.package_id
WHERE tp.price = (SELECT MAX(price) FROM travel_package)
GROUP BY tp.package_id, tp.package_name, tp.price
ORDER BY tp.package_id;
