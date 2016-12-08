import sys

tris = [[], [], []]
count = 0
for line in sys.stdin.readlines():
    nums = list(map(int, line.split()))
    tris[0].append(nums[0])
    tris[1].append(nums[1])
    tris[2].append(nums[2])
    if len(tris[0]) == 3:
        for tri in tris:
            def test(a, b, c):
                return tri[a] + tri[b] > tri[c]
            if test(0, 1, 2) and test(1, 2, 0) and test(2, 0, 1):
                count += 1
        tris = [[], [], []]
print(count)
