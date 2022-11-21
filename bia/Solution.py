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

    def particle_swarm(self):
        def update_velocity(particle, velocity, pbest, gbest, itteration):
            new_velocity = np.array([0.0 for i in range(self.dimension)])
            r1 = np.random.uniform(0, 1)
            r2 = np.random.uniform(0, 1)
            for i in range(self.dimension):
                new_velocity[i] = (
                    inertia_weight(itteration) * velocity[i]
                    + c1 * r1 * (pbest[i] - particle[i])
                    + c2 * r2 * (gbest[i] - particle[i])
                )
            return new_velocity

        def calculate_pos(x, veloctity):
            new_pos = []
            for i in range(self.dimension):
                new_pos.append(x[i] + veloctity[i])
            tmp = self.check_boundaries(new_pos)
            tmp.append(self.function(tmp))
            return tmp

        def inertia_weight(i):
            return w_s - ((w_s - w_e) * i / M_max)

        v_min = self.upper_bound / 50
        v_max = self.upper_bound / 20
        pop_size = 15
        c1 = 0.5
        c2 = 0.5
        M_max = 50
        w_s = 0.9
        w_e = 0.4
        m = 0
        points = []

        swarm = [self.generate_random() for idx in range(pop_size)]
        gBest = min(swarm, key=lambda point: point[2])
        pBest = swarm
        velocity_vectors = [
            update_velocity(x, [v_min, v_min], pBest[idx], gBest, 0)
            for idx, x in enumerate(swarm)
        ]

        points.append(swarm)

        while m < M_max:
            tmp = swarm.copy()
            for idx, x in enumerate(tmp):
                v_tmp = update_velocity(
                    x, velocity_vectors[idx], pBest[idx], gBest, idx
                )
                velocity_vectors[idx] = v_tmp
                new_x = calculate_pos(x, v_tmp)
                tmp[idx] = new_x
                if tmp[idx][2] < pBest[idx][2]:
                    pBest[idx] = new_x
                if pBest[idx][2] < gBest[2]:
                    gBest = new_x

            points.append(tmp)
            swarm = tmp
            m = m + 1

        self.show(points)

    def soma(self):
        def get_prt_vector():
            return [
                1 if np.random.uniform() < PRT else 0 for idx in range(self.dimension)
            ]

        POP_SIZE = 20  # 20
        PRT = 0.4
        PATH_LEN = 3.0
        STEP = 0.11
        M_MAX = 50
        migrations = 0

        points = []

        population = [self.generate_random() for i in range(POP_SIZE)]
        leader_idx = population.index(
            min(population, key=lambda point: point[self.dimension])
        )

        points.append(population)
        while migrations < M_MAX:
            tmp_pop = population.copy()
            for idx in range(len(tmp_pop)):
                if idx != leader_idx:
                    prt_vec = get_prt_vector()
                    start = tmp_pop[idx]
                    t = 0
                    while t <= PATH_LEN:
                        tmp_local = [
                            start[j]
                            + (tmp_pop[leader_idx][j] - start[j]) * t * prt_vec[j]
                            for j in range(self.dimension)
                        ]
                        tmp_local = self.check_boundaries(tmp_local)
                        tmp_local.append(self.function(tmp_local))
                        if tmp_local[self.dimension] < tmp_pop[idx][self.dimension]:
                            tmp_pop[idx] = tmp_local
                        t = t + STEP

            leader_idx = tmp_pop.index(
                min(tmp_pop, key=lambda point: point[self.dimension])
            )
            points.append(tmp_pop)
            population = tmp_pop
            migrations = migrations + 1

        self.show(points)

    def firefly(self):
        def distance(f1, f2):
            return np.sqrt((f2[0] - f1[0]) ** 2 + (f2[1] - f1[1]) ** 2)

        def light_intensity(i_orig, r):
            return i_orig * np.e ** (-GAMA * r)

        def attractivness(r):
            return BETA_0 / (1 + r)

        def update_position(f1, f2):
            new_pos = []
            for idx in range(self.dimension):
                new_pos.append(
                    f1[idx]
                    + attractivness(distance(f1, f2)) * (f2[idx] - f1[idx])
                    + ALPHA * np.random.normal()
                )
            new_pos = self.check_boundaries(new_pos)
            new_pos.append(self.function(new_pos))
            return new_pos

        ALPHA = 0.3
        BETA_0 = 1
        GAMA = 1
        MAX_GENERATION = 50
        POPULATION_SIZE = 25
        population = [self.generate_random() for i in range(POPULATION_SIZE)]
        best_firefly_idx = population.index(
            min(population, key=lambda point: point[self.dimension])
        )
        t = 0
        points = []

        while t < MAX_GENERATION:
            tmp_pop = population.copy()
            for i in range(POPULATION_SIZE):
                if i == best_firefly_idx:
                    tmp_best = self.generate_random()
                    if tmp_pop[best_firefly_idx][2] > tmp_best[2]:
                        tmp_pop[best_firefly_idx] = tmp_best
                else:
                    for j in range(POPULATION_SIZE):
                        r = distance(tmp_pop[i], tmp_pop[j])
                        if light_intensity(tmp_pop[j][2], r) < light_intensity(
                            tmp_pop[i][2], r
                        ):
                            tmp_pop[i] = update_position(tmp_pop[i], tmp_pop[j])

                best_firefly_idx = tmp_pop.index(
                    min(tmp_pop, key=lambda point: point[self.dimension])
                )
            population = tmp_pop
            points.append(tmp_pop)
            t = t + 1

        self.show(points)


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
        print(paths)
        self.show(paths)

    def aco(self):
        def eval_path(path):
            total_distance = 0
            for i in range(len(path) - 1):
                total_distance = total_distance + distance_matrix[path[i]][path[i + 1]]
            return total_distance

        ALPHA = 1
        BETA = 2
        RHO = 0.5
        Q = 1
        MAX_MIGRATIONS = 200
        cities = [
            {
                "id": idx,
                "x": np.random.randint(self.min, self.max),
                "y": np.random.randint(self.min, self.max),
            }
            for idx in range(self.number_of_nodes)
        ]
        ants = cities.copy()

        distance_matrix = [
            [self.calc_distance(cities[i], cities[j]) for j in range(len(cities))]
            for i in range(len(cities))
        ]

        inverse_matrix = np.linalg.inv(distance_matrix)
        initial_pheromone_matrix = [
            [1 for j in range(len(cities))] for i in range(len(cities))
        ]
        m = 0
        best_path = {"path": None, "cost": None}
        visualization_path = []
        while m < MAX_MIGRATIONS:
            paths = []
            # for every ant
            for i in range(len(ants)):
                visibility_matrix = inverse_matrix.copy()
                path = [ants[i]["id"]]  # path starting at each node
                for j in range(len(cities)):
                    curr_town_idx = path[-1]
                    probabilities = []
                    for k in range(len(cities)):
                        neighborhood_node_idx = cities[k]["id"]
                        if neighborhood_node_idx not in path:
                            p = (
                                initial_pheromone_matrix[curr_town_idx][
                                    neighborhood_node_idx
                                ]
                                ** ALPHA
                                * visibility_matrix[curr_town_idx][
                                    neighborhood_node_idx
                                ]
                                ** BETA
                            )
                            probabilities.append({"id": neighborhood_node_idx, "p": p})
                    prob_sum = sum(x["p"] for x in probabilities)
                    probabilities = list(
                        map(
                            lambda x: {"id": x["id"], "p": x["p"] / prob_sum},
                            probabilities,
                        )
                    )
                    random_value = np.random.uniform()
                    for probability_index, probability in enumerate(probabilities):
                        tmp_s = sum(
                            probabilities[x]["p"] for x in range(probability_index)
                        )
                        if random_value < probability["p"] + tmp_s:
                            path.append(probability["id"])
                path.append(ants[i]["id"])  # back to starting city
                paths.append(path)
            # print(paths)
            # do vaporization by coeficient
            initial_pheromone_matrix = list(
                map(lambda x: list(map(lambda y: y * RHO, x)), initial_pheromone_matrix)
            )
            # do vaporization by path const
            for i in range(len(paths)):
                path_eval = eval_path(paths[i])
                # just check for best path
                # print(paths[i])
                if best_path["path"] is None or path_eval < best_path["cost"]:
                    best_path["path"] = paths[i]
                    best_path["cost"] = path_eval

                for j in range(len(paths[0]) - 1):
                    initial_pheromone_matrix[paths[i][j]][paths[i][j + 1]] = (
                        initial_pheromone_matrix[paths[i][j]][paths[i][j + 1]]
                        + Q / path_eval
                    )
            visualization_path.append(list(map(lambda x: cities[x], best_path["path"])))
            # print(visualization_path)
            # exit(0)
            m = m + 1
        print(best_path)
        self.show(visualization_path)

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
