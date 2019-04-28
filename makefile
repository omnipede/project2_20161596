OBJECTS= main.o util.o lex.yy.o cm.tab.o
CC = gcc
CFLAGS = -Wall -c
TARGET = 20161596

$(TARGET): $(OBJECTS)
	$(CC) -o $(TARGET) $(OBJECTS)

main.o: cm.tab.h globals.h util.h scan.h parse.h main.c 
	$(CC) $(CFLAGS) main.c

util.o: globals.h util.h util.c
	$(CC) $(CFLAGS) util.c

lex.yy.o: globals.h util.h scan.h lex.yy.c
	$(CC) $(CFLAGS) lex.yy.c

cm.tab.o: globals.h util.h scan.h parse.h cm.tab.c
	$(CC) $(CFLAGS) cm.tab.c

lex.yy.c: tiny.l
	flex tiny.l

cm.tab.c cm.tab.h: cm.y
	bison -dv cm.y 

clean:
	rm -rf *.o $(TARGET) lex.yy.c cm.tab.c cm.tab.h
