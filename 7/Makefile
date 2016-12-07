.PHONY: all
all: 7a

7a: 7a.o
	ld -m elf_i386 -o $@ $<

%.o: %.nasm
	nasm -f elf $<
