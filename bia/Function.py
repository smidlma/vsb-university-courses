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
        return 100 * (params[1] - params[0] ** 2) ** 2 + (params[0] - 1) ** 2

    def rastrigin(self, params=[]):
        dimension = len(params)
        return 10 * dimension + (
            (params[0] ** 2 - 10 * np.cos(2 * np.pi * params[0]))
            + (params[1] ** 2 - 10 * np.cos(2 * np.pi * params[1]))
        )

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
        return -1 * (
            (np.sin(params[0]) * np.sin((1 * params[0] ** 2) / np.pi) ** 20)
            + (np.sin(params[1]) * np.sin((2 * params[1] ** 2) / np.pi) ** 20)
        )

    def ackley(self, params=[]) -> float:
        return (
            -20.0 * np.exp(-0.2 * np.sqrt(0.5 * (params[0] ** 2 + params[1] ** 2)))
            - np.exp(
                0.5 * (np.cos(2 * np.pi * params[0]) + np.cos(2 * np.pi * params[1]))
            )
            + np.e
            + 20
        )
        # a = 20
        # b = 0.2
        # c = 2 * np.pi
        # d = 2
        # sum_pow = 0
        # sum_cos = 0
        # for item in params:
        #     sum_pow += item**2
        #     sum_cos += np.cos(c * item)
        # return (
        #     -a * np.exp(-b * np.sqrt(1 / d * sum_pow))
        #     - np.exp(1 / d * (sum_cos))
        #     + a
        #     + np.e
        # )

    def __call__(self, params=[]) -> float:
        return getattr(self, self.name)(params)
