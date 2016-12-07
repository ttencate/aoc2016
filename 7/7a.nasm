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
        ; Global state:
        ;   eax: count of IPs supporting TLS
        mov eax, 0
main_loop:
        call read
        cmp byte [readbuf], 0
        jz main_loop_end
        call parse_line
        jmp main_loop
main_loop_end:
        call print_eax
        call exit

        ; Expects first char of line in readbuf.
        ; Runs until newline is in readbuf.
        ; Increments eax if a TLS is found.
parse_line:
        ; bl tracks whether we're inside square brackets.
        mov bl, 0
        ; bh tracks TLS state:
        ;   0 unknown
        ;   1 ABBA found in square brackets, not outside (TLS candidate)
        ;   2 ABBA found inside square brackets (definitely not TLS)
        mov bh, 0
parse_line_loop:
        cmp byte [readbuf], 10 ; newline
        jz parse_line_end

        cmp byte [readbuf], 91 ; [
        jnz parse_line_no_open
        mov bl, 1
        call read
        jmp parse_line_loop
parse_line_no_open:

        cmp byte [readbuf], 93 ; ]
        jnz parse_line_no_close
        mov bl, 0
        call read
        jmp parse_line_loop
parse_line_no_close:

        call detect_abba
        cmp ecx, 1
        jnz parse_line_loop
        ; ABBA detected
        cmp bl, 1
        jz parse_line_abba_in_brackets
        ; ABBA detected outside brackets
        cmp bh, 0
        jnz parse_line_loop
        ; ABBA detected outside brackets and not seen before
        mov bh, 1
        jmp parse_line_loop
parse_line_abba_in_brackets:
        mov bh, 2
        jmp parse_line_loop

parse_line_end:
        cmp bh, 1
        jnz parse_line_no_tls
        add eax, 1
parse_line_no_tls:
        ret

        ; Expects first letter in readbuf.
        ; Reads until readbuf is not a letter.
        ; Sets ecx to 1 if abba is found, 0 otherwise.
detect_abba:
        mov ecx, 0

detect_abba_loop:
        cmp byte [readbuf], 97 ; 'a'
        jc detect_abba_end
        mov ecx, 1
        call read
        jmp detect_abba_loop

detect_abba_end:
        ret

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
