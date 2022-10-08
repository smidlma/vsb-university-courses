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
        while T > T_min:
            new_point = self.generate_neighbours(
                point=global_extreme_point, count=1, sigma=2.5
            )[0]
            print(new_point)
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
