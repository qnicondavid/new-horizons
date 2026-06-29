CREATE INDEX IF NOT EXISTS idx_booking_client_id ON booking(client_id);
CREATE INDEX IF NOT EXISTS idx_booking_package_id ON booking(package_id);
CREATE INDEX IF NOT EXISTS idx_invoice_booking_id ON invoice(booking_id);
CREATE INDEX IF NOT EXISTS idx_group_package_package_id ON group_package(package_id);
CREATE INDEX IF NOT EXISTS idx_guide_package_group_package_id ON guide_package(group_package_id);
CREATE INDEX IF NOT EXISTS idx_invoice_paid_booking ON invoice(booking_id) WHERE status = 'Paid';
