from Function import VALID_FUNCTION_NAMES, Function
from Solution import Solution, Tsp
import numpy as np
import matplotlib.pyplot as plt

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

EXPERIMENTS = 30
DIMENSIONS = 30


def generate_report():
    # Solution for document outcome
    for name in VALID_FUNCTION_NAMES:
        f = functions.get(name)
        file = open(f"results/{name}.txt", "w")
        file.write(f"###### {name} ######\n")
        solution = Solution(DIMENSIONS, f)
        # DE
        file.write("## DE ##\n")
        for i in range(EXPERIMENTS):
            res = solution.differential_evolution()
            if res is not None:
                res = res[DIMENSIONS]
            f.FUNCTION_CALLS = 0
            file.write(f"{res}\n")
        file.write("\n")
        # PSO
        file.write("## PSO ##\n")
        for i in range(EXPERIMENTS):
            res = solution.particle_swarm()
            if res is not None:
                res = res[DIMENSIONS]
            f.FUNCTION_CALLS = 0
            file.write(f"{res}\n")
        file.write("\n")
        # SOMA
        file.write("## SOMA ##\n")
        for i in range(EXPERIMENTS):
            res = solution.soma()
            if res is not None:
                res = res[DIMENSIONS]
            f.FUNCTION_CALLS = 0
            file.write(f"{res}\n")
        file.write("\n")
        # # FA
        file.write("## FA ##\n")
        for i in range(EXPERIMENTS):
            res = solution.firefly()
            if res is not None:
                res = res[DIMENSIONS]
            f.FUNCTION_CALLS = 0
            file.write(f"{res}\n")
        file.write("\n")

        # TLBO
        file.write("## TLBO ##\n")
        for i in range(EXPERIMENTS):
            res = solution.teaching_learning_base()
            if res is not None:
                res = res[DIMENSIONS]
            f.FUNCTION_CALLS = 0
            file.write(f"{res}\n")
        file.close()


def visualize():
    # Solution visualization
    for name in VALID_FUNCTION_NAMES:
        f = functions.get(name)
        solution = Solution(2, f)
        solution.teaching_learning_base()
        plt.show()


def main():
    # visualize()
    generate_report()

    # TSP visualization
    # s = Tsp(20, 0, 350, 350)
    # s.aco()


if __name__ == "__main__":
    main()
