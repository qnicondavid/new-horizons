CREATE TABLE IF NOT EXISTS ACCOMMODATION (
    accommodation_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    price_per_night NUMERIC(10,2) NOT NULL,
    location VARCHAR(100) NOT NULL,
    description VARCHAR(500) NOT NULL,
    CONSTRAINT chk_accommodation_type CHECK (type IN ('Hotel', 'Hostel', 'Resort', 'Apartment', 'Guesthouse', 'Villa')),
    CONSTRAINT chk_accommodation_price CHECK (price_per_night >= 0)
);

CREATE TABLE IF NOT EXISTS CLIENT (
    client_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    date_of_birth DATE,
    passport_number VARCHAR(20),
    registration_date DATE NOT NULL,
    loyalty_points INTEGER NOT NULL,
    CONSTRAINT chk_client_email CHECK (email ~ '^[^@[:space:]]+@[^@[:space:]]+\.[^@[:space:]]+$'),
    CONSTRAINT chk_client_email_lowercase CHECK (email = lower(email)),
    CONSTRAINT chk_client_loyalty CHECK (loyalty_points >= 0),
    CONSTRAINT chk_client_dob CHECK (date_of_birth < registration_date),
    CONSTRAINT uq_client_passport UNIQUE (passport_number)
);

CREATE TABLE IF NOT EXISTS TRAVEL_PACKAGE (
    package_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    package_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    price NUMERIC(10,2) NOT NULL,
    duration_days INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL,
    CONSTRAINT chk_package_price CHECK (price >= 0),
    CONSTRAINT chk_package_duration CHECK (duration_days > 0)
);

CREATE TABLE IF NOT EXISTS DESTINATION (
    destination_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    airport_code CHAR(3),
    CONSTRAINT uq_destination_country_city UNIQUE (country, city)
);

CREATE TABLE IF NOT EXISTS TRANSPORT (
    transport_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    company VARCHAR(50),
    seat_class VARCHAR(30) NOT NULL,
    duration INTERVAL NOT NULL,
    CONSTRAINT chk_transport_seat_class CHECK (seat_class IN ('Economy', 'Premium Economy', 'Business', 'First'))
);

CREATE TABLE IF NOT EXISTS GUIDE (
    guide_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    languages_spoken VARCHAR(200) NOT NULL,
    years_of_experience INTEGER,
    rating NUMERIC(10,2) NOT NULL,
    CONSTRAINT chk_guide_experience CHECK (years_of_experience >= 0),
    CONSTRAINT chk_guide_rating CHECK (rating >= 0 AND rating <= 5)
);

CREATE TABLE IF NOT EXISTS BOOKING (
    booking_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id INTEGER NOT NULL,
    booking_date DATE NOT NULL,
    travel_start_date DATE NOT NULL,
    travel_end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    package_id INTEGER NOT NULL,
    CONSTRAINT chk_booking_status CHECK (status IN ('Pending', 'Confirmed', 'Cancelled', 'Completed')),
    CONSTRAINT chk_booking_payment_status CHECK (payment_status IN ('Paid', 'Unpaid', 'Partial', 'Refunded')),
    CONSTRAINT chk_booking_dates CHECK (travel_end_date >= travel_start_date),
    FOREIGN KEY (client_id) REFERENCES CLIENT(client_id),
    FOREIGN KEY (package_id) REFERENCES TRAVEL_PACKAGE(package_id)
);

CREATE TABLE IF NOT EXISTS INVOICE (
    invoice_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    booking_id INTEGER NOT NULL,
    invoice_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_method VARCHAR(30),
    CONSTRAINT chk_invoice_status CHECK (status IN ('Paid', 'Pending', 'Overdue', 'Cancelled')),
    CONSTRAINT chk_invoice_amount CHECK (amount >= 0),
    CONSTRAINT chk_invoice_due_date CHECK (due_date >= invoice_date),
    CONSTRAINT chk_invoice_payment_method CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash')),
    FOREIGN KEY (booking_id) REFERENCES BOOKING(booking_id)
);

CREATE TABLE IF NOT EXISTS GROUP_PACKAGE (
    group_package_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    number_of_people INTEGER NOT NULL,
    guide_included BOOLEAN NOT NULL,
    description VARCHAR(500),
    package_id INTEGER NOT NULL,
    CONSTRAINT chk_group_people CHECK (number_of_people > 0),
    FOREIGN KEY (package_id) REFERENCES TRAVEL_PACKAGE(package_id)
);

CREATE TABLE IF NOT EXISTS ACCOMMODATION_PACKAGE (
    package_id INTEGER NOT NULL,
    accommodation_id INTEGER NOT NULL,
    notes VARCHAR(500),
    PRIMARY KEY (package_id, accommodation_id),
    FOREIGN KEY (package_id) REFERENCES TRAVEL_PACKAGE(package_id),
    FOREIGN KEY (accommodation_id) REFERENCES ACCOMMODATION(accommodation_id)
);

CREATE TABLE IF NOT EXISTS DESTINATION_PACKAGE (
    package_id INTEGER NOT NULL,
    destination_id INTEGER NOT NULL,
    notes VARCHAR(500),
    PRIMARY KEY (package_id, destination_id),
    FOREIGN KEY (package_id) REFERENCES TRAVEL_PACKAGE(package_id),
    FOREIGN KEY (destination_id) REFERENCES DESTINATION(destination_id)
);

CREATE TABLE IF NOT EXISTS TRANSPORT_PACKAGE (
    package_id INTEGER NOT NULL,
    transport_id INTEGER NOT NULL,
    seat_count INTEGER NOT NULL,
    notes VARCHAR(500),
    CONSTRAINT chk_transport_package_seats CHECK (seat_count > 0),
    PRIMARY KEY (package_id, transport_id),
    FOREIGN KEY (package_id) REFERENCES TRAVEL_PACKAGE(package_id),
    FOREIGN KEY (transport_id) REFERENCES TRANSPORT(transport_id)
);

CREATE TABLE IF NOT EXISTS GUIDE_PACKAGE (
    guide_id INTEGER NOT NULL,
    group_package_id INTEGER NOT NULL,
    notes VARCHAR(500),
    PRIMARY KEY (guide_id, group_package_id),
    FOREIGN KEY (guide_id) REFERENCES GUIDE(guide_id),
    FOREIGN KEY (group_package_id) REFERENCES GROUP_PACKAGE(group_package_id)
);
