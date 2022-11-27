from Function import VALID_FUNCTION_NAMES, Function
from Solution import Solution, Tsp
import numpy as np
import matplotlib.pyplot as plt


def main():
    functions = {
        "ackley": Function("ackley", -32.768, 32.768),
        "griewank": Function("griewank", -600, 600),
        "levy": Function("levy", -10, 10),
        "michalewicz": Function("michalewicz", 0, np.pi),
        "rastrigin": Function("rastrigin", -5.12, 5.12),
        "rosenbrock": Function("rosenbrock", -5, 10),
        "schwefel": Function("schwefel", -500, 500),
        "sphere": Function("sphere", -5.12, 5.12),
        "zakharov": Function("zakharov", -5, 10),
    }

    # Solution visualization
    for name in VALID_FUNCTION_NAMES:
        f = functions.get(name)
        solution = Solution(2, f)
        solution.firefly()
        plt.show()

    # TSP visualization
    # s = Tsp(20, 0, 350, 350)
    # s.aco()


if __name__ == "__main__":
    main()
