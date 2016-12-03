import sys

directions = sys.stdin.readline().strip().split(', ')
x = 0
y = 0
heading = 0
visited = set([(0, 0)])
for d in directions:
    if d[0] == 'R':
        heading += 1
        if heading == 4:
            heading = 0
    else:
        heading -= 1
        if heading == -1:
            heading = 3
    for _ in range(int(d[1:])):
        if heading == 0:
            y += 1
        elif heading == 1:
            x += 1
        elif heading == 2:
            y -= 1
        else:
            x -= 1
        if (x, y) in visited:
            print(abs(x) + abs(y))
            sys.exit(0)
        visited.add((x, y))
