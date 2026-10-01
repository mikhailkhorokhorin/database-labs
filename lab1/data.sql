BEGIN;

INSERT INTO tariff (name, price_per_minute, price_per_km)
VALUES
('Economy', 9.90, 0.00),
('Comfort', 13.50, 0.00),
('Business', 21.00, 5.00),
('Minivan', 15.50, 0.00),
('Welcome Promo', 5.90, 0.00),
('Economy Plus', 10.90, 0.00);

INSERT INTO car_model (brand, model, car_class, seats, tariff_id)
VALUES
('Hyundai', 'Solaris', 'economy', 5, 1),
('Kia', 'Rio', 'economy', 5, 1),
('Volkswagen', 'Polo', 'economy', 5, 6),
('Skoda', 'Octavia', 'comfort', 5, 2),
('Toyota', 'Camry', 'business', 5, 3),
('Mercedes-Benz', 'V-Class', 'minivan', 7, 4);

INSERT INTO car (
    model_id, plate_number, vin, color, manufacture_year, mileage_km, fuel_percent, status
)
VALUES
(1, 'A101AA777', 'Z94K241CBNR000101', 'white', 2022, 48210, 72, 'available'),
(1, 'A202BC777', 'Z94K241CBPR000202', 'grey', 2023, 31540, 55, 'available'),
(2, 'B303CE799', 'XWEFC411ANC000303', 'red', 2022, 52300, 80, 'available'),
(2, 'C404EK797', 'XWEFC411AMC000404', 'white', 2021, 76120, 15, 'maintenance'),
(3, 'E505KM777', 'XW8ZZZ61ZPG000505', 'blue', 2023, 21870, 90, 'available'),
(3, 'O909TY777', 'XW8ZZZ61ZKG000909', 'white', 2019, 150220, 0, 'decommissioned'),
(4, 'K606MH799', 'XW8AN2NE0RH000606', 'black', 2024, 12450, 64, 'available'),
(4, 'X010XX799', 'XW8AN2NE5PH000010', 'white', 2023, 25010, 45, 'available'),
(5, 'M707OP777', 'XW7BF4FK8RS000707', 'black', 2024, 9870, 88, 'available'),
(6, 'H808PC797', 'WDF44781313000808', 'silver', 2023, 30400, 70, 'available');

INSERT INTO customer (
    full_name,
    email,
    phone,
    birth_date,
    license_number,
    license_issued_on,
    is_blocked,
    registered_at
)
VALUES
(
    'Anna Smirnova', 'anna.smirnova@example.com', '+79161234501',
    '1995-04-12', '7701123401', '2014-06-20', FALSE, '2025-10-02 12:00+03'
),
(
    'Boris Ivanov', 'boris.ivanov@example.com', '+79161234502',
    '1988-11-03', '7702123402', '2008-02-15', FALSE, '2025-09-15 09:30+03'
),
(
    'Daria Kuznetsova', 'daria.kuznetsova@example.com', '+79161234503',
    '2001-07-25', '7703123403', '2020-09-10', FALSE, '2026-08-09 18:20+03'
),
(
    'Egor Popov', 'egor.popov@example.com', '+79161234504',
    '1999-01-30', '7704123404', '2018-03-05', FALSE, '2026-08-24 21:05+03'
),
(
    'Irina Volkova', 'irina.volkova@example.com', '+79161234505',
    '1992-09-14', '7705123405', '2011-10-01', FALSE, '2026-07-28 10:15+03'
),
(
    'Maxim Sokolov', 'maxim.sokolov@example.com', '+79161234506',
    '2003-02-18', '7706123406', '2021-04-22', TRUE, '2026-08-01 16:45+03'
),
(
    'Nikita Lebedev', 'nikita.lebedev@example.com', '+79161234507',
    '1997-05-09', '7707123407', '2016-07-14', FALSE, '2026-06-11 08:00+03'
),
(
    'Olga Morozova', 'olga.morozova@example.com', '+79161234508',
    '1990-12-01', '7708123408', '2010-05-27', FALSE, '2026-05-20 13:40+03'
),
(
    'Pavel Novikov', 'pavel.novikov@example.com', '+79161234509',
    '2004-08-08', '7709123409', '2023-01-19', FALSE, '2026-09-06 19:10+03'
),
(
    'Sofia Kozlova', 'sofia.kozlova@example.com', '+79161234510',
    '1998-03-21', '7710123410', '2017-11-30', FALSE, '2026-08-12 11:25+03'
);

