#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

void sigint_handler(int signum) {
    printf("\nSIGINT signal caught!\n");
    exit(0);
}
int main() {
   
    signal(SIGINT, sigint_handler);//When the SIGINT signal is received, the sigint_handler() function will be executed.

    while (1) {
        printf("I am waiting to receive the SIGINT signal\n");
        sleep(1); // The while loop sleeps for 1 second.
    }

    return 0;
}    