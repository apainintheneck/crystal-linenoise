.PHONY: extension clean

CFLAGS = -Wall -W -c -O2

default: extension

extension: src/linenoise.o

src/linenoise.o: ext/linenoise.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -f src/linenoise.o
