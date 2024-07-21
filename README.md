# OS - Electrical and Computer Engineering AUTH 

 This repository contains the solutions to the laboratory exercises for the Operational Systems Course (049).
 
## Lab 1

The file `quiz1.log` is executed in the following way : 

```bash quiz1.log```

## Lab 2
The file `cleanup.fish` is executed in the following way: 

`cleanup <path_to_target_directory> <integer> <boolean> <boolean> <list_of_paths> <"asc" or "desc"> <boolean>`

An example is: 
```
cleanup "/home/geo/test" 15 true false "$list" "asc" true
```
`$list` is a list that contains paths of files/subfolders.

`test` is the target directory

## Lab 3
Unzip `quiz-3.tar.gz` with the command `tar -xzvf quiz-3.tar.gz`

The command `make all` performs the following functions:

  1) Compiles the source files `fork_1.c` and `fork_2.c`.

  2) Produces the final executable file named `main`

The file `main` can be executed in the following way:
```
chmod +x main
./main
```
The command `make clean` deletes :

 1) The final executable file `main`
 
 2) The object files `fork_1.o` and `fork_2.o`

## Lab 4
Unzip `quiz-4.tar.gz` with the command `tar -xzvf quiz-4.tar.gz`

The `hash_script` can be executed in the following ways:
``` 
1) bash hash_script <4-digit number>
2) sh hash_script <4-digit number>
3) chmod +x hash_script   and   ./hash_script <4-digit number>
```
The resulting hash is saved to `hash_output.txt`

Compiling C files and producing the executable files :
```
gcc mysigcatch.c -o mysigcatch
gcc mysigcatchmodified.c -o mysigcatchmodified
```
Run the executables :
```
chmod +x mysigcatch   and   ./mysigcatch
chmod +x mysigcatchmodified   and   ./mysigcatchmodified
```
