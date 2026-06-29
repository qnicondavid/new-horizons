SELECT
    SUM(amount) AS total_revenue,
    COUNT(invoice_id) AS total_invoices,
    status
FROM invoice
GROUP BY status;
