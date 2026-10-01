# Lab 1. Relational Database Design

## Task

Design a relational database for variant 13, car sharing, normalize it to 3NF,
draw the ER diagram, implement it in PostgreSQL, fill it with test data and demonstrate that the
integrity constraints reject invalid data. The design, the ER diagram and the 3NF justification
are in [docs/report.md](docs/report.md).

| File | Content |
| --- | --- |
| [schema.sql](schema.sql) | tables, keys and constraints |
| [data.sql](data.sql) | test data |
| [constraints_test.sql](constraints_test.sql) | invalid operations rejected by the constraints |
| [tests/](tests/) | checks run by `make test` with the expected psql output |

## Build and run

```bash
make run LAB=lab1
make psql LAB=lab1
make test LAB=lab1
```

## Example

```text
$ make run LAB=lab1
 table_name | row_count
------------+-----------
 car        |        10
 car_model  |         6
 customer   |        10
 fine       |         4
 payment    |        12
 rental     |        16
 tariff     |         6
(7 rows)
```

## Notes

`migration.sql` is added once the requirement change is issued. `make run` and `make test` apply
it automatically after `schema.sql` and `data.sql`.
