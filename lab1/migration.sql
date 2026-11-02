BEGIN;

CREATE TABLE rental_inspection (
    inspection_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    rental_id bigint NOT NULL,
    kind text NOT NULL,
    inspected_at timestamptz NOT NULL DEFAULT now(),
    notes text,
    CONSTRAINT rental_inspection_rental_fkey FOREIGN KEY (rental_id)
    REFERENCES rental (rental_id) ON DELETE CASCADE,
    CONSTRAINT rental_inspection_rental_kind_key UNIQUE (rental_id, kind),
    CONSTRAINT rental_inspection_kind_check CHECK (kind IN ('pre_rental', 'post_rental'))
);

CREATE TABLE rental_incident (
    incident_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    inspection_id bigint NOT NULL,
    photo_url text,
    notes text,
    CONSTRAINT rental_incident_inspection_fkey FOREIGN KEY (inspection_id)
    REFERENCES rental_inspection (inspection_id) ON DELETE CASCADE
);

COMMIT;
