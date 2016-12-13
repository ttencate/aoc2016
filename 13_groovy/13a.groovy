#!/usr/bin/groovy

class Pos extends Tuple2 {

  Pos(x, y) { super(x, y) }
  def getX() { get(0) }
  def getY() { get(1) }

  def neighbors() {
    [
      new Pos(x + 1, y),
      new Pos(x - 1, y),
      new Pos(x, y - 1),
      new Pos(x, y + 1),
    ]
  }
}

def input = System.in.newReader().readLine().toInteger()

def popcount = {
  def count = 0
  while (it != 0) {
    if (it & 1) {
      count++
    }
    it >>= 1
  }
  return count
}

def isOpen = {
  def x = it.x
  def y = it.y
  x >= 0 && y >= 0 && popcount(x*x + 3*x + 2*x*y + y + y*y + input) % 2 == 0
}

def distance = { start, end ->
  def distanceTo = new HashMap()
  def queue = new LinkedList()

  distanceTo[start] = 0
  queue.addLast(start)

  while (!queue.empty) {
    def current = queue.removeFirst()
    if (current == end) {
      return distanceTo[current]
    }
    current.neighbors().each { neighbor ->
      if (isOpen(neighbor) && !(neighbor in distanceTo)) {
        distanceTo[neighbor] = distanceTo[current] + 1
        queue.addLast(neighbor)
      }
    }
  }
}

println distance(new Pos(1, 1), new Pos(31, 39))
