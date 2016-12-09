#!/usr/bin/env scala

object ThreeA extends App {
  println(io.Source.stdin.getLines
    .map(_.split("\\s+"))
    .map(_.map(_.trim).filter(!_.isEmpty))
    .map(_.map(_.toInt))
    .map(_.sorted)
    .count(sides => sides(0) + sides(1) > sides(2)))
}
