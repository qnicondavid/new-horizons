SELECT
    g.name AS guide_name,
    COUNT(gp.group_package_id) AS groups_led
FROM guide g
LEFT JOIN guide_package gpk ON g.guide_id = gpk.guide_id
LEFT JOIN group_package gp ON gpk.group_package_id = gp.group_package_id
GROUP BY g.guide_id, g.name
ORDER BY groups_led DESC, guide_name;
