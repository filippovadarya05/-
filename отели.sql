CREATE DATABASE IF NOT EXISTS hotel_bookings;
USE hotel_bookings;

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS hotels;
DROP TABLE IF EXISTS room_types;
DROP TABLE IF EXISTS meal_types;
DROP TABLE IF EXISTS booking_channels;
DROP TABLE IF EXISTS market_segments;
DROP TABLE IF EXISTS countries;

CREATE TABLE countries (
    country_code VARCHAR(3) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

CREATE TABLE hotels (
    hotel_code VARCHAR(4) PRIMARY KEY,
    hotel_name VARCHAR(150) NOT NULL,
    hotel_type VARCHAR(50) NOT NULL,
    hotel_address VARCHAR(200) NOT NULL
);

CREATE TABLE room_types (
    room_type_code VARCHAR(2) PRIMARY KEY,
    room_type_name VARCHAR(100) NOT NULL
);

CREATE TABLE meal_types (
    meal_type_code VARCHAR(2) PRIMARY KEY,
    meal_type_name VARCHAR(100) NOT NULL
);

CREATE TABLE booking_channels (
    channel_code VARCHAR(2) PRIMARY KEY,
    channel_name VARCHAR(100) NOT NULL
);

CREATE TABLE market_segments (
    segment_code VARCHAR(2) PRIMARY KEY,
    segment_name VARCHAR(100) NOT NULL
);

CREATE TABLE clients (
    client_code VARCHAR(6) PRIMARY KEY,
    client_full_name VARCHAR(150) NOT NULL,
    country_code VARCHAR(3) NOT NULL,
    CONSTRAINT fk_clients_countries FOREIGN KEY (country_code)
        REFERENCES countries(country_code)
);

CREATE TABLE bookings (
    hotel_code VARCHAR(4) NOT NULL,
    client_code VARCHAR(6) NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    room_type_code VARCHAR(2) NOT NULL,
    meal_type_code VARCHAR(2) NOT NULL,
    channel_code VARCHAR(2) NOT NULL,
    segment_code VARCHAR(2) NOT NULL,
    adults_count INT NOT NULL CHECK (adults_count >= 0),
    children_count INT NOT NULL DEFAULT 0 CHECK (children_count >= 0),
    infants_count INT NOT NULL DEFAULT 0 CHECK (infants_count >= 0),
    nights_count INT NOT NULL CHECK (nights_count >= 0),
    weekend_nights_count INT NOT NULL DEFAULT 0 CHECK (weekend_nights_count >= 0),
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night >= 0),
    booking_status VARCHAR(20) NOT NULL,
    payment_amount DECIMAL(12,2) NOT NULL CHECK (payment_amount >= 0),
    PRIMARY KEY (hotel_code, client_code, check_in_date, check_out_date),
    CONSTRAINT fk_bookings_hotels FOREIGN KEY (hotel_code)
        REFERENCES hotels(hotel_code),
    CONSTRAINT fk_bookings_clients FOREIGN KEY (client_code)
        REFERENCES clients(client_code),
    CONSTRAINT fk_bookings_room_types FOREIGN KEY (room_type_code)
        REFERENCES room_types(room_type_code),
    CONSTRAINT fk_bookings_meal_types FOREIGN KEY (meal_type_code)
        REFERENCES meal_types(meal_type_code),
    CONSTRAINT fk_bookings_channels FOREIGN KEY (channel_code)
        REFERENCES booking_channels(channel_code),
    CONSTRAINT fk_bookings_segments FOREIGN KEY (segment_code)
        REFERENCES market_segments(segment_code)
);

ALTER TABLE bookings ADD COLUMN notes TEXT;
ALTER TABLE clients ADD COLUMN email VARCHAR(100);
ALTER TABLE clients ADD COLUMN phone VARCHAR(20);

INSERT INTO countries (country_code, country_name) VALUES
('643', 'Россия'),
('398', 'Казахстан'),
('112', 'Беларусь'),
('276', 'Германия'),
('250', 'Франция');

INSERT INTO hotels (hotel_code, hotel_name, hotel_type, hotel_address) VALUES
('0001', 'Гранд', 'City Hotel', 'г. Москва, ул. Тверская, 1'),
('0002', 'Приморский', 'Resort Hotel', 'г. Сочи, ул. Морская, 15'),
('0003', 'Горный воздух', 'Resort Hotel', 'г. Кисловодск, пр. Победы, 8');

