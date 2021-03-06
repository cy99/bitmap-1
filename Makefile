CC=gcc
CFLAGS=-c -Wall -I /usr/local/include `libpng-config --cflags` -DUSEPNG -DUSEJPG
LDFLAGS=
AWK=awk

# Add your source files here:
LIB_SOURCES=bmp.c
LIB_OBJECTS=$(LIB_SOURCES:.c=.o)
LIB=libbmp.a

ifeq ($(BUILD),debug)
# Debug
CFLAGS += -O0 -g
LDFLAGS +=
else
# Release mode
CFLAGS += -O2 -DNDEBUG
LDFLAGS += -s
endif

all: libbmp.a docs

debug:
	make BUILD=debug
	
libbmp.a: $(LIB_OBJECTS)
	ar rs $@ $^
	
.c.o:
	$(CC) $(CFLAGS) $< -o $@

bmp.o: bmp.c bmp.h

docs: bitmap.html

bitmap.html: bmp.h d.awk
	$(AWK) -f d.awk $< > $@
	
.PHONY : clean 

clean:
	-rm -f *.o $(LIB)
	-rm -f $(TESTS) *.exe test/*.exe
	-rm -rf bitmap.html
# The .exe above is for MinGW, btw.