prefix ?= /usr/local
HFILES = toml.h
CFILES = toml.c
OBJ = $(CFILES:.c=.o)
EXEC = toml_json toml_cat toml_sample
PCFILE = libtomlc99.pc

CFLAGS = -std=c99 -Wall -Wextra -fpic
LIB_VERSION = 1.0
LIB = libtoml.a
LIB_SHARED = libtoml.so.$(LIB_VERSION)

# to compile for debug: make DEBUG=1
# to compile for no debug: make
ifdef DEBUG
    CFLAGS += -O0 -g
else
    CFLAGS += -O2 -DNDEBUG
endif


all: $(LIB) $(LIB_SHARED) $(EXEC)

*.o: $(HFILES)

libtoml.a: toml.o
	ar -rcs $@ $^

libtoml.so.$(LIB_VERSION): toml.o
	$(CC) -shared -o $@ $^

$(EXEC): $(LIB)

install: all
	install -d $(DESTDIR)${prefix}/include $(DESTDIR)${prefix}/lib \
		       $(DESTDIR)$(prefix)/lib/pkgconfig
	install toml.h $(DESTDIR)${prefix}/include
	install $(LIB) $(DESTDIR)${prefix}/lib
	install $(LIB_SHARED) $(DESTDIR)${prefix}/lib
	install $(PCFILE) ${DESTDIR}${prefix}/lib/pkgconfig/${PCFILE}

clean:
	rm -f *.o $(EXEC) $(LIB) $(LIB_SHARED)


format:
	clang-format -i $(shell find . -name '*.[ch]')

.PHONY: all clean install format
