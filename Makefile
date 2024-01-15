CFLAGS = -Wall -W -c -std=c99 -O2

default: extension lint test docs

.PHONY: example
example: extension
	crystal run example/example.cr

.PHONY: extension
extension: src/lib/linenoise.o

src/lib/linenoise.o: ext/linenoise.c ext/linenoise.h
	$(CC) -o $@ $< $(CFLAGS)

.PHONY: check-codegen
check-codegen: extension
	crystal build --no-codegen -o example_program example/example.cr
	crystal build --no-codegen example/completion.cr

.PHONY: lint
lint:
	crystal tool format --check

.PHONY: lint-fix
lint-fix:
	crystal tool format

.PHONY: docs
docs:
	crystal run script/check_docs.cr

.PHONY: docs-build
docs-build:
	crystal docs

.PHONY: test
test: extension
	expect -f expect/example.expect
	@echo ":----------:"
	expect -f expect/completion.expect

.PHONY: clean
clean:
	rm -f src/lib/linenoise.o
