SELECT
    (SELECT count(*) FROM rental) AS rentals,
    (SELECT count(*) FROM payment) AS payments;

DELETE FROM rental
WHERE rental_id = 2;

SELECT
    (SELECT count(*) FROM rental) AS rentals,
    (SELECT count(*) FROM payment) AS payments;

DELETE FROM rental
WHERE rental_id = 7;

DELETE FROM customer
WHERE customer_id = 8;

DELETE FROM customer
WHERE customer_id = 6;

DELETE FROM car
WHERE car_id = 6;

DELETE FROM car
WHERE car_id = 1;

DELETE FROM car_model
WHERE model_id = 2;

DELETE FROM tariff
WHERE tariff_id = 1;
