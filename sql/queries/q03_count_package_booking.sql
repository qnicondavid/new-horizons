SELECT 
    tp.package_name,
    COUNT(b.booking_id) AS total_bookings
FROM travel_package tp
LEFT JOIN booking b ON tp.package_id = b.package_id
GROUP BY tp.package_name;