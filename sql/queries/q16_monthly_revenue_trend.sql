SELECT
    month,
    bookings,
    booked_revenue,
    collected_revenue,
    mom_change,
    mom_pct,
    running_booked_revenue
FROM v_monthly_revenue
ORDER BY month;
