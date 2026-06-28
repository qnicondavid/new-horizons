SELECT
    tp.package_name,
    COALESCE(SUM(v.total_amount), 0) AS expected_revenue
FROM travel_package tp
LEFT JOIN v_booking_total v ON tp.package_id = v.package_id
GROUP BY tp.package_name
ORDER BY expected_revenue DESC;
