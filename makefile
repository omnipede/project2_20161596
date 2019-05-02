OBJECTS= cm.tab.o lex.yy.o util.o main.o
CC = gcc
CFLAGS = -Wall -c
TARGET = 20161596

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS)

main.o: cm.tab.c main.c
	$(CC) $(CFLAGS) main.c

util.o: cm.tab.c util.c
	$(CC) $(CFLAGS) util.c

cm.tab.o: cm.tab.c
	$(CC) $(CFLAGS) cm.tab.c

cm.tab.c: cm.y
	bison -dv cm.y

lex.yy.o: lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c

lex.yy.c: tiny.l
	flex tiny.l

clean:
	rm -rf *.o $(TARGET) lex.yy.c cm.tab.c cm.tab.h cm.output
