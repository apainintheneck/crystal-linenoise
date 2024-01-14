.PHONY: example extension lint fix test clean

CFLAGS = -Wall -W -c -std=c99 -O2

default: extension lint test

example: extension
	crystal run example/example.cr

extension: src/lib/linenoise.o

src/lib/linenoise.o: ext/linenoise.c ext/linenoise.h
	$(CC) -o $@ $< $(CFLAGS)

lint:
	crystal tool format --check

fix:
	crystal tool format

test: extension
	expect -f expect/example_spec.expect

clean:
	rm -f src/lib/linenoise.o
