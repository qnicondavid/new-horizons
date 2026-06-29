SELECT
    booking_id,
    fn_booking_balance(booking_id) AS outstanding_balance
FROM booking
WHERE booking_id = 1;
