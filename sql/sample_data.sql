-- CLIENTS
INSERT INTO CLIENT (first_name, last_name, email, phone_number, date_of_birth, passport_number, registration_date, loyalty_points)
VALUES
('John', 'Smith', 'john.smith@email.com', '123456789', '1990-05-15', 'P123456', CURRENT_DATE, 120),
('Emma', 'Johnson', 'emma.j@email.com', '987654321', '1988-11-22', 'P654321', CURRENT_DATE, 200),
('Liam', 'Brown', 'liam.b@email.com', '555444333', '1995-02-10', 'P111222', CURRENT_DATE, 50);

-- TRAVEL PACKAGES
INSERT INTO TRAVEL_PACKAGE (package_name, description, price, duration_days, is_active)
VALUES
('Paris Getaway', 'Romantic trip to Paris', 1500.00, 5, TRUE),
('Rome Explorer', 'Historical tour in Rome', 1200.00, 4, TRUE),
('Tokyo Adventure', 'Discover modern Japan', 2200.00, 7, TRUE);

-- DESTINATIONS
INSERT INTO DESTINATION (country, city, description, airport_code)
VALUES
('France', 'Paris', 'City of Light', 'CDG'),
('Italy', 'Rome', 'The Eternal City', 'FCO'),
('Japan', 'Tokyo', 'Modern metropolis', 'HND');

-- ACCOMMODATION
INSERT INTO ACCOMMODATION (type, name, price_per_night, location, description)
VALUES
('Hotel', 'Paris Luxury Hotel', 250.00, 'Paris', '5-star hotel'),
('Hotel', 'Rome Central Hotel', 180.00, 'Rome', 'Close to Colosseum'),
('Hotel', 'Tokyo Grand Hotel', 300.00, 'Tokyo', 'City center luxury');

-- TRANSPORT
INSERT INTO TRANSPORT (type, company, seat_class, duration)
VALUES
('Flight', 'Air France', 'Economy', '08:30'),
('Flight', 'Alitalia', 'Business', '02:00'),
('Flight', 'ANA', 'Economy', '12:00');

-- GUIDE
INSERT INTO GUIDE (name, languages_spoken, years_of_experience, rating)
VALUES
('Pierre Dubois', 'French, English', 10, 4.8),
('Marco Rossi', 'Italian, English', 8, 4.6),
('Yuki Tanaka', 'Japanese, English', 12, 4.9);

-- DESTINATION_PACKAGE
INSERT INTO DESTINATION_PACKAGE (package_id, destination_id, notes)
VALUES
(1, 1, 'Main destination'),
(2, 2, 'Main destination'),
(3, 3, 'Main destination');

-- ACCOMMODATION_PACKAGE
INSERT INTO ACCOMMODATION_PACKAGE (package_id, accommodation_id, notes)
VALUES
(1, 1, 'Luxury stay'),
(2, 2, 'Central hotel'),
(3, 3, 'Premium hotel');

-- TRANSPORT_PACKAGE
INSERT INTO TRANSPORT_PACKAGE (package_id, transport_id, seat_count, notes)
VALUES
(1, 1, 50, 'Direct flight'),
(2, 2, 20, 'Business class option'),
(3, 3, 100, 'International long-haul');

-- GROUP PACKAGE
INSERT INTO GROUP_PACKAGE (number_of_people, guide_included, description, package_id)
VALUES
(15, TRUE, 'Guided Paris Tour', 1);

-- GUIDE_PACKAGE
INSERT INTO GUIDE_PACKAGE (guide_id, group_package_id, notes)
VALUES
(1, 1, 'Lead guide for Paris group');

-- BOOKINGS
INSERT INTO BOOKING (client_id, booking_date, travel_start_date, travel_end_date, status, total_amount, payment_status, package_id)
VALUES
(1, CURRENT_DATE, '2025-06-01', '2025-06-06', 'Confirmed', 1500.00, 'Paid', 1),
(2, CURRENT_DATE, '2025-07-10', '2025-07-14', 'Confirmed', 1200.00, 'Unpaid', 2),
(3, CURRENT_DATE, '2025-08-05', '2025-08-12', 'Pending', 2200.00, 'Unpaid', 3);

-- INVOICES
INSERT INTO INVOICE (booking_id, invoice_date, amount, due_date, status, payment_method)
VALUES
(1, CURRENT_DATE, 1500.00, CURRENT_DATE + INTERVAL '7 days', 'Paid', 'Credit Card'),
(2, CURRENT_DATE, 1200.00, CURRENT_DATE + INTERVAL '7 days', 'Pending', 'Bank Transfer'),
(3, CURRENT_DATE, 2200.00, CURRENT_DATE + INTERVAL '7 days', 'Pending', 'Credit Card');