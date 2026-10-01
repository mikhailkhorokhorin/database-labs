SET TIME ZONE 'Europe/Moscow';

SELECT
    m.car_class,
    c.status,
    count(*) AS cars
FROM car AS c
JOIN car_model AS m ON c.model_id = m.model_id
GROUP BY m.car_class, c.status
ORDER BY m.car_class, c.status;

SELECT
    r.rental_id,
    cu.full_name,
    m.brand || ' ' || m.model AS car,
    t.name AS tariff,
    (extract(EPOCH FROM r.ended_at - r.started_at) / 60)::integer AS minutes,
    r.end_mileage_km - r.start_mileage_km AS km,
    round(
        extract(EPOCH FROM r.ended_at - r.started_at) / 60 * t.price_per_minute
        + (r.end_mileage_km - r.start_mileage_km) * t.price_per_km,
        2
    ) AS cost,
    coalesce(sum(p.amount), 0) AS paid
FROM rental AS r
JOIN customer AS cu ON r.customer_id = cu.customer_id
JOIN car AS c ON r.car_id = c.car_id
JOIN car_model AS m ON c.model_id = m.model_id
JOIN tariff AS t ON r.tariff_id = t.tariff_id
LEFT JOIN payment AS p ON r.rental_id = p.rental_id
WHERE r.status = 'completed'
GROUP BY r.rental_id, cu.full_name, m.brand, m.model, t.name, t.price_per_minute, t.price_per_km
ORDER BY r.rental_id;

SELECT
    cu.full_name,
    c.plate_number,
    r.started_at
FROM rental AS r
JOIN customer AS cu ON r.customer_id = cu.customer_id
JOIN car AS c ON r.car_id = c.car_id
WHERE r.status = 'active'
ORDER BY r.started_at;

SELECT
    cu.full_name,
    f.violation,
    f.amount,
    f.issued_on
FROM fine AS f
JOIN rental AS r ON f.rental_id = r.rental_id
JOIN customer AS cu ON r.customer_id = cu.customer_id
WHERE NOT f.is_paid
ORDER BY f.fine_id;

SELECT
    t.name AS tariff,
    count(DISTINCT r.rental_id) AS rentals,
    coalesce(sum(p.amount), 0) AS revenue
FROM tariff AS t
LEFT JOIN rental AS r ON t.tariff_id = r.tariff_id
LEFT JOIN payment AS p ON r.rental_id = p.rental_id
GROUP BY t.name
ORDER BY revenue DESC;
