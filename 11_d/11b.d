module eleven;

import std.algorithm;
import std.array;
import std.bitmanip;
import std.container;
import std.conv;
import std.format;
import std.range;
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

Item[string] elements;
Item[] allItems;
uint numElements;

struct ItemSet {
  uint mask;

  void add(Item item) {
    assert(!contains(item));
    mask |= item;
  }

  void remove(Item item) {
    assert(contains(item));
    mask &= ~item;
  }

  bool contains(Item item) const pure {
    return !!(mask & item);
  }

  uint count() const {
    uint count = 0;
    foreach (ulong bit; iota(0, numElements * 2)) {
      if (contains(to!Item(1 << bit))) {
        count++;
      }
    }
    return count;
  }

  bool isSafe() const pure {
    uint generators = mask & GENERATOR_MASK;
    uint unpairedMicrochips = mask & MICROCHIP_MASK & ~(generators << 1);
    return !generators || !unpairedMicrochips;
  }

  bool isFull() const {
    return mask == (1 << (numElements * 2)) - 1;
  }

  int opApply(int delegate(Item item) dg) {
    int result = 0;
    foreach (ulong bit; iota(0, numElements * 2)) {
      Item item = to!Item(1 << bit);
      if (contains(item)) {
        result = dg(item);
        if (result) {
          break;
        }
      }
    }
    return result;
  }
}

struct State {
  ItemSet[NUM_FLOORS] floors;
  uint currentFloor;

  string toString() const {
    char[] output;
    foreach_reverse (floor; iota(0, NUM_FLOORS)) {
      output ~= format("F%d %s  ", floor + 1, floor == currentFloor ? "E" : ".");
      foreach (bit; iota(0, 2 * numElements)) {
        auto item = to!Item(1 << bit);
        if (floors[floor].contains(item)) {
          output ~= format("%s%d ", item & MICROCHIP_MASK ? "M" : "G", bit / 2);
        } else {
          output ~= ".  ";
        }
      }
      output ~= "\n";
    }
    return output.idup;
  }

  bool isSafe() const pure {
    return floors[].all!(floor => floor.isSafe);
  }

  bool isEndState() const {
    return floors[TOP_FLOOR].isFull;
  }
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
    return ItemSet();
  } else {
    ItemSet items;
    auto cre = ctRegex!(r"(, and |, | and )");
    foreach (item; contents.split(cre)) {
      items.add(parseItem(item));
    }
    return items;
  }
}

void moveItem(ref State state, Item item, uint from, uint to) {
  state.floors[from].remove(item);
  state.floors[to].add(item);
}

uint heuristicCostEstimate(State state) {
  uint itemSteps = 0;
  foreach (floor, items; enumerate(state.floors[])) {
    itemSteps += items.count * (TOP_FLOOR - floor);
  }
  return itemSteps / 2; // Lift carries at most two items at a time.
}

void printBacktrace(State state, State[State] cameFrom) {
  auto stack = Array!(State)([state]);
  while (state in cameFrom) {
    state = cameFrom[state];
    stack.insertBack(state);
  }
  foreach_reverse (previousState; stack) {
    writeln(previousState);
  }
  writeln(stack.length - 1);
}

void main() {
  auto floors = stdin
    .byLine()
    .map!(parseFloor)
    .array();
  floors[0].add(to!Item(1 << (2 * elements.length)));
  floors[0].add(to!Item(1 << (2 * elements.length + 1)));
  floors[0].add(to!Item(1 << (2 * elements.length + 2)));
  floors[0].add(to!Item(1 << (2 * elements.length + 3)));
  numElements = to!uint(elements.length) + 2;

  auto start = State(floors[0..NUM_FLOORS], BOTTOM_FLOOR);

  uint[State] gScore;
  uint[State] fScore;
  bool[State] closedSet;
  bool[State] openSet;
  bool less(State a, State b) { return fScore.get(a, uint.max) > fScore.get(b, uint.max); };
  auto queue = heapify!(less)(Array!State());
  State[State] cameFrom;

  fScore[start] = heuristicCostEstimate(start);
  gScore[start] = 0;
  queue.insert(start);
  openSet[start] = true;

  while (!queue.empty) {
    auto current = queue.front;

    if (current.isEndState()) {
      printBacktrace(current, cameFrom);
      return;
    }

    openSet.remove(current);
    queue.removeFront();
    closedSet[current] = true;

    uint fromFloor = current.currentFloor;
    foreach (uint toFloor; [fromFloor + 1, fromFloor - 1]) {
      if (toFloor < BOTTOM_FLOOR || toFloor > TOP_FLOOR) {
        continue;
      }

      State baseNextState = current;
      baseNextState.currentFloor = toFloor;

      auto items = current.floors[current.currentFloor];
      foreach (Item item1; items) {
        foreach (Item item2; items) {
          if (item2 < item1) {
            continue;
          }

          State neighbor = baseNextState;
          neighbor.moveItem(item1 | item2, fromFloor, toFloor);
          if (!neighbor.isSafe) {
            continue;
          }

          if (neighbor in closedSet) {
            continue;
          }

          auto tentativeGScore = gScore[current] + 1;
          if (!(neighbor in openSet)) {
            openSet[neighbor] = true;
            queue.insert(neighbor);
          } else if (tentativeGScore >= gScore.get(neighbor, uint.max)) {
            continue;
          }

          cameFrom[neighbor] = current;
          gScore[neighbor] = tentativeGScore;
          fScore[neighbor] = gScore[neighbor] + heuristicCostEstimate(neighbor);
        }
      }
    }
  }
}
