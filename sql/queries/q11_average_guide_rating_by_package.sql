SELECT
    package_id,
    package_name,
    AVG(rating) AS avg_guide_rating
FROM (
    SELECT DISTINCT
        tp.package_id,
        tp.package_name,
        g.guide_id,
        g.rating
    FROM travel_package tp
    JOIN group_package gp ON tp.package_id = gp.package_id
    JOIN guide_package gpk ON gp.group_package_id = gpk.group_package_id
    JOIN guide g ON gpk.guide_id = g.guide_id
) dg
GROUP BY package_id, package_name
ORDER BY avg_guide_rating DESC NULLS LAST, package_id;
