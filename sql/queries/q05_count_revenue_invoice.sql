SELECT
    status,
    COUNT(invoice_id) AS invoice_count,
    SUM(amount) AS invoiced_amount
FROM invoice
GROUP BY status
ORDER BY status;
