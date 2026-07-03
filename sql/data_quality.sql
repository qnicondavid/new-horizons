CREATE OR REPLACE VIEW v_dq_invoice_before_booking AS
SELECT i.invoice_id, i.booking_id, i.invoice_date, b.booking_date
FROM invoice i
JOIN booking b ON b.booking_id = i.booking_id
WHERE i.invoice_date < b.booking_date;

CREATE OR REPLACE VIEW v_dq_guide_flag_mismatch AS
SELECT gp.group_package_id, gp.guide_included,
       EXISTS (SELECT 1 FROM guide_package k WHERE k.group_package_id = gp.group_package_id) AS has_guide_link
FROM group_package gp
WHERE gp.guide_included <> EXISTS (SELECT 1 FROM guide_package k WHERE k.group_package_id = gp.group_package_id);

CREATE OR REPLACE VIEW v_dq_overpaid_booking AS
SELECT b.booking_id, tp.price AS package_price,
       COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0) AS paid_amount
FROM booking b
JOIN travel_package tp ON tp.package_id = b.package_id
LEFT JOIN invoice i ON i.booking_id = b.booking_id
WHERE b.status <> 'Cancelled'
GROUP BY b.booking_id, tp.price
HAVING COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0) > tp.price;

CREATE OR REPLACE VIEW v_dq_refunded_with_paid_invoice AS
SELECT b.booking_id, b.payment_status,
       COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0) AS paid_amount
FROM booking b
LEFT JOIN invoice i ON i.booking_id = b.booking_id
WHERE b.payment_status = 'Refunded'
GROUP BY b.booking_id, b.payment_status
HAVING COALESCE(SUM(i.amount) FILTER (WHERE i.status = 'Paid'), 0) > 0;

CREATE OR REPLACE VIEW v_dq_uninvoiced_active_booking AS
SELECT b.booking_id, b.client_id, b.status
FROM booking b
WHERE b.status IN ('Confirmed', 'Completed')
  AND NOT EXISTS (SELECT 1 FROM invoice i WHERE i.booking_id = b.booking_id);

CREATE OR REPLACE VIEW v_dq_overlapping_client_bookings AS
SELECT b1.client_id, b1.booking_id AS booking_a, b2.booking_id AS booking_b
FROM booking b1
JOIN booking b2 ON b2.client_id = b1.client_id AND b1.booking_id < b2.booking_id
WHERE b1.status <> 'Cancelled' AND b2.status <> 'Cancelled'
  AND daterange(b1.travel_start_date, b1.travel_end_date, '[]')
   && daterange(b2.travel_start_date, b2.travel_end_date, '[]');
