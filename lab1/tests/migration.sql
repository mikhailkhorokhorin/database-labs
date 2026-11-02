\set VERBOSITY terse
INSERT INTO rental_inspection (rental_id, kind, inspected_at, notes)
VALUES
(3, 'pre_rental', '2026-08-15 07:25+03', 'No damage'),
(3, 'post_rental', '2026-08-15 11:15+03', 'Scratch on the rear bumper');

INSERT INTO rental_incident (inspection_id, photo_url, notes)
VALUES (2, 'https://example.com/inspections/2/bumper.jpg', 'Scratch 10 cm on the rear bumper');

SELECT
    i.rental_id,
    i.kind,
    count(d.incident_id) AS incidents
FROM rental_inspection AS i
LEFT JOIN rental_incident AS d ON i.inspection_id = d.inspection_id
GROUP BY i.inspection_id, i.rental_id, i.kind
ORDER BY i.inspection_id;

INSERT INTO rental_inspection (rental_id, kind)
VALUES (3, 'pre_rental');

INSERT INTO rental_inspection (rental_id, kind)
VALUES (3, 'midway');

INSERT INTO rental_inspection (rental_id, kind)
VALUES (99, 'pre_rental');

INSERT INTO rental_incident (inspection_id, notes)
VALUES (99, 'Dent');

DELETE FROM rental
WHERE rental_id = 3;

SELECT
    (SELECT count(*) FROM rental_inspection) AS inspections,
    (SELECT count(*) FROM rental_incident) AS incidents;
