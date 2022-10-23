from calendar import c
from copy import deepcopy
from math import sqrt
from tkinter import N
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from Function import Function


class Solution:
    def __init__(self, dimension, function: Function) -> None:
        self.dimension = dimension
        self.lower_bound = function.lower_bound
        self.upper_bound = function.upper_bound
        self.parameters = np.zeros(self.dimension)  # solution parameters
        self.function = function  # objective function evaluation
        self.fig = plt.figure()
        self.ax = plt.axes(projection="3d")
        self.ax.set_title(f"Function: {self.function.name}")
        self.anim = None

    def draw_surface(self):
        X = np.linspace(self.lower_bound, self.upper_bound)
        Y = np.linspace(self.lower_bound, self.upper_bound)
        X, Y = np.meshgrid(X, Y)
        Z = self.function([X, Y])
        self.ax.plot_surface(X, Y, Z, cmap="jet", shade="true", alpha=0.2)

    def show(self, points: list, interval=250):
        # points - len(points) = number of iterations
        # correct points structure example
        # points = [[self.generate_random()], [self.generate_random(), self.generate_random()]]
        def update_points(steps, x=[], y=[], z=[], points=[]):
            # update properties
            if steps < len(x):
                points.set_data(x[steps], y[steps])
                points.set_3d_properties(z[steps], "z")
                # return modified artists
                return points
            else:
                print("Anim ended")

        x = []
        y = []
        z = []
        for i in range(len(points)):
            step = points[i]
            tmp_x = []
            tmp_y = []
            tmp_z = []
            for j in range(len(step)):
                tmp_x.append(step[j][0])  # add x
                tmp_y.append(step[j][1])  # add y
                tmp_z.append(step[j][2])  # add y
            x.append(tmp_x)
            y.append(tmp_y)
            z.append(tmp_z)
        (points,) = self.ax.plot(x[0][0], y[0][0], z[0][0], "bo")
        self.anim = animation.FuncAnimation(
            fig=self.fig,
            func=update_points,
            fargs=(x, y, z, points),
            init_func=self.draw_surface,
            interval=interval,
            frames=len(x) + 1,
            repeat=True,
        )

    def generate_random(self, high=None, low=None):
        if not high:
            high = self.upper_bound
        if not low:
            low = self.lower_bound
        result = np.random.uniform(low=low, high=high, size=self.dimension).tolist()
        result.append(self.function([result[0], result[1]]))
        return result

    def blind_search(self):
        points = []
        iterations = 20
        generation_size = 20
        init_solution = self.generate_random()
        # take first initial_solution and made it global extremne
        global_extreme_point = init_solution
        points.append([init_solution])
        for i in range(iterations):
            new_generation = [self.generate_random() for idx in range(generation_size)]
            generation_extreme_point = min(new_generation, key=lambda point: point[2])
            if generation_extreme_point[2] < global_extreme_point[2]:
                global_extreme_point = generation_extreme_point
            points.append([global_extreme_point])

        self.show(points)

    def generate_neighbours(self, point=[], count=5, sigma=0.8):
        neighbours = []
        for idx in range(count):
            p = []
            for idx in range(self.dimension):
                val = np.random.normal(point[idx], sigma)
                if val > self.upper_bound:
                    # print(val)
                    val = self.upper_bound
                elif val < self.lower_bound:
                    # print(val)
                    val = self.lower_bound
                p.append(val)
            p.append(self.function(p))
            neighbours.append(p)
        return neighbours

    def hill_climbing(self):
        points = []
        generations = 200
        generation_size = 50
        init_point = self.generate_random()
        global_extreme_point = init_point
        points.append([init_point])
        for _ in range(generations):
            new_generation = self.generate_neighbours(
                point=global_extreme_point, count=generation_size, sigma=0.8
            )
            generation_extreme_point = min(new_generation, key=lambda point: point[2])
            if generation_extreme_point[2] < global_extreme_point[2]:
                global_extreme_point = generation_extreme_point
            points.append([global_extreme_point])

        self.show(points)

    def simulated_annealing(self):
        points = []
        T_0 = 100
        T_min = 0.1
        alpha = 0.90
        T = T_0
        init_point = self.generate_random()
        global_extreme_point = init_point
        points.append([init_point])
        sigma = self.upper_bound / 12
        print(f"sigma: {sigma}")
        while T > T_min:
            new_point = self.generate_neighbours(
                point=global_extreme_point, count=1, sigma=sigma
            )[0]
            # print(new_point)
            if new_point[2] < global_extreme_point[2]:
                global_extreme_point = new_point
            else:
                r = np.random.uniform(low=0, high=1, size=1)[0]
                condition = np.e ** -(new_point[2] - global_extreme_point[2]) / T
                if r < condition:
                    global_extreme_point = new_point
            T = T * alpha
            points.append([global_extreme_point])

        self.show(points)

    def check_boundaries(self, v):
        if v[0] > self.upper_bound:
            v[0] = self.upper_bound
        if v[0] < self.lower_bound:
            v[0] = self.lower_bound

        if v[1] > self.upper_bound:
            v[1] = self.upper_bound
        if v[1] < self.lower_bound:
            v[1] = self.lower_bound
        return v

    def differential_evolution(self):
        NP = 20
        F = 0.5
        CR = 0.5
        G_max = 50
        G_curr = 0
        points = []

        population = [self.generate_random() for idx in range(NP)]
        points.append(population)

        while G_curr < G_max:
            new_popopulation = deepcopy(population)
            for i, x in enumerate(population):
                r1_pop = list(filter(lambda p: p != x, population))
                r1 = r1_pop[np.random.randint(0, len(r1_pop) - 1)]
                r2_pop = list(filter(lambda p: p != x and p != r1, population))
                r2 = r2_pop[np.random.randint(0, len(r2_pop) - 1)]
                r3_pop = list(
                    filter(lambda p: p != x and p != r1 and p != r2, population)
                )
                r3 = r3_pop[np.random.randint(0, len(r3_pop) - 1)]

                v = [(r1[0] - r2[0]) * F + r3[0], (r1[1] - r2[1]) * F + r3[1]]
                v = self.check_boundaries(v)
                u = np.zeros(self.dimension)
                j_rnd = np.random.randint(0, self.dimension)

                for j in range(self.dimension):
                    if np.random.uniform() < CR or j == j_rnd:
                        u[j] = v[j]
                    else:
                        u[j] = x[j]
                f_u = self.function([u[0], u[1]])
                if f_u <= x[2]:
                    new_popopulation[i] = [u[0], u[1], f_u]
            population = new_popopulation
            points.append(new_popopulation)
            G_curr = G_curr + 1
        self.show(points)