INSERT INTO room_types (room_type_code, room_type_name) VALUES
('01', 'Стандарт'),
('02', 'Комфорт'),
('03', 'Люкс'),
('04', 'Апартаменты');

INSERT INTO meal_types (meal_type_code, meal_type_name) VALUES
('01', 'BB (завтрак)'),
('02', 'HB (полупансион)'),
('03', 'FB (полный пансион)'),
('04', 'SC (без питания)');

INSERT INTO booking_channels (channel_code, channel_name) VALUES
('01', 'Direct'),
('02', 'Corporate'),
('03', 'Online TA'),
('04', 'Offline TA/TO'),
('05', 'Groups');

INSERT INTO market_segments (segment_code, segment_name) VALUES
('01', 'Online'),
('02', 'Offline'),
('03', 'Corporate'),
('04', 'Complementary'),
('05', 'Groups');

INSERT INTO clients (client_code, client_full_name, country_code, email, phone) VALUES
('000001', 'Иванов Иван', '643', 'ivanov@mail.ru', '+7-916-111-22-33'),
('000002', 'Петров Петр', '398', 'petrov@mail.ru', '+7-916-222-33-44'),
('000003', 'Сидорова Анна', '112', 'sidorova@mail.ru', '+7-916-333-44-55'),
('000004', 'Мюллер Ханс', '276', 'muller@mail.de', '+49-151-222-33-44'),
('000005', 'Дюпон Пьер', '250', 'dupont@mail.fr', '+33-6-11-22-33-44');

INSERT INTO bookings
(hotel_code, client_code, check_in_date, check_out_date,
 room_type_code, meal_type_code, channel_code, segment_code,
 adults_count, children_count, infants_count,
 nights_count, weekend_nights_count, price_per_night,
 booking_status, payment_amount) VALUES
('0001', '000001', '2025-01-15', '2025-01-20', '01', '01', '01', '01',
 2, 0, 0, 5, 2, 500.00, 'Подтверждено', 2500.00),
('0001', '000002', '2025-02-10', '2025-02-14', '02', '02', '03', '01',
 1, 1, 0, 4, 1, 750.00, 'Подтверждено', 3000.00),
('0002', '000003', '2025-03-05', '2025-03-12', '03', '03', '02', '03',
 2, 1, 0, 7, 2, 1200.00, 'Подтверждено', 8400.00),
('0002', '000004', '2025-04-20', '2025-04-25', '04', '01', '04', '02',
 1, 0, 1, 5, 2, 1500.00, 'Отменено', 0.00),
('0003', '000005', '2025-05-01', '2025-05-08', '02', '02', '05', '05',
 3, 2, 0, 7, 3, 800.00, 'Подтверждено', 5600.00),
('0001', '000003', '2025-06-15', '2025-06-18', '01', '04', '01', '02',
 1, 0, 0, 3, 0, 500.00, 'Отменено', 0.00),
('0003', '000001', '2025-07-10', '2025-07-15', '03', '02', '03', '01',
 2, 1, 0, 5, 3, 1100.00, 'Подтверждено', 5500.00),
('0002', '000005', '2025-08-01', '2025-08-10', '04', '03', '02', '03',
 4, 2, 1, 9, 4, 1600.00, 'Подтверждено', 14400.00);

UPDATE bookings SET booking_status = 'Завершено'
WHERE check_out_date < CURRENT_DATE AND booking_status = 'Подтверждено';

DELETE FROM bookings WHERE booking_status = 'Отменено' AND payment_amount = 0;

CREATE USER IF NOT EXISTS 'hotel_manager'@'localhost' IDENTIFIED BY 'ManagerPass123!';
CREATE USER IF NOT EXISTS 'hotel_analyst'@'localhost' IDENTIFIED BY 'AnalystPass123!';
CREATE USER IF NOT EXISTS 'hotel_admin'@'localhost' IDENTIFIED BY 'AdminPass123!';

GRANT SELECT, INSERT, UPDATE ON hotel_bookings.* TO 'hotel_manager'@'localhost';
GRANT SELECT ON hotel_bookings.* TO 'hotel_analyst'@'localhost';
GRANT ALL PRIVILEGES ON hotel_bookings.* TO 'hotel_admin'@'localhost';

FLUSH PRIVILEGES;

DESCRIBE hotels;
DESCRIBE clients;
DESCRIBE bookings;

