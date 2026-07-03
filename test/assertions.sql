-- Assertion suite: fails loud (raises) on any broken invariant; run after run_all.sql.
DO $$ BEGIN ASSERT (SELECT count(*) FROM client) = 120, 'client count must be 120'; RAISE NOTICE 'PASS: client count = 120'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM booking) = 500, 'booking count must be 500'; RAISE NOTICE 'PASS: booking count = 500'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM invoice) = 649, 'invoice count must be 649'; RAISE NOTICE 'PASS: invoice count = 649'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM travel_package) = 30, 'package count must be 30'; RAISE NOTICE 'PASS: package count = 30'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM group_package) = 50, 'group_package count must be 50'; RAISE NOTICE 'PASS: group_package count = 50'; END $$;

DO $$ BEGIN ASSERT (SELECT count(*) FROM v_dq_invoice_before_booking) = 0, 'no invoice may predate its booking'; RAISE NOTICE 'PASS: 0 invoices before booking'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM v_dq_guide_flag_mismatch) = 0, 'guide_included must match guide links'; RAISE NOTICE 'PASS: 0 guide_included mismatches'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM v_dq_overpaid_booking) = 0, 'no active booking may be overpaid'; RAISE NOTICE 'PASS: 0 overpaid active bookings'; END $$;

DO $$ BEGIN ASSERT (SELECT count(*) FROM v_booking_billing v WHERE v.balance IS DISTINCT FROM fn_booking_balance(v.booking_id)) = 0, 'fn_booking_balance must equal v_booking_billing.balance'; RAISE NOTICE 'PASS: fn == view balance (single source of truth)'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM v_booking_billing) = (SELECT count(DISTINCT booking_id) FROM v_booking_billing), 'v_booking_billing must not fan out'; RAISE NOTICE 'PASS: v_booking_billing no fan-out'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM v_booking_billing WHERE balance < 0) = 0, 'balance must never be negative'; RAISE NOTICE 'PASS: no negative balance'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM v_booking_billing WHERE balance > 0 AND refund_due > 0) = 0, 'balance and refund_due are mutually exclusive'; RAISE NOTICE 'PASS: balance/refund_due mutually exclusive'; END $$;
DO $$ BEGIN ASSERT (SELECT count(*) FROM v_booking_billing vb JOIN booking b ON b.booking_id=vb.booking_id WHERE b.status='Cancelled' AND vb.amount_due <> 0) = 0, 'cancelled bookings owe nothing'; RAISE NOTICE 'PASS: cancelled bookings amount_due = 0'; END $$;

DO $$ BEGIN ASSERT (SELECT count(*) FROM travel_package tp JOIN group_package gp ON tp.package_id=gp.package_id WHERE gp.guide_included=TRUE) = 50, 'q12 guided groups must be 50'; RAISE NOTICE 'PASS: 50 guided groups'; END $$;

DO $$ DECLARE last_run NUMERIC; total NUMERIC; BEGIN
  SELECT running_booked_revenue INTO last_run FROM v_monthly_revenue ORDER BY month DESC LIMIT 1;
  SELECT SUM(booked_revenue) INTO total FROM v_monthly_revenue;
  ASSERT last_run = total, 'monthly running total must equal grand total';
  RAISE NOTICE 'PASS: v_monthly_revenue running total reconciles (%)', total;
END $$;
DO $$ BEGIN ASSERT (SELECT count(DISTINCT value_quartile) FROM v_client_ltv) = 4 AND (SELECT min(cnt)=max(cnt) FROM (SELECT count(*) cnt FROM v_client_ltv GROUP BY value_quartile) q), 'NTILE must yield 4 equal quartiles'; RAISE NOTICE 'PASS: v_client_ltv quartiles balanced'; END $$;
DO $$ BEGIN ASSERT (SELECT SUM(total_collected) FROM v_client_ltv) = (SELECT COALESCE(SUM(i.amount),0) FROM invoice i JOIN booking b ON b.booking_id=i.booking_id WHERE i.status='Paid' AND b.status<>'Cancelled'), 'CLV collected must reconcile to non-cancelled paid invoices'; RAISE NOTICE 'PASS: CLV collected reconciles'; END $$;
