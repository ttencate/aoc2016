#!/usr/bin/ocaml

#load "str.cma"

open List

type register =
  Register of string

let parse_register register = match register with
    | "a" | "b" | "c" | "d" -> Register register
    | _ -> failwith "invalid register"

type rvalue =
  | RegRValue of register
  | IntRValue of int

let parse_rvalue rvalue =
  try IntRValue (int_of_string rvalue)
  with Failure _ -> RegRValue (parse_register rvalue)

type instruction =
  | Cpy of rvalue * register
  | Jnz of rvalue * rvalue
  | Inc of register
  | Dec of register

let parse_instruction line =
  let split_words = Str.split (Str.regexp " +") in
  match split_words line with
    | ["cpy"; source; dest] -> Cpy ((parse_rvalue source), (parse_register dest))
    | ["jnz"; cond; offset] -> Jnz ((parse_rvalue cond), (parse_rvalue offset))
    | ["inc"; register] -> Inc (parse_register register)
    | ["dec"; register] -> Dec (parse_register register)
    | _ -> failwith (Printf.sprintf "invalid instruction %s" line)

module Registers = Map.Make(struct type t = register let compare = compare end)

let get_register registers register =
  if Registers.mem register registers then Registers.find register registers else 0

let set_register registers register value =
  Registers.add register value registers

type state = {
  program: instruction array;
  pc: int;
  registers: int Registers.t
}

let is_done state = state.pc < 0 || state.pc >= Array.length state.program

let eval_rvalue state rvalue = match rvalue with
  | IntRValue value -> value
  | RegRValue register -> get_register state.registers register

let run_instruction state =
  match state.program.(state.pc) with
    | Cpy (source, dest) -> {
        state with
        pc = state.pc + 1;
        registers = set_register state.registers dest (eval_rvalue state source)
      }
    | Jnz (cond, offset) -> {
        state with
        pc = if (eval_rvalue state cond) != 0 then state.pc + (eval_rvalue state offset) else state.pc + 1
      }
    | Inc register -> {
        state with
        pc = state.pc + 1;
        registers = set_register state.registers register ((get_register state.registers register) + 1)
      }
    | Dec register -> {
        state with
        pc = state.pc + 1;
        registers = set_register state.registers register ((get_register state.registers register) - 1)
      }

let input_lines fd =
  let option_line fd = try Some (input_line fd) with End_of_file -> None in
  let rec f acc = match option_line fd with
    | None -> rev acc
    | Some line -> f (line :: acc) in
  f []

let () =
  let program = Array.of_list (map parse_instruction (input_lines stdin)) in
  let rec f state = if is_done state then state else f (run_instruction state) in
  let final_state = f { program = program; pc = 0; registers = Registers.empty } in
  Printf.printf "%d\n" (get_register final_state.registers (Register "a"))
