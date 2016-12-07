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
main_loop:
        call read
        cmp byte [readbuf], 0
        jz main_loop_end
        cmp byte [readbuf], 10 ; newline
        jnz main_loop_not_newline
        add eax, 1
main_loop_not_newline:
        jmp main_loop
main_loop_end:
        call print_eax
        call exit

        ; Reads a character into readbuf.
        ; 0 means end of file.
read:
        pusha
        mov eax, 3 ; read
        mov ebx, 0 ; stdin
        mov ecx, readbuf
        mov edx, 1
        int 0x80
        cmp eax, 0
        jnz read_return
        mov [readbuf], byte 0
read_return:
        popa
        ret

        ; Prints eax in decimal.
print_eax:
        mov edx, 1
        mov ecx, printbuf_end
print_eax_loop:
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
        jnz print_eax_loop
        mov eax, 4 ; write
        mov ebx, 1 ; stdout
        int 0x80
        ret

exit:
        mov eax, 1 ; exit syscall
        mov ebx, 0 ; exit code
        int 0x80
