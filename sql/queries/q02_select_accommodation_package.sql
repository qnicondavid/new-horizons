SELECT
    tp.package_name,
    a.name AS accommodation_name,
    d.city AS destination_city,
    t.type AS transport_type,
    tp.price
FROM travel_package tp
LEFT JOIN accommodation_package ap ON tp.package_id = ap.package_id
LEFT JOIN accommodation a ON ap.accommodation_id = a.accommodation_id
LEFT JOIN destination_package dp ON tp.package_id = dp.package_id
LEFT JOIN destination d ON dp.destination_id = d.destination_id
LEFT JOIN transport_package tpkg ON tp.package_id = tpkg.package_id
LEFT JOIN transport t ON tpkg.transport_id = t.transport_id
ORDER BY tp.package_id;
