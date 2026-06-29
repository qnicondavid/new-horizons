SELECT
    booking_id,
    fn_booking_balance(booking_id) AS outstanding_balance
FROM booking
ORDER BY outstanding_balance DESC
LIMIT 10;
