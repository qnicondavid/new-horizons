SELECT
    g.name AS guide_name,
    gp.group_package_id,
    gp.number_of_people,
    tp.package_name
FROM guide_package gpk
JOIN guide g ON gpk.guide_id = g.guide_id
JOIN group_package gp ON gpk.group_package_id = gp.group_package_id
JOIN travel_package tp ON gp.package_id = tp.package_id
ORDER BY gp.group_package_id;
