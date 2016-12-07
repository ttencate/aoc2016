section .data
readbuf:
        db 0
printbuf:
        db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
printbuf_end:
        db 10 ; newline
ababuf:
        db 0, 0, 0, 0

section .bss
        ; If ABA was found outside brackets, the entry for AB will have bit 0 set.
        ; If BAB was found inside brackets, the entry for AB will have bit 1 set.
found:
        resb 65536
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
        ; Increments eax if SSL is found.
parse_line:

        mov ebx, found
parse_line_clear_found_loop:
        mov byte [ebx], 0
        add ebx, 1
        cmp ebx, found + 65536
        jnz parse_line_clear_found_loop

        ; bl tracks whether we're inside square brackets.
        ; bl = 1: no square brackets
        ; bl = 2: square brackets
        mov bl, 1
parse_line_loop:
        cmp byte [readbuf], 10 ; newline
        jz parse_line_end

        cmp byte [readbuf], 91 ; [
        jnz parse_line_no_open
        mov bl, 2
        call read
        jmp parse_line_loop
parse_line_no_open:

        cmp byte [readbuf], 93 ; ]
        jnz parse_line_no_close
        mov bl, 1
        call read
        jmp parse_line_loop
parse_line_no_close:

        call detect_aba
        jmp parse_line_loop

parse_line_end:
        mov ebx, found
parse_line_check_found_loop:
        cmp byte [ebx], 3
        jz parse_line_found_ssl
        add ebx, 1
        cmp ebx, found + 65536
        jnz parse_line_check_found_loop
        jmp parse_line_done
parse_line_found_ssl:
        add eax, 1
parse_line_done:
        ret

        ; Expects first letter in readbuf.
        ; Reads until readbuf is not a letter.
        ; Marks ABAs in found table according to the value in bl.
detect_aba:
        mov dword [ababuf], 0

detect_aba_loop:
        cmp byte [readbuf], 97 ; 'a'
        jc detect_aba_end

        mov edx, [ababuf]
        shl edx, 8
        or dl, [readbuf]
        mov [ababuf], edx
        mov dl, [ababuf]
        cmp dl, [ababuf + 2]
        jnz detect_aba_no_aba
        cmp dl, [ababuf + 1]
        jz detect_aba_no_aba

        ; We have an aba!
        mov edx, 0
        cmp bl, 1
        jz detect_aba_found_inside_brackets
detect_aba_found_outside_brackets:
        mov dl, [ababuf + 1]
        mov dh, [ababuf]
        jmp detect_aba_mark_aba
detect_aba_found_inside_brackets:
        mov dl, [ababuf]
        mov dh, [ababuf + 1]
detect_aba_mark_aba:
        add edx, found
        mov cl, [edx]
        or cl, bl
        mov [edx], cl

detect_aba_no_aba:
        call read
        jmp detect_aba_loop

detect_aba_end:
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
        pusha
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
        popa
        ret

exit:
        mov eax, 1 ; exit syscall
        mov ebx, 0 ; exit code
        int 0x80
