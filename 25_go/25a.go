package main;

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"unicode"
)

type Instruction interface {
	Execute(state *State) int
}

type cpy struct {
	from Argument
	to RegisterArgument
}

type inc struct {
	register RegisterArgument
}

type dec struct {
	register RegisterArgument
}

type jnz struct {
	cond Argument
	offset Argument
}

type out struct {
	value Argument
}

func (i cpy) Execute(state *State) int {
	state.registers[i.to.register] = i.from.Evaluate(state)
	return state.pc + 1
}

func (i inc) Execute(state *State) int {
	state.registers[i.register.register]++
	return state.pc + 1
}

func (i dec) Execute(state *State) int {
	state.registers[i.register.register]--
	return state.pc + 1
}

func (i jnz) Execute(state *State) int {
	if i.cond.Evaluate(state) != 0 {
		return state.pc + i.offset.Evaluate(state)
	} else {
		return state.pc + 1
	}
}

func (i out) Execute(state *State) int {
	state.output = append(state.output, i.value.Evaluate(state))
	return state.pc + 1
}

type Argument interface {
	Evaluate(state *State) int
}

type IntegerArgument struct {
	value int
}

type RegisterArgument struct {
	register int
}

func (this IntegerArgument) Evaluate(state *State) int {
	return this.value
}

func (this RegisterArgument) Evaluate(state *State) int {
	return state.registers[this.register]
}

type State struct {
	instructions []Instruction
	pc int
	registers [4]int
	output []int
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)
	readRegisterArg := func() RegisterArgument {
		scanner.Scan()
		arg := scanner.Text()
		return RegisterArgument{int(arg[0] - byte('a'))}
	}
	readArg := func() Argument {
		scanner.Scan()
		arg := scanner.Text()
		if unicode.IsLetter(rune(arg[0])) {
			return RegisterArgument{int(arg[0] - byte('a'))}
		} else {
			i, _ := strconv.ParseInt(arg, 10, 64)
			return IntegerArgument{int(i)}
		}
	}
	var state State
	for scanner.Scan() {
		var instruction Instruction
		mnemonic := scanner.Text()
		switch mnemonic {
		case "cpy":
			from := readArg()
			to := readRegisterArg()
			instruction = cpy{from, to}
		case "inc":
			register := readRegisterArg()
			instruction = inc{register}
		case "dec":
			register := readRegisterArg()
			instruction = dec{register}
		case "jnz":
			cond := readArg()
			offset := readArg()
			instruction = jnz{cond, offset}
		case "out":
			value := readArg()
			instruction = out{value}
		}
		state.instructions = append(state.instructions, instruction)
	}

	for a := 0;; a++ {
		fmt.Printf("\r%d", a)
		state.registers = [4]int{a, 0, 0, 0}
		state.pc = 0
		state.output = nil
		for state.pc >= 0 && state.pc < len(state.instructions) {
			state.pc = state.instructions[state.pc].Execute(&state)
			n := len(state.output)
			if n > 0 && state.output[n - 1] != (n - 1) % 2 {
				break
			}
		}
	}
}
