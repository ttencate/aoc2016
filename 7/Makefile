.PHONY: all
all: 7a 7b

7%: 7%.o
	ld -m elf_i386 -o $@ $<

%.o: %.nasm
	nasm -f elf $<
