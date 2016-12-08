import sys

count = 0
for line in sys.stdin.readlines():
    tri = list(map(int, line.split()))
    def test(a, b, c):
        return tri[a] + tri[b] > tri[c]
    if test(0, 1, 2) and test(1, 2, 0) and test(2, 0, 1):
        count += 1
print(count)
