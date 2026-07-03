PSQL := psql -v ON_ERROR_STOP=1

.PHONY: build reset test queries check

build:
	$(PSQL) -f sql/run_all.sql

reset: build

test:
	$(PSQL) -f test/assertions.sql

queries:
	@for q in sql/queries/q*.sql; do $(PSQL) -f $$q >/dev/null && echo "ok  $$q" || exit 1; done

check: build test queries
