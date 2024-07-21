#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>


int sigint_count = 0; // The number of sent SIGINT signals.

void custom_sigint_handler(int signum) { //signum is the signal code for SIGINT.
  
    sigint_count++;
    printf("\nSignal %d caught (%d times).\n", signum, sigint_count);
    if (sigint_count == 2) {
        signal(SIGINT, SIG_DFL);
        printf("Restored default SIGINT behavior.\n");
    }
    else if (sigint_count == 3) {
        exit(0);
    }
}
int main() {
    signal(SIGINT, custom_sigint_handler);// When the SIGINT signal arrives, the custom_sigint_handler() function is executed.
    while (1) {
        printf("I am waiting to receive the SIGINT signal\n");
        sleep(1); 
    }
    return 0;
}