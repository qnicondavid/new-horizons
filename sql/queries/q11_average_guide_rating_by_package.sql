SELECT 
    tp.package_name,
    AVG(g.rating) AS avg_guide_rating
FROM travel_package tp
JOIN group_package gp ON tp.package_id = gp.package_id
JOIN guide_package gpk ON gp.group_package_id = gpk.group_package_id
JOIN guide g ON gpk.guide_id = g.guide_id
GROUP BY tp.package_name
ORDER BY avg_guide_rating DESC;