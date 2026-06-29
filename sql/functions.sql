CREATE FUNCTION fn_booking_balance(p_booking_id INTEGER)
RETURNS NUMERIC
LANGUAGE sql
STABLE
AS $$
    SELECT tp.price - COALESCE(
        (SELECT SUM(i.amount) FROM invoice i
         WHERE i.booking_id = p_booking_id AND i.status = 'Paid'), 0)
    FROM booking b
    JOIN travel_package tp ON b.package_id = tp.package_id
    WHERE b.booking_id = p_booking_id;
$$;
