SELECT
    package_id,
    package_name,
    total_bookings,
    expected_revenue
FROM v_package_revenue
ORDER BY expected_revenue DESC, package_id;
