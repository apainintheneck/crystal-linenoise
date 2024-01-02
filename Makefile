.PHONY: liblinenoise clean

CFLAGS = -Wall -W -c -std=c11 -O2

default: liblinenoise

liblinenoise: src/linenoise.o

src/linenoise.o: ext/linenoise.c
	$(CC) -o $@ $< $(CFLAGS)

clean:
	rm -f src/linenoise.o