SELECT c.client_full_name, b.hotel_code, b.check_in_date, b.payment_amount
FROM clients c, bookings b
WHERE c.client_code = b.client_code AND b.booking_status = 'Подтверждено'
ORDER BY b.check_in_date ASC;

SELECT h.hotel_name, rt.room_type_name, mt.meal_type_name, ch.channel_name,
       b.check_in_date, b.check_out_date, b.payment_amount
FROM bookings b
INNER JOIN hotels h ON b.hotel_code = h.hotel_code
INNER JOIN room_types rt ON b.room_type_code = rt.room_type_code
INNER JOIN meal_types mt ON b.meal_type_code = mt.meal_type_code
INNER JOIN booking_channels ch ON b.channel_code = ch.channel_code
ORDER BY h.hotel_name, b.check_in_date;

SELECT h.hotel_name, COUNT(*) AS bookings_count,
       SUM(b.payment_amount) AS total_revenue,
       AVG(b.price_per_night) AS avg_price_per_night,
       MAX(b.payment_amount) AS max_payment,
       MIN(b.payment_amount) AS min_payment
FROM bookings b
INNER JOIN hotels h ON b.hotel_code = h.hotel_code
WHERE b.booking_status = 'Подтверждено'
GROUP BY h.hotel_name
HAVING SUM(b.payment_amount) > 3000.00
ORDER BY total_revenue DESC;

SELECT c.client_full_name
FROM clients c
WHERE c.client_code IN (
    SELECT b.client_code FROM bookings b
    WHERE b.price_per_night > ALL (
        SELECT AVG(b2.price_per_night) FROM bookings b2 GROUP BY b2.hotel_code
    )
);

SELECT b.hotel_code, b.client_code, b.payment_amount,
       CASE
           WHEN b.payment_amount >= 10000 THEN 'Крупная бронь'
           WHEN b.payment_amount BETWEEN 3000 AND 9999 THEN 'Средняя бронь'
           ELSE 'Мелкая бронь'
       END AS booking_category,
       CASE b.booking_status
           WHEN 'Подтверждено' THEN 'OK'
           WHEN 'Отменено' THEN 'CANCEL'
           WHEN 'No-show' THEN 'NOSHOW'
           ELSE 'OTHER'
       END AS status_label
FROM bookings b;

CREATE OR REPLACE VIEW view_hotel_revenue_monthly AS
SELECT h.hotel_name, YEAR(b.check_in_date) AS booking_year,
       MONTH(b.check_in_date) AS booking_month,
       COUNT(*) AS bookings_count, SUM(b.payment_amount) AS revenue
FROM bookings b
INNER JOIN hotels h ON b.hotel_code = h.hotel_code
WHERE b.booking_status = 'Подтверждено'
GROUP BY h.hotel_name, YEAR(b.check_in_date), MONTH(b.check_in_date);

SELECT * FROM view_hotel_revenue_monthly;

WITH channel_stats AS (
    SELECT channel_code, payment_amount FROM bookings WHERE booking_status = 'Подтверждено'
)
SELECT ch.channel_name, COUNT(*) AS bookings_count, AVG(cs.payment_amount) AS avg_amount
FROM channel_stats cs
INNER JOIN booking_channels ch ON cs.channel_code = ch.channel_code
GROUP BY ch.channel_name;

EXPLAIN SELECT * FROM bookings WHERE check_in_date = '2025-01-15';
EXPLAIN SELECT * FROM bookings WHERE hotel_code = '0001' AND booking_status = 'Подтверждено';

START TRANSACTION;

INSERT IGNORE INTO bookings
(hotel_code, client_code, check_in_date, check_out_date,
 room_type_code, meal_type_code, channel_code, segment_code,
 adults_count, children_count, infants_count,
 nights_count, weekend_nights_count, price_per_night,
 booking_status, payment_amount) VALUES
('0001', '000005', '2025-09-01', '2025-09-05', '02', '02', '03', '01',
 2, 0, 0, 4, 1, 900.00, 'Подтверждено', 3600.00);

INSERT IGNORE INTO clients (client_code, client_full_name, country_code, email, phone) VALUES
('000006', 'Смирнов Алексей', '643', 'smirnov@mail.ru', '+7-916-444-55-66');

COMMIT;

SET @sql_query = 'SELECT client_full_name, email, phone FROM clients WHERE client_full_name LIKE ?';

PREPARE find_client FROM @sql_query;

SET @name_param = '%Иванов%';

EXECUTE find_client USING @name_param;

DEALLOCATE PREPARE find_client;
