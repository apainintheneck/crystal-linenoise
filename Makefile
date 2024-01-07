.PHONY: extension clean

CFLAGS = -Wall -W -c -O2

default: extension

example: extension
	crystal run example/example.cr

extension: src/linenoise.o

src/linenoise.o: ext/linenoise.c ext/linenoise.h
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -f src/linenoise.o
