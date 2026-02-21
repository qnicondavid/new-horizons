SELECT 
    tp.package_name,
    COALESCE(SUM(b.total_amount), 0) AS expected_revenue
FROM travel_package tp
LEFT JOIN booking b ON tp.package_id = b.package_id
GROUP BY tp.package_name
ORDER BY expected_revenue DESC;