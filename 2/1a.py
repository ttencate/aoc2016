import sys

buttons = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
]
row = 1
col = 1
code = ''
for line in sys.stdin.readlines():
    for char in line.strip():
        if char == 'U' and row > 0:
            row -= 1
        elif char == 'D' and row < 2:
            row += 1
        elif char == 'L' and col > 0:
            col -= 1
        elif char == 'R' and col < 2:
            col += 1
    code += str(buttons[row][col])
print(code)
