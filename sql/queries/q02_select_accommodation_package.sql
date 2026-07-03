SELECT
    tp.package_id,
    tp.package_name,
    tp.price,
    acc.accommodations,
    dst.destinations,
    trn.transports
FROM travel_package tp
LEFT JOIN (
    SELECT ap.package_id,
           string_agg(DISTINCT a.name, ', ' ORDER BY a.name) AS accommodations
    FROM accommodation_package ap
    JOIN accommodation a ON a.accommodation_id = ap.accommodation_id
    GROUP BY ap.package_id
) acc ON acc.package_id = tp.package_id
LEFT JOIN (
    SELECT dp.package_id,
           string_agg(DISTINCT d.city, ', ' ORDER BY d.city) AS destinations
    FROM destination_package dp
    JOIN destination d ON d.destination_id = dp.destination_id
    GROUP BY dp.package_id
) dst ON dst.package_id = tp.package_id
LEFT JOIN (
    SELECT tpk.package_id,
           string_agg(DISTINCT t.type, ', ' ORDER BY t.type) AS transports
    FROM transport_package tpk
    JOIN transport t ON t.transport_id = tpk.transport_id
    GROUP BY tpk.package_id
) trn ON trn.package_id = tp.package_id
ORDER BY tp.package_id;
