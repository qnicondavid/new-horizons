SELECT
    client_id,
    client_name,
    total_bookings,
    total_collected,
    avg_trip_value,
    value_quartile,
    last_trip
FROM v_client_ltv
ORDER BY total_collected DESC, client_id
LIMIT 20;
