import numpy as np

VALID_FUNCTION_NAMES = [
    "ackley",
    "griewank",
    "sphere",
    "levy",
    "michalewicz",
    "rastrigin",
    "rosenbrock",
    "schwefel",
    "zakharov",
]


class Function:
    def __init__(self, name, lower_bound, upper_bound) -> None:
        if name not in VALID_FUNCTION_NAMES:
            raise Exception(f"Function {name} is not valid.")
        self.name = name
        self.lower_bound = lower_bound
        self.upper_bound = upper_bound
        self.id = VALID_FUNCTION_NAMES.index(name)
        self.FUNCTION_CALLS = 0

    def sphere(self, params=[]) -> float:
        sum = 0
        for item in params:
            sum += item**2
        return (1 / 899) * (sum)

    def zakharov(self, params=[]) -> float:
        dimension = len(params)
        sum1, sum2, sum3, result = 0.0, 0.0, 0.0, 0.0
        for i in range(dimension):
            sum1 = params[i] ** 2
            sum2 = (0.5 * i * params[i]) ** 2
            sum3 = (0.5 * i * params[i]) ** 4
            result += sum1 + sum2 + sum3
        return result

    def schwefel(self, params=[]):
        dimension = len(params)
        sum = 0.0
        for i in params:
            sum += i * np.sin(np.sqrt(abs(i)))
        return 418.9829 * dimension - sum

    def rosenbrock(self, params=[]):
        x = np.array(params)
        x0 = x[:-1]
        x1 = x[1:]
        return sum((1 - x0) ** 2) + 100 * sum((x1 - x0**2) ** 2)

    def rastrigin(self, params=[]):
        fitness_value = 0.0
        for i in range(len(params)):
            xi = params[i]
            fitness_value += (xi * xi) - (10 * np.cos(2 * np.pi * xi)) + 10
        return fitness_value

    def griewank(self, params=[]):
        sum1, sum2 = 0.0, 0.0
        for index, item in enumerate(params):
            sum1 += (item**2) / 4000
            sum2 *= np.cos(item / (np.sqrt(index + 1)))
        return sum1 - sum2 + 1

    def levy(self, params=[]):
        dimension = len(params)
        w = 0.0
        w_d = 1 + (params[dimension - 1] - 1) / 4
        tmp = 0.0
        sum = 0.0
        for item in params:
            w = 1 + (item - 1) / 4
            tmp = ((w - 1) ** 2) * (1 + 10 * np.sin(np.pi * w + 1) ** 2) + (
                w_d - 1
            ) ** 2 * (1 + np.sin(2 * np.pi * w_d))
            sum += tmp
        return sum

    def michalewicz(self, params=[]):
        tmp = 0
        for i in range(len(params)):
            tmp += np.sin(params[i]) * np.sin((i + 1 * params[i] ** 2) / np.pi) ** 20
        return -1 * tmp

    def ackley(self, params=[]) -> float:
        a = 20
        b = 0.2
        c = 2 * np.pi
        x = np.array(params)  # ValueError if any NaN or Inf
        n = len(x)
        s1 = sum(x**2)
        s2 = sum(np.cos(c * x))
        return -a * np.exp(-b * np.sqrt(s1 / n)) - np.exp(s2 / n) + a + np.exp(1)

    def __call__(self, params=[]) -> float:
        if self.FUNCTION_CALLS >= 3000:
            raise Exception
        self.FUNCTION_CALLS += 1
        return getattr(self, self.name)(params)
