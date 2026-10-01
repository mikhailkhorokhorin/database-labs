INSERT INTO customer (full_name, email, phone, birth_date, license_number, license_issued_on)
VALUES (NULL, 'kirill.orlov@example.com', '+79161234511', '1996-06-01', '7711123411', '2015-08-10');

INSERT INTO customer (full_name, email, phone, birth_date, license_number, license_issued_on)
VALUES (
    'Anna Smirnova', 'anna.smirnova@example.com', '+79161234512', '1995-04-12', '7712123412',
    '2014-06-20'
);

INSERT INTO customer (full_name, email, phone, birth_date, license_number, license_issued_on)
VALUES ('Kirill Orlov', 'kirill.orlov', '+79161234511', '1996-06-01', '7711123411', '2015-08-10');

INSERT INTO customer (full_name, email, phone, birth_date, license_number, license_issued_on)
VALUES (
    'Kirill Orlov', 'kirill.orlov@example.com', '+79161234511', '2009-06-01', '7711123411',
    '2025-08-10'
);

INSERT INTO tariff (name, price_per_minute)
VALUES ('Night Saver', 0.00);

INSERT INTO car_model (brand, model, car_class, seats, tariff_id)
VALUES ('Kia', 'Rio', 'economy', 5, 1);

INSERT INTO car (model_id, plate_number, vin, color, manufacture_year)
VALUES (1, 'A101AA777', 'Z94K241CBRR000111', 'white', 2025);

INSERT INTO car (model_id, plate_number, vin, color, manufacture_year)
VALUES (1, 'B111BB777', 'Z94K241CBRR0001', 'white', 2025);

UPDATE car
SET fuel_percent = 120
WHERE car_id = 5;

UPDATE car
SET status = 'broken'
WHERE car_id = 1;

INSERT INTO rental (customer_id, car_id, tariff_id, status, started_at, ended_at, start_mileage_km)
VALUES (2, 1, 1, 'completed', '2026-09-27 12:00+03', '2026-09-27 11:00+03', 48210);

UPDATE rental
SET status = 'completed', ended_at = '2026-09-27 11:00+03', end_mileage_km = 12000
WHERE rental_id = 16;

UPDATE rental
SET status = 'completed', end_mileage_km = 30420
WHERE rental_id = 15;

INSERT INTO rental (customer_id, car_id, tariff_id, started_at, start_mileage_km)
VALUES (2, 99, 1, '2026-09-27 12:00+03', 0);

INSERT INTO payment (rental_id, amount, method)
VALUES (14, -436.00, 'card');

INSERT INTO payment (rental_id, amount, method)
VALUES (14, 436.00, 'cash');

DELETE FROM customer
WHERE customer_id = 6;
