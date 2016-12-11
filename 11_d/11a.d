module eleven;

import std.algorithm;
import std.array;
import std.bitmanip;
import std.container;
import std.conv;
import std.regex;
import std.stdio;
import std.typecons;

const uint NUM_FLOORS = 4;
const uint BOTTOM_FLOOR = 0;
const uint TOP_FLOOR = NUM_FLOORS - 1;

const uint GENERATOR_TYPE = 0;
const uint MICROCHIP_TYPE = 1;
const uint GENERATOR_MASK = 0b01010101010101010101010101010101;
const uint MICROCHIP_MASK = 0b10101010101010101010101010101010;

alias Item = uint;
alias ItemSet = uint;

Item[string] elements;
Item[] allItems;
uint numElements;

struct State {
  ItemSet[NUM_FLOORS] floors;
  uint currentFloor;
  uint stepsTaken;
}

uint parseItem(char[] item) {
  auto ire = ctRegex!(r"^a ([a-z]+)( generator|-compatible microchip)$");
  auto match = item.matchFirst(ire);
  assert(!match.empty);
  auto element = match[1];
  auto type = match[2] == " generator" ? GENERATOR_TYPE : MICROCHIP_TYPE;
  if (!(element in elements)) {
    elements[element.idup] = to!uint(elements.length);
  }
  return 1 << (2 * elements[element] + type);
}

ItemSet parseFloor(char[] line) {
  auto re = ctRegex!(r"^The [^ ]+ floor contains (.*)\.$");
  auto match = line.matchFirst(re);
  assert(!match.empty);
  auto contents = match[1];
  if (contents == "nothing relevant") {
    return 0;
  } else {
    ItemSet items;
    auto cre = ctRegex!(r"(, and |, | and )");
    foreach (item; contents.split(cre)) {
      items |= parseItem(item);
    }
    return items;
  }
}

bool isEndState(State state) {
  return state.floors[TOP_FLOOR] == (1 << (numElements * 2)) - 1;
}

bool contains(ItemSet items, Item item) {
  return (items & item) != 0;
}

bool isSafe(ItemSet items) {
  uint generators = items & GENERATOR_MASK;
  uint unpairedMicrochips = items & MICROCHIP_MASK & ~(generators << 1);
  return !generators || !unpairedMicrochips;
}

bool isSafe(State state) {
  return state.floors[].all!isSafe;
}

bool moveItem(ref State state, Item item, uint from, uint to) {
  auto fromItems = state.floors[from] & ~item;
  auto toItems = state.floors[to] | item;
  if (!fromItems.isSafe || !toItems.isSafe) {
    return false;
  }
  state.floors[from] = fromItems;
  state.floors[to] = toItems;
  return true;
}

void main() {
  auto floors = stdin
    .byLine()
    .map!(parseFloor)
    .array();
  numElements = to!uint(elements.length);

  auto startState = State(floors[0..NUM_FLOORS], BOTTOM_FLOOR, 0);

  auto queue = DList!State();
  queue.insertBack(startState);
  while (!queue.empty) {
    auto state = queue.front();
    queue.removeFront();

    if (state.isEndState()) {
      writeln(state.stepsTaken);
      break;
    }

    foreach (uint direction; [1, -1]) {
      uint fromFloor = state.currentFloor;
      uint toFloor = fromFloor + direction;
      if (toFloor < BOTTOM_FLOOR || toFloor > TOP_FLOOR) {
        continue;
      }

      State baseNextState = state;
      baseNextState.currentFloor = toFloor;
      baseNextState.stepsTaken++;

      auto items = bitsSet(state.floors[state.currentFloor])
        .map!(bit => to!Item(1 << bit));

      foreach (Item item; items) {
        State nextState = baseNextState;
        nextState.moveItem(item, fromFloor, toFloor);
        if (nextState.isSafe) {
          queue.insertBack(nextState);
        }
      }

      foreach (Item item1; items) {
        foreach (Item item2; items) {
          if (item2 <= item1) {
            continue;
          }
          State nextState = baseNextState;
          nextState.moveItem(item1 | item2, fromFloor, toFloor);
          if (nextState.isSafe) {
            queue.insertBack(nextState);
          }
        }
      }
    }
  }
}
