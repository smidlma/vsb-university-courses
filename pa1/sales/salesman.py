from itertools import permutations
from math import sqrt


def calc_distance(p1, p2):
    return sqrt((p2[0] - p1[0]) ** 2 + (p2[1] - p1[1]) ** 2)


def calc_path(path):
    distance = 0

    for i in range(len(path) - 1):

        distance = distance + calc_distance(
            (path[i][1], path[i][2]), (path[i + 1][1], path[i + 1][2])
        )
    ids = [x[0] for x in path]
    return (ids, distance)


def tsp():
    cities = [
        (1, 38.24, 20.42),
        (2, 39.57, 26.15),
        (3, 40.56, 25.32),
        (4, 36.26, 23.12),
        (5, 33.48, 10.54),
        (6, 37.56, 12.19),
        # (7, 38.42, 13.11),
        # (8, 37.52, 20.44),
        # (9, 41.23, 9.10),
    ]

    paths = permutations(cities)

    result = map(calc_path, paths)
    final = None
    for r in result:
        min = 9999

        if r[1] < min:
            min = r[1]
            final = r

    print(final)


tsp()
