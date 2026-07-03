SELECT 'invoices dated before booking' AS data_quality_check, COUNT(*) AS records FROM v_dq_invoice_before_booking
UNION ALL SELECT 'guide_included flag mismatch', COUNT(*) FROM v_dq_guide_flag_mismatch
UNION ALL SELECT 'overpaid active bookings', COUNT(*) FROM v_dq_overpaid_booking
UNION ALL SELECT 'refunded bookings with paid invoices', COUNT(*) FROM v_dq_refunded_with_paid_invoice
UNION ALL SELECT 'active bookings with no invoice', COUNT(*) FROM v_dq_uninvoiced_active_booking
UNION ALL SELECT 'overlapping client bookings', COUNT(*) FROM v_dq_overlapping_client_bookings
ORDER BY data_quality_check;
