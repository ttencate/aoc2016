import sys

buttons = [
    "  1  ",
    " 234 ",
    "56789",
    " ABC ",
    "  D  ",
]
row = 2
col = 0
code = ''
for line in sys.stdin.readlines():
    for char in line.strip():
        if char == 'U' and row > 0 and buttons[row-1][col] != ' ':
            row -= 1
        elif char == 'D' and row < 4 and buttons[row+1][col] != ' ':
            row += 1
        elif char == 'L' and col > 0 and buttons[row][col-1] != ' ':
            col -= 1
        elif char == 'R' and col < 4 and buttons[row][col+1] != ' ':
            col += 1
    code += buttons[row][col]
print(code)
