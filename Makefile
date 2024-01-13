.PHONY: example extension clean

CFLAGS = -Wall -W -c -std=c11 -O2

default: extension

example: extension
	crystal run example/example.cr

extension: src/lib/linenoise.o

src/lib/linenoise.o: ext/linenoise.c ext/linenoise.h
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -f src/lib/linenoise.o
