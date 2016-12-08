.PHONY: all
all: 07a 07b

07%: 07%.o
	ld -m elf_i386 -o $@ $<

%.o: %.nasm
	nasm -f elf $<
