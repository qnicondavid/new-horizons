CREATE OR REPLACE VIEW v_monthly_revenue AS
WITH paid AS (
    SELECT booking_id, SUM(amount) AS amount_paid
    FROM invoice
    WHERE status = 'Paid'
    GROUP BY booking_id
),
monthly AS (
    SELECT
        date_trunc('month', b.travel_start_date)::date AS month,
        COUNT(*) FILTER (WHERE b.status <> 'Cancelled') AS bookings,
        COALESCE(SUM(tp.price) FILTER (WHERE b.status <> 'Cancelled'), 0) AS booked_revenue,
        COALESCE(SUM(p.amount_paid) FILTER (WHERE b.status <> 'Cancelled'), 0) AS collected_revenue
    FROM booking b
    JOIN travel_package tp ON tp.package_id = b.package_id
    LEFT JOIN paid p ON p.booking_id = b.booking_id
    GROUP BY date_trunc('month', b.travel_start_date)
)
SELECT
    month,
    bookings,
    booked_revenue,
    collected_revenue,
    booked_revenue - LAG(booked_revenue) OVER (ORDER BY month) AS mom_change,
    ROUND(
        100.0 * (booked_revenue - LAG(booked_revenue) OVER (ORDER BY month))
        / NULLIF(LAG(booked_revenue) OVER (ORDER BY month), 0), 1
    ) AS mom_pct,
    SUM(booked_revenue) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_booked_revenue
FROM monthly;

CREATE OR REPLACE VIEW v_client_ltv AS
WITH paid AS (
    SELECT booking_id, SUM(amount) AS amount_paid
    FROM invoice
    WHERE status = 'Paid'
    GROUP BY booking_id
),
per_client AS (
    SELECT
        c.client_id,
        c.first_name || ' ' || c.last_name AS client_name,
        c.registration_date,
        COUNT(b.booking_id) FILTER (WHERE b.status <> 'Cancelled') AS total_bookings,
        COALESCE(SUM(tp.price) FILTER (WHERE b.status <> 'Cancelled'), 0) AS total_booked_value,
        COALESCE(SUM(p.amount_paid) FILTER (WHERE b.status <> 'Cancelled'), 0) AS total_collected,
        MIN(b.travel_start_date) FILTER (WHERE b.status <> 'Cancelled') AS first_trip,
        MAX(b.travel_start_date) FILTER (WHERE b.status <> 'Cancelled') AS last_trip
    FROM client c
    LEFT JOIN booking b ON b.client_id = c.client_id
    LEFT JOIN travel_package tp ON tp.package_id = b.package_id
    LEFT JOIN paid p ON p.booking_id = b.booking_id
    GROUP BY c.client_id, c.first_name, c.last_name, c.registration_date
)
SELECT
    client_id,
    client_name,
    total_bookings,
    total_booked_value,
    total_collected,
    CASE WHEN total_bookings > 0 THEN ROUND(total_booked_value / total_bookings, 2) END AS avg_trip_value,
    first_trip,
    last_trip,
    NTILE(4) OVER (ORDER BY total_collected DESC) AS value_quartile,
    RANK() OVER (ORDER BY total_collected DESC) AS collected_rank
FROM per_client;
