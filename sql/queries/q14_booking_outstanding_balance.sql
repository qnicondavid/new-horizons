SELECT
    booking_id,
    balance AS outstanding_balance
FROM v_booking_billing
ORDER BY balance DESC, booking_id
LIMIT 10;
