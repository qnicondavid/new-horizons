SELECT 
    tp.package_name,
    COUNT(b.booking_id) AS bookings_count
FROM travel_package tp
JOIN booking b ON tp.package_id = b.package_id
GROUP BY tp.package_name
HAVING COUNT(b.booking_id) > 1; 