INSERT INTO rental (
    customer_id,
    car_id,
    tariff_id,
    status,
    started_at,
    ended_at,
    start_mileage_km,
    end_mileage_km
)
VALUES
(5, 9, 3, 'completed', '2026-08-03 09:00+03', '2026-08-03 10:45+03', 9120, 9195),
(3, 2, 5, 'completed', '2026-08-10 12:00+03', '2026-08-10 12:38+03', 30880, 30897),
(10, 10, 4, 'completed', '2026-08-15 07:30+03', '2026-08-15 11:10+03', 29950, 30210),
(1, 7, 2, 'completed', '2026-08-20 19:15+03', '2026-08-20 19:58+03', 12100, 12131),
(7, 3, 1, 'completed', '2026-08-22 08:05+03', '2026-08-22 08:47+03', 52040, 52066),
(4, 5, 5, 'completed', '2026-08-25 17:40+03', '2026-08-25 18:30+03', 21600, 21640),
(6, 4, 1, 'completed', '2026-08-28 23:10+03', '2026-08-29 00:40+03', 75980, 76090),
(2, 8, 2, 'completed', '2026-09-01 09:20+03', '2026-09-01 10:05+03', 24800, 24836),
(5, 1, 1, 'completed', '2026-09-05 14:00+03', '2026-09-05 14:25+03', 48150, 48168),
(9, 2, 5, 'cancelled', '2026-09-07 10:00+03', '2026-09-07 10:04+03', 31500, 31500),
(9, 3, 5, 'completed', '2026-09-07 10:20+03', '2026-09-07 11:02+03', 52200, 52231),
(3, 7, 2, 'completed', '2026-09-12 20:00+03', '2026-09-12 20:47+03', 12380, 12412),
(7, 9, 3, 'completed', '2026-09-18 08:00+03', '2026-09-18 09:15+03', 9780, 9840),
(10, 5, 6, 'completed', '2026-09-20 13:30+03', '2026-09-20 14:10+03', 21800, 21830),
(1, 10, 4, 'active', '2026-09-27 09:40+03', NULL, 30400, NULL),
(4, 7, 2, 'active', '2026-09-27 10:05+03', NULL, 12450, NULL);

INSERT INTO payment (rental_id, amount, method, paid_at)
VALUES
(1, 2580.00, 'card', '2026-08-03 10:46+03'),
(2, 224.20, 'sbp', '2026-08-10 12:39+03'),
(3, 3410.00, 'card', '2026-08-15 11:12+03'),
(4, 580.50, 'card', '2026-08-20 19:59+03'),
(5, 415.80, 'bonus', '2026-08-22 08:48+03'),
(6, 295.00, 'card', '2026-08-25 18:31+03'),
(7, 891.00, 'card', '2026-08-29 00:41+03'),
(8, 607.50, 'sbp', '2026-09-01 10:06+03'),
(9, 247.50, 'card', '2026-09-05 14:26+03'),
(11, 247.80, 'card', '2026-09-07 11:03+03'),
(12, 634.50, 'card', '2026-09-12 20:48+03'),
(13, 1875.00, 'card', '2026-09-18 09:16+03');

INSERT INTO fine (rental_id, violation, amount, issued_on, is_paid)
VALUES
(1, 'Speeding over 20 km/h', 500.00, '2026-08-06', TRUE),
(5, 'Parking in a restricted area', 3000.00, '2026-08-24', TRUE),
(7, 'Speeding over 40 km/h', 2000.00, '2026-09-02', FALSE),
(7, 'Running a red light', 1000.00, '2026-09-02', FALSE);

COMMIT;
