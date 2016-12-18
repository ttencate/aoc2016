#!/usr/bin/lua

function count_safe_tiles(row)
  count = 0
  len = string.len(row)
  for i = 1, len do
    if row:sub(i, i) == '.' then
      count = count + 1
    end
  end
  return count
end

trap_patterns = {
  ["^^."] = "^",
  [".^^"] = "^",
  ["^.."] = "^",
  ["..^"] = "^",
}
setmetatable(trap_patterns, {__index = function() return "." end})

function next_row(row)
  len = string.len(row)
  extended_row = "." .. row .. "."
  next = ""
  for i = 1, len do
    pattern = extended_row:sub(i, i + 2)
    next = next .. trap_patterns[pattern]
  end
  return next
end

first_row = io.read("*line")
safe_tiles = 0
current_row = first_row
for i = 1, 40 do
  safe_tiles = safe_tiles + count_safe_tiles(current_row)
  current_row = next_row(current_row)
end
io.write(safe_tiles, "\n")
