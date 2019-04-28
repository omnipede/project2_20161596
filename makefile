OBJECTS= main.o util.o lex.yy.o
CC = gcc
CFLAGS = -Wall -c
TARGET = 20161596

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS)

main.o: globals.h util.h scan.h main.c
	$(CC) $(CFLAGS) main.c

util.o: globals.h util.h util.c
	$(CC) $(CFLAGS) util.c

lex.yy.o: globals.h util.h scan.h lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c

lex.yy.c: tiny.l
	flex tiny.l

clean:
	rm -rf *.o $(TARGET) $(OBJECTS) lex.yy.c
