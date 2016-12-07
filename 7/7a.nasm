section .data
readbuf:
        db 0
printbuf:
        db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
printbuf_end:
        db 10 ; newline

section .bss
section .text
        global _start

        ; Syscall numbers (/usr/include/asm/unistd_32.h):
        ;   exit: 1
        ;   read: 3
        ;   write: 4
        ;   brk: 45
        ;
        ; Calling convention:
        ;   eax: system call number
        ;   ebx, ecx, edx, esi, edi, ebp: parameters
        ;   eax: return value

_start:
        ; Program state:
        ;   eax: count of IPs supporting TLS
        mov eax, 0
        jmp print_int
        jmp exit

        ; Reads a character into readbuf.
        ; Clobbers all registers.
read:
        mov eax, 3 ; read
        mov ebx, 0 ; stdin
        mov ecx, readbuf
        mov edx, 1
        int 0x80

        ; Writes the character in readbuf.
        ; Clobbers all registers.
write:
        mov eax, 4 ; write
        mov ebx, 1 ; stdout
        mov ecx, readbuf
        mov edx, 1
        int 0x80

        ; Prints eax in decimal.
        ; Clobbers all registers.
print_int:
        mov edx, 1
        mov ecx, printbuf_end
print_int_loop:
        push edx
        push ecx
        mov dx, 0
        mov cx, 10
        div cx ; for 16-bit source: quotient in ax, remainder in dx
        pop ecx
        add dx, 48 ; '0'
        sub ecx, 1
        mov [ecx], dl
        pop edx
        add edx, 1
        cmp eax, 0
        jnz print_int_loop
        mov eax, 4 ; write
        mov ebx, 1 ; stdout
        int 0x80

exit:
        mov eax, 1 ; exit syscall
        mov ebx, 0 ; exit code
        int 0x80
