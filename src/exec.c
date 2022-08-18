#include <unistd.h>

int main() {
 
 char filename[] = "/bin/sh\x00";
 char **argv, **envp; // Arrays that contain char pointers
 
 argv[0] = filename; // The only argument is filename.
 argv[1] = 0; // Null terminate the argument array.
 envp[0] = 0; // Null terminate the environment array.
 
 execve(filename, argv, envp);
}