# pop = Generate NP random individuals (you can use the class Solution mentioned in Exercise 1)
# g = 0

# while g < g_maxim :
#   new_pop = deepcopy(pop) # new generation
#   for each i, x in enumerate(pop): # x is also denoted as a target vector
#     r1, r2, r3 = select random indices(from 0 to NP-1) such that r1!=r2!=r3!=i
#     v = (x_r1.params – x_r2.params)*F + x_r3.params # mutation vector. TAKE CARE FOR BOUNDARIES!
#     u = np.zeros(dimension) # trial vector
#     j_rnd = np.random.randint(0, dimension)

#     for j in range(dimension):
# 	if np.random.uniform() < CR or j == j_rnd:
# 	  u[j] = v[j] # at least 1 parameter should be from a mutation vector v
# 	else:
# 	  u[j] = x_i.params[j]

#     f_u = Evaluate trial vector u

#     if f_u is better or equals to f_x_i: # We always accept a solution with the same fitness as a target vector
# 	new_x = Solution(dimension, lower_bound, upper_bound)
#           new_x.params = u
#           new_x.f = f_u
#     pop = new_pop
#   g += 1


class Tsp:
    def __init__(self, number_of_nodes, min, max, population_size) -> None:
        self.number_of_nodes = number_of_nodes
        self.min = min
        self.max = max
        self.population_size = population_size

    def evaluate(self, path, dist):
        res = 0
        for idx in range(len(path) - 1):
            res = res + dist[path[idx]["id"]][path[idx + 1]["id"]]
        return res

    def crossover(self, parent_A, parent_B):
        offspring = []
        border = np.random.randint(1, self.number_of_nodes)
        for i in range(border):
            offspring.append(parent_A[i])
        rest_of_towns = list(filter(lambda x: x not in offspring, parent_B))
        return [*offspring, *rest_of_towns]

    def mutate(self, offspring_AB):
        t1_idx = np.random.randint(1, self.number_of_nodes)
        t2_idx = np.random.randint(1, self.number_of_nodes)
        tmp = offspring_AB[t1_idx]
        offspring_AB[t1_idx] = offspring_AB[t2_idx]
        offspring_AB[t2_idx] = tmp
        return offspring_AB

    def calc_distance(self, c1, c2):
        return sqrt((c2["x"] - c1["x"]) ** 2 + (c2["y"] - c1["y"]) ** 2)

    def print_distance_matrix(self, dist):
        for i in range(len(dist)):
            print(dist[i])

    def tsp(self):
        start_city = {
            "id": 0,
            "x": np.random.randint(self.min, self.max),
            "y": np.random.randint(self.min, self.max),
        }
        cities = [
            {
                "id": idx + 1,
                "x": np.random.randint(self.min, self.max),
                "y": np.random.randint(self.min, self.max),
            }
            for idx in range(self.number_of_nodes - 1)
        ]
        cities_tmp = [start_city, *cities]
        distance_matrix = [
            [
                self.calc_distance(cities_tmp[i], cities_tmp[j])
                for j in range(len(cities_tmp))
            ]
            for i in range(len(cities_tmp))
        ]

        NP = self.number_of_nodes
        G = self.population_size
        population = [[start_city, *np.random.permutation(cities)] for i in range(NP)]
        evaluation = list(map(lambda x: self.evaluate(x, distance_matrix), population))
        paths = []

        paths.append(population[evaluation.index(min(evaluation))])

        for i in range(G):
            new_population = population.copy()
            for j in range(NP):
                parent_A = population[j]
                parent_B_index = np.random.randint(1, NP)
                while parent_B_index == j:
                    parent_B_index = np.random.randint(1, NP)
                parent_B = population[parent_B_index]
                offspring_AB = self.crossover(parent_A, parent_B)

                if np.random.uniform(0, 1) < 0.5:
                    offspring_AB = self.mutate(offspring_AB)
                offspring_eval = self.evaluate(offspring_AB, distance_matrix)
                parent_A_eval = self.evaluate(parent_A, distance_matrix)
                if offspring_eval < parent_A_eval:
                    new_population[j] = offspring_AB
            population = new_population

            evaluation = list(
                map(lambda x: self.evaluate(x, distance_matrix), population)
            )
            best_pop = population[evaluation.index(min(evaluation))]
            best_pop.append(start_city)
            # print(best_pop)
            # exit()
            paths.append(best_pop)

        self.show(paths)

    def show(self, paths):
        x = list(map(lambda towns: list(map(lambda town: town["x"], towns)), paths))
        y = list(map(lambda towns: list(map(lambda town: town["y"], towns)), paths))
        fig, ax = plt.subplots()
        (ln,) = plt.plot([], [], "ro-", animated=True)
        text = ax.text(
            -30,
            self.max + 10,
            "",
            ha="left",
            va="bottom",
            clip_on=True,
            rotation=0,
            fontsize=12,
        )

        def init():
            ax.set_xlim(self.min - 30, self.max + 30)
            ax.set_ylim(self.min - 30, self.max + 30)
            return (ln, text)

        def update(frame):
            ln.set_data(x[frame], y[frame])
            text.set_text(f"Generation {frame}")
            return (ln, text)

        ani = animation.FuncAnimation(
            fig,
            update,
            frames=range(len(paths)),
            init_func=init,
            interval=50,
            blit=True,
        )
        plt.show()
