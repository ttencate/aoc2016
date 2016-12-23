#include <ctype.h>
#include <error.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Argument_;
struct Instruction_;
struct State_;

typedef struct Instruction_ *(*Func)(struct Instruction_*, struct State_*);

typedef char ArgumentType;
#define INTEGER_ARGUMENT 1
#define REGISTER_ARGUMENT 2

typedef struct Argument_ {
  ArgumentType type;
  int value;
} Argument;

typedef struct Instruction_ {
  Func func;
  Argument arg1;
  Argument arg2;
} Instruction;

typedef struct State_ {
  Instruction instructions[64];
  Instruction *pc;
  Instruction *end;
  int registers[4];
} State;

void init_state(State *state) {
  state->pc = state->instructions;
  state->end = state->instructions;
  memset(state->registers, 0, sizeof(state->registers));
}

int evaluate(Argument arg, State *state) {
  switch (arg.type) {
    case INTEGER_ARGUMENT:
      return arg.value;
    case REGISTER_ARGUMENT:
      return state->registers[arg.value];
    default:
      error(1, 0, "unknown argument type %d", (int) arg.type);
      return 0;
  }
}

Instruction *cpy(Instruction *pc, State *state) {
  if (pc->arg2.type == REGISTER_ARGUMENT) {
    state->registers[pc->arg2.value] = evaluate(pc->arg1, state);
  }
  return pc + 1;
}

Instruction *inc(Instruction *pc, State *state) {
  if (pc->arg1.type == REGISTER_ARGUMENT) {
    state->registers[pc->arg1.value]++;
  }
  return pc + 1;
}

Instruction *dec(Instruction *pc, State *state) {
  if (pc->arg1.type == REGISTER_ARGUMENT) {
    state->registers[pc->arg1.value]--;
  }
  return pc + 1;
}

Instruction *jnz(Instruction *pc, State *state) {
  if (evaluate(pc->arg1, state)) {
    return pc + evaluate(pc->arg2, state);
  }
  return pc + 1;
}

Instruction *tgl(Instruction *pc, State *state) {
  Instruction *target = pc + evaluate(pc->arg1, state);
  if (target >= state->instructions && target < state->end) {
    Func orig = target->func;
    if (orig == inc) {
      target->func = dec;
    } else if (orig == dec || orig == tgl) {
      target->func = inc;
    } else if (orig == jnz) {
      target->func = cpy;
    } else if (orig == cpy) {
      target->func = jnz;
    } else {
      error(1, 0, "unknown instruction type");
    }
  }
  return pc + 1;
}

bool read_argument(FILE *in, Argument *out) {
  char buf[16];
  if (!fscanf(in, "%s ", buf)) {
    return false;
  }
  if (buf[0] >= 'a' && buf[0] <= 'd') {
    out->type = REGISTER_ARGUMENT;
    out->value = buf[0] - 'a';
  } else if (buf[0] == '-' || isdigit(buf[0])) {
    out->type = INTEGER_ARGUMENT;
    out->value = atoi(buf);
  } else {
    error(1, 0, "unknown argument type %s", buf);
  }
  return true;
}

bool read_instruction(FILE *in, Instruction *out) {
  char mnemonic[4];
  if (fscanf(in, "%3s ", mnemonic) <= 0) {
    return false;
  }
  if (!strcmp(mnemonic, "cpy")) {
    out->func = cpy;
    return read_argument(in, &out->arg1) && read_argument(in, &out->arg2);
  } else if (!strcmp(mnemonic, "inc")) {
    out->func = inc;
    return read_argument(in, &out->arg1);
  } else if (!strcmp(mnemonic, "dec")) {
    out->func = dec;
    return read_argument(in, &out->arg1);
  } else if (!strcmp(mnemonic, "jnz")) {
    out->func = jnz;
    return read_argument(in, &out->arg1) && read_argument(in, &out->arg2);
  } else if (!strcmp(mnemonic, "tgl")) {
    out->func = tgl;
    return read_argument(in, &out->arg1);
  } else {
    error(1, 0, "unknown mnemonic %s", mnemonic);
  }
  return false;
}

void read_program(State *state) {
  while (read_instruction(stdin, state->end)) {
    state->end++;
  }
}

int main() {
  State state;
  init_state(&state);

  read_program(&state);

  state.registers[0] = 7;
  while (state.pc != state.end) {
    state.pc = state.pc->func(state.pc, &state);
  }
  printf("%d\n", state.registers[0]);
  return 0;
}
