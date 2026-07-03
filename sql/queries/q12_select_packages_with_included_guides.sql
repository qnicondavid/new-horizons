SELECT
    tp.package_name,
    gp.group_package_id,
    gp.number_of_people
FROM travel_package tp
JOIN group_package gp ON tp.package_id = gp.package_id
WHERE gp.guide_included = TRUE
ORDER BY tp.package_id, gp.group_package_id;
