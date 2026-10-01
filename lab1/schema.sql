BEGIN;

CREATE TABLE tariff (
    tariff_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    price_per_minute numeric(6, 2) NOT NULL,
    price_per_km numeric(6, 2) NOT NULL DEFAULT 0,
    CONSTRAINT tariff_name_key UNIQUE (name),
    CONSTRAINT tariff_price_per_minute_check CHECK (price_per_minute > 0),
    CONSTRAINT tariff_price_per_km_check CHECK (price_per_km >= 0)
);

CREATE TABLE car_model (
    model_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    brand text NOT NULL,
    model text NOT NULL,
    car_class text NOT NULL,
    seats smallint NOT NULL,
    tariff_id bigint NOT NULL,
    CONSTRAINT car_model_tariff_fkey FOREIGN KEY (tariff_id)
    REFERENCES tariff (tariff_id) ON DELETE RESTRICT,
    CONSTRAINT car_model_brand_model_key UNIQUE (brand, model),
    CONSTRAINT car_model_class_check CHECK (
        car_class IN ('economy', 'comfort', 'business', 'minivan')
    ),
    CONSTRAINT car_model_seats_check CHECK (seats BETWEEN 2 AND 9)
);

CREATE TABLE car (
    car_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    model_id bigint NOT NULL,
    plate_number varchar(9) NOT NULL,
    vin char(17) NOT NULL,
    color text NOT NULL,
    manufacture_year smallint NOT NULL,
    mileage_km integer NOT NULL DEFAULT 0,
    fuel_percent smallint NOT NULL DEFAULT 100,
    status text NOT NULL DEFAULT 'available',
    CONSTRAINT car_model_fkey FOREIGN KEY (model_id)
    REFERENCES car_model (model_id) ON DELETE RESTRICT,
    CONSTRAINT car_plate_number_key UNIQUE (plate_number),
    CONSTRAINT car_vin_key UNIQUE (vin),
    CONSTRAINT car_vin_check CHECK (length(vin) = 17),
    CONSTRAINT car_manufacture_year_check CHECK (manufacture_year >= 2000),
    CONSTRAINT car_mileage_check CHECK (mileage_km >= 0),
    CONSTRAINT car_fuel_check CHECK (fuel_percent BETWEEN 0 AND 100),
    CONSTRAINT car_status_check CHECK (
        status IN ('available', 'maintenance', 'decommissioned')
    )
);

CREATE TABLE customer (
    customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name text NOT NULL,
    email text NOT NULL,
    phone varchar(16) NOT NULL,
    birth_date date NOT NULL,
    license_number char(10) NOT NULL,
    license_issued_on date NOT NULL,
    is_blocked boolean NOT NULL DEFAULT FALSE,
    registered_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT customer_email_key UNIQUE (email),
    CONSTRAINT customer_license_number_key UNIQUE (license_number),
    CONSTRAINT customer_email_check CHECK (email LIKE '%_@_%'),
    CONSTRAINT customer_license_age_check CHECK (
        license_issued_on >= birth_date + interval '18 years'
    )
);

CREATE TABLE rental (
    rental_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id bigint NOT NULL,
    car_id bigint NOT NULL,
    tariff_id bigint NOT NULL,
    status text NOT NULL DEFAULT 'active',
    started_at timestamptz NOT NULL,
    ended_at timestamptz,
    start_mileage_km integer NOT NULL,
    end_mileage_km integer,
    CONSTRAINT rental_customer_fkey FOREIGN KEY (customer_id)
    REFERENCES customer (customer_id) ON DELETE RESTRICT,
    CONSTRAINT rental_car_fkey FOREIGN KEY (car_id)
    REFERENCES car (car_id) ON DELETE RESTRICT,
    CONSTRAINT rental_tariff_fkey FOREIGN KEY (tariff_id)
    REFERENCES tariff (tariff_id) ON DELETE RESTRICT,
    CONSTRAINT rental_status_check CHECK (status IN ('active', 'completed', 'cancelled')),
    CONSTRAINT rental_period_check CHECK (ended_at > started_at),
    CONSTRAINT rental_end_check CHECK (status = 'active' OR ended_at IS NOT NULL),
    CONSTRAINT rental_mileage_check CHECK (end_mileage_km >= start_mileage_km)
);

CREATE TABLE payment (
    payment_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rental_id bigint NOT NULL,
    amount numeric(10, 2) NOT NULL,
    method text NOT NULL,
    paid_at timestamptz NOT NULL DEFAULT now(),
    CONSTRAINT payment_rental_fkey FOREIGN KEY (rental_id)
    REFERENCES rental (rental_id) ON DELETE CASCADE,
    CONSTRAINT payment_amount_check CHECK (amount > 0),
    CONSTRAINT payment_method_check CHECK (method IN ('card', 'sbp', 'bonus'))
);

CREATE TABLE fine (
    fine_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rental_id bigint NOT NULL,
    violation text NOT NULL,
    amount numeric(10, 2) NOT NULL,
    issued_on date NOT NULL,
    is_paid boolean NOT NULL DEFAULT FALSE,
    CONSTRAINT fine_rental_fkey FOREIGN KEY (rental_id)
    REFERENCES rental (rental_id) ON DELETE RESTRICT,
    CONSTRAINT fine_amount_check CHECK (amount > 0)
);

COMMIT;
