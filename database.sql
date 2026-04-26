PRAGMA foreign_keys = ON;
-- Rooms Table
CREATE TABLE IF NOT EXISTS Rooms (
    room_number INTEGER PRIMARY KEY,
    capacity INTEGER NOT NULL,
    price_per_night REAL NOT NULL,
    status TEXT CHECK(status IN ('available', 'out_of_service')) NOT NULL,
    info TEXT
);

-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    national_id TEXT UNIQUE NOT NULL,
    contact_number TEXT,
    password TEXT NOT NULL
);

-- Reservations Table
CREATE TABLE IF NOT EXISTS Reservations (
    reservation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER,
    room_number INTEGER,
    reserve_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    enter_date DATE,
    exit_date DATE,
    stay_nights INTEGER,
    FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY(room_number) REFERENCES Rooms(room_number)
);

-- Payments Table
CREATE TABLE IF NOT EXISTS Payments (
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    reservation_id INTEGER,
    payment_time DATETIME,
    amount REAL,
    FOREIGN KEY(reservation_id) REFERENCES Reservations(reservation_id)
);

-- Trigger for auto payment time
CREATE TRIGGER IF NOT EXISTS set_payment_time
AFTER INSERT ON Payments
BEGIN
    UPDATE Payments
    SET payment_time = DATETIME('now')
    WHERE payment_id = NEW.payment_id;
END;