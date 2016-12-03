import sys

directions = sys.stdin.readline().strip().split(', ')
x = 0
y = 0
heading = 0
for d in directions:
    if d[0] == 'R':
        heading += 1
        if heading == 4:
            heading = 0
    else:
        heading -= 1
        if heading == -1:
            heading = 3
    dist = int(d[1:])
    if heading == 0:
        y += dist
    elif heading == 1:
        x += dist
    elif heading == 2:
        y -= dist
    else:
        x -= dist
print(abs(x) + abs(y))
