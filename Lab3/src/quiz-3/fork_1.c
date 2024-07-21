#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

char character;
int pd[4][2];//Δημιουργώ έναν πίνακα που περιέχει τους περιγραφείς τεσσάρων διαφορετικών σωληνώσεων
             //(όσες είναι δηλαδή και οι θυγατρικές διεργασίες)
             //Κάθε θυγατρική διεργασία έχει
             //την δική της σωλήνωση για να επικοινωνήσει με την μητρική διεργασία.
int pids[4]; //στον πίνακα pids αποθηκέυω το PID κάθε θυγατρικής διεργασίας,
int p[2];    //και για να το καταφέρω αυτό δημιουργώ μια 5η σωλήνωση --> pipe(p)

void sort(char* d, int* pids, int n);//υλοποιώ ένα ascending bubble short που τυπώνει τα αποτελέσματα σε αύξουσα σειρά

void child(int i) {//χρησιμοποιώ την συνάρτηση child για να γράψω τα pids των θυγατρικών διεργασιών καθώς και τους χαρακτήρες που εισάγω
                   //από το πληκτρολόγιο στους περιγραφείς εγγραφής των κατάλληλων σωληνώσεων
    close(p[0]);
    close(pd[i][0]);
    pids[i] = getpid();
    write(p[1], &pids[i], sizeof(pids[i]));
    close(p[1]);
    printf("Enter a character for child process %d with PID = %d: ", i + 1, getpid());
    scanf(" %c", &character);
    write(pd[i][1], &character, sizeof(char));
    close(pd[i][1]);
    exit(0);
}

int main() {
    pipe(p);
    char d[4];
    for (int i = 0; i < 4; i++) {
        pipe(pd[i]);
        if (fork() == 0) {
            child(i);
        }
        close(pd[i][1]);
        read(pd[i][0], &character, sizeof(char));
        printf("I am child process %d and my character is %c.\n", i + 1, character);
        d[i] = character;// στον πίνακα d αποθηκεύω τους χαρακτήρες κάθε θυγατρικής διεργασίας
        character = '\0';
        close(pd[i][0]);
    }
    for (int i = 0; i < 4; i++) {
        read(p[0], &pids[i], sizeof(pids[i]));
    }
    printf("\n\n");
    printf("The final result :\n\n");
    sort(d, pids, 4);
    return 0;
}