#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

void sort(char* d, int* pids, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (pids[j] > pids[j + 1]) {
                //κάνω swap τα pids
                int temp_pid = pids[j];
                pids[j] = pids[j + 1];
                pids[j + 1] = temp_pid;

                //κάνω swap τους χαρακτήρες
                char temp_char = d[j];
                d[j] = d[j + 1];
                d[j + 1] = temp_char;
            }
        }
    }
    //τυπώνω το ζητούμενο
    for (int i = 0; i < n; i++) {
        printf("I am child process %d and my character was %c.\n", i + 1, d[i]);
    }
}