SELECT
    b.booking_id,
    GREATEST(tp.price - COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0), 0) AS outstanding_balance
FROM booking b
JOIN travel_package tp ON b.package_id = tp.package_id
LEFT JOIN invoice i ON i.booking_id = b.booking_id
GROUP BY b.booking_id, tp.price
ORDER BY outstanding_balance DESC NULLS LAST, b.booking_id
LIMIT 10;
