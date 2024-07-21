CC = gcc
CFLAGS = -Wall
DESTDIR = /home/gkpittis/quiz-3/bins

all: main

main: fork_1.c fork_2.c 
	$(CC) $(CFLAGS) -c -o fork_1.o fork_1.c
	$(CC) $(CFLAGS) -c -o fork_2.o fork_2.c
	$(CC) $(CFLAGS) -o $@ fork_1.o fork_2.o 

clean:
	rm -f main fork_1.o fork_2.o

install: main
	mkdir -p $(DESTDIR)
	cp $< $(DESTDIR)