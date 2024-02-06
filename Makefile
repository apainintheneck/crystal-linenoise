.PHONY: example extension lint fix test clean

CFLAGS = -Wall -Wextra -Wpedantic -Werror -c -std=c11 -O2

default: extension lint test

example: extension
	crystal run example/example.cr

extension: src/lib/linenoise.o

src/lib/linenoise.o: ext/linenoise.c ext/linenoise.h
	$(CC) -o $@ $< $(CFLAGS)

check: extension
	crystal build --no-codegen -o example_program example/example.cr

lint:
	crystal tool format --check

fix:
	crystal tool format

specs:
	crystal spec --order random

expect: extension
	@echo ":----------:"
	expect -f expect/example.expect
	@echo ":----------:"
	expect -f expect/completion.expect
	@echo ":----------:"

test: specs expect

clean:
	rm -f src/lib/linenoise.o
