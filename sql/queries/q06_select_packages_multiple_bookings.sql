SELECT
    tp.package_id,
    tp.package_name,
    COUNT(b.booking_id) FILTER (WHERE b.status <> 'Cancelled') AS bookings_count
FROM travel_package tp
JOIN booking b ON tp.package_id = b.package_id
GROUP BY tp.package_id, tp.package_name
HAVING COUNT(b.booking_id) FILTER (WHERE b.status <> 'Cancelled') > 1
ORDER BY bookings_count DESC, tp.package_id;
