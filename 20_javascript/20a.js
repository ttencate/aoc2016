#!/usr/bin/env node

const fs = require('fs');
const input = fs.readFileSync('/dev/stdin').toString();
const lines = input.split('\n').filter(line => line.indexOf('-') > 0);
const ranges = lines.map((line) => {
  const parts = line.split('-');
  return {
    start: parseInt(parts[0], 10),
    end: parseInt(parts[1], 10),
  };
});
ranges.sort((a, b) => {
  if (a.start < b.start) return -1;
  if (a.start > b.start) return 1;
  return 0;
});

let candidate = 0;
for (let i = 0; i < ranges.length; i++) {
  const range = ranges[i];
  if (candidate < range.start) {
    break;
  }
  candidate = Math.max(candidate, range.end + 1);
}
console.log(candidate);
