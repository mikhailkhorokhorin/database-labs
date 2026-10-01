LAB ?=

PG_BIN ?= $(lastword $(sort $(wildcard /usr/lib/postgresql/*/bin)))
PGDATA := $(CURDIR)/build/pgdata
PG_SOCKET_DIR := $(CURDIR)/build/pgsocket
PG_LOG := $(CURDIR)/build/postgres.log

export PGHOST := $(PG_SOCKET_DIR)
export PGPORT := 5432
export PGUSER := postgres

LABS = $(sort $(patsubst %/,%,$(dir $(wildcard lab*/schema.sql))))
SELECTED_LABS = $(if $(LAB),$(LAB),$(LABS))

define LOAD_DB
load_db() { \
	PGOPTIONS="-c client_min_messages=warning" dropdb --if-exists "$$2" && createdb "$$2" && \
	psql -X -q -v ON_ERROR_STOP=1 -d "$$2" -f "$$1/schema.sql" -f "$$1/data.sql" \
		$$(test -f "$$1/migration.sql" && echo "-f $$1/migration.sql"); \
}
endef

ROW_COUNTS := SELECT table_name, (xpath('/row/c/text()', query_to_xml(format('SELECT count(*) AS c FROM %I', table_name), false, true, '')))[1]::text::int AS row_count FROM information_schema.tables WHERE table_schema = 'public' AND table_type = 'BASE TABLE' ORDER BY table_name

PRE_COMMIT_CONFIG := .config/.pre-commit-config.yaml

-include .config/local.mk

.DEFAULT_GOAL := help

.PHONY: help setup db-start db-stop run psql test accept format lint ci clean

help:
	@echo "make run    LAB=labN   create database labN from schema.sql, data.sql and migration.sql"
	@echo "make psql   LAB=labN   open psql on database labN"
	@echo "make test   [LAB=labN] run labN/tests/*.sql and compare with the expected .out files"
	@echo "make accept LAB=labN   overwrite the expected .out files with the actual output"
	@echo "make format            apply all formatters"
	@echo "make lint              pre-commit hooks"
	@echo "make ci                everything CI runs"
	@echo "make db-stop           stop the local PostgreSQL server"
	@echo "make clean             stop the server and remove build outputs"

setup:
	pre-commit install -c $(PRE_COMMIT_CONFIG)

db-start:
	@mkdir -p build $(PG_SOCKET_DIR)
	@test -f $(PGDATA)/PG_VERSION || $(PG_BIN)/initdb -D $(PGDATA) -U postgres --auth=trust \
		--encoding=UTF8 --locale=C.UTF-8 > build/initdb.log
	@$(PG_BIN)/pg_ctl -D $(PGDATA) status > /dev/null 2>&1 || $(PG_BIN)/pg_ctl -D $(PGDATA) \
		-l $(PG_LOG) -w -o "-k $(PG_SOCKET_DIR) -c listen_addresses=localhost" start > /dev/null

db-stop:
	@test ! -f $(PGDATA)/PG_VERSION || ! $(PG_BIN)/pg_ctl -D $(PGDATA) status > /dev/null 2>&1 \
		|| $(PG_BIN)/pg_ctl -D $(PGDATA) -m fast stop > /dev/null

run: db-start
	@test -n "$(LAB)" || (echo "LAB is required" >&2; exit 2)
	@$(LOAD_DB); load_db $(LAB) $(LAB)
	@psql -X -d $(LAB) -c "$(ROW_COUNTS)"

psql: db-start
	@test -n "$(LAB)" || (echo "LAB is required" >&2; exit 2)
	@psql -X -d $(LAB)

test: db-start
	@$(LOAD_DB); status=0; \
	for lab in $(SELECTED_LABS); do \
		for script in $$(ls $$lab/tests/*.sql 2>/dev/null); do \
			name=$$(basename $$script .sql); \
			db=test_$${lab}_$$name; \
			actual=build/test/$$lab/$$name.out; \
			mkdir -p build/test/$$lab; \
			load_db $$lab $$db || exit 1; \
			(cd $$lab/tests && psql -X -a -v ON_ERROR_STOP=0 -d $$db -f $$name.sql) > $$actual 2>&1; \
			dropdb $$db; \
			if [ -n "$(ACCEPT)" ]; then \
				cp $$actual $$lab/tests/$$name.out; echo "ACCEPT $$lab/$$name"; \
			elif diff -u $$lab/tests/$$name.out $$actual; then \
				echo "PASS $$lab/$$name"; \
			else \
				echo "FAIL $$lab/$$name"; status=1; \
			fi; \
		done; \
	done; \
	exit $$status

accept:
	@test -n "$(LAB)" || (echo "LAB is required" >&2; exit 2)
	@$(MAKE) --no-print-directory test LAB=$(LAB) ACCEPT=1

format:
	-pre-commit run -c $(PRE_COMMIT_CONFIG) --all-files

lint:
	pre-commit run -c $(PRE_COMMIT_CONFIG) --all-files --show-diff-on-failure

ci: lint test

clean: db-stop
	rm -rf build
