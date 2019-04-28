OBJECTS= main.o util.o lex.yy.o y.tab.o
CC = gcc
CFLAGS = -Wall -c
TARGET = 20161596

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS)

main.o: y.tab.h globals.h util.h scan.h parse.h main.c 
	$(CC) $(CFLAGS) main.c

util.o: globals.h util.h util.c
	$(CC) $(CFLAGS) util.c

lex.yy.o: globals.h util.h scan.h lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c

y.tab.o: globals.h util.h scan.h parse.h y.tab.c
	$(CC) $(CFLAGS) y.tab.c

lex.yy.c: tiny.l
	flex tiny.l

y.tab.c y.tab.h: cm.y
	yacc -d cm.y

clean:
	rm -rf *.o $(TARGET) $(OBJECTS) lex.yy.c y.tab.c y.tab.h
