#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>
#include <queue>
#include <list>
// #include <omp.h>

#define NUMBER_OF_CITIES 6

struct tsp
{
    std::vector<double> ids;
    std::vector<double> distanceMatrix;
};

struct matrix_reduction
{
    std::vector<double> matrix;
    double cost;
};

void print_distances(std::vector<double> &dist, unsigned int n)
{
    for (unsigned int i = 0; i < dist.size(); i++)
    {
        std::cout << dist[i] << "\t";
        if ((i + 1) % n == 0)
            std::cout << std::endl;
    }
}

double compute_distance(double x1, double y1, double x2, double y2)
{
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
}

tsp read_tsp_file(const char *fname)
{
    std::ifstream file(fname);
    tsp tsp_holder;

    if (file.is_open())
    {
        std::vector<double> xs, ys, ids, min_vector, cities, distances;

        std::string line;

        std::getline(file, line);
        std::getline(file, line);
        std::getline(file, line);
        std::getline(file, line);
        std::getline(file, line);
        std::getline(file, line);
        std::getline(file, line);
        const int N = NUMBER_OF_CITIES;
        int j = 0;
        while (std::getline(file, line) && j < N)
        {
            j++;
            if (line[0] == 'E')
                break;

            std::stringstream sin(line);
            int id;
            double x, y;
            sin >> id >> x >> y;

            ids.push_back(id);
            xs.push_back(x);
            ys.push_back(y);
        }

        unsigned int n = xs.size();

        distances.resize(n * n);
        // TODO: calculate distance matrix
        for (int id : ids)
        {
            for (int x = 0; x < n; x++)
            {
                if (x == id - 1)
                {
                    distances[x + (id - 1) * n] = INFINITY;
                }
                else
                {

                    distances[x + (id - 1) * n] = compute_distance(xs[id - 1], ys[id - 1], xs[x], ys[x]);
                }
            }
        }
        tsp_holder.ids = ids;
        tsp_holder.distanceMatrix = distances;
        // print_distances(distances, n);
    }
    return tsp_holder;
}

std::vector<double> get_row(std::vector<double> matrix, int size, int row_idx)
{
    std::vector<double> row;
    for (int x = 0; x < size; x++)
    {
        row.push_back(matrix[x + row_idx * size]);
    }
    return row;
}

std::vector<double> get_col(std::vector<double> matrix, int size, int col_idx)
{
    std::vector<double> col;
    for (int y = 0; y < size; y++)
    {
        col.push_back(matrix[col_idx + y * size]);
    }
    return col;
}
template <typename S>
void print_vector(const std::vector<S> &vec, std::string sep = " ")
{
    for (auto elem : vec)
    {
        std::cout << elem << sep;
    }

    std::cout << std::endl;
}
double find_min(std::vector<double> vec)
{
    double min = MAXFLOAT;
    for (int i = 0; i < vec.size(); i++)
    {
        if (vec[i] < min)
        {
            min = vec[i];
        }
    }
    return min;
}
bool is_infinity_vector(std::vector<double> vec)
{
    for (int i = 0; i < vec.size(); i++)
    {
        if (!isinf(vec[i]))
        {
            return false;
        }
    }
    return true;
}
matrix_reduction reduce_matrix(std::vector<double> distances)
{
    matrix_reduction result;
    int size = sqrt(distances.size());
    double reduction_cost = 0;
    // std::cout << distances[3 + 1 * size] << std::endl; // test 18
    // Reduce rows
    for (int y = 0; y < size; y++)
    {
        std::vector<double> row = get_row(distances, size, y);
        // If its not infinite vec do the reduction
        if (!is_infinity_vector(row))
        {
            double min = find_min(row);
            if (min == 0)
                continue; // continue to next row

            for (int x = 0; x < size; x++)
            {
                distances[x + y * size] -= min;
            }
            reduction_cost += min;
        }
    }

    // Reduce cols
    for (int x = 0; x < size; x++)
    {
        std::vector<double> col = get_col(distances, size, x);
        if (!is_infinity_vector(col))
        {

            double min = find_min(col);
            if (min == 0)
                continue; // continue to next col

            for (int y = 0; y < size; y++)
            {
                distances[x + y * size] -= min;
            }
            reduction_cost += min;
        }
    }

    result.matrix = distances;
    result.cost = reduction_cost;
    return result;
}

int get_val_from_q(std::queue<int> q, int idx)
{
    for (int i = 0; i < idx; i++)
    {
        q.pop();
    }
    return q.front();
}

void run_tsp(tsp tsp_holder)
{
    double upper_bound = INFINITY;
    matrix_reduction initial = reduce_matrix(tsp_holder.distanceMatrix);
    double root_cost = initial.cost;
    int size = sqrt(initial.matrix.size());

    std::cout << "Root node cost: " << root_cost << std::endl;
    print_distances(initial.matrix, size);
    std::vector<int> path;
    path.push_back(0);

    double tmp_min_cost = INFINITY;

    // std::vector<int> stack;
    // for (int i = 1; i < size; i++)
    // {
    //     std::vector<double> local_matrix = initial.matrix;
    //     double cost = 0;
    //     // Set row 0 and col i to infinity
    //     for (int j = 0; j < size; j++)
    //     {
    //         // ROW
    //         local_matrix[j + 0 * size] = INFINITY;
    //         // COL
    //         local_matrix[i + j * size] = INFINITY;
    //     }
    //     // Set [0,i] to inf
    //     local_matrix[0 + i * size] = INFINITY;

    //     auto tmp = reduce_matrix(local_matrix);
    //     // print_distances(tmp.matrix, size);
    //     cost = root_cost + tmp.cost + initial.matrix[i + 0 * size];
    //     if (cost < tmp_min_cost)
    //     {
    //         tmp_min_cost = cost;
    //         path = {0, i};
    //         stack.clear();
    //         for (int k = 1; k < size; k++)
    //         {
    //             if (k != i)
    //                 stack.push_back(k);
    //         }
    //     }
    // }

    // print_vector(stack.);
    std::queue<int> q;
    for (int i = 0; i < size; i++)
    {
        q.push(i);
    }

    while (!q.empty())
    {
        int curr_node_idx = q.front();
        q.pop();
        for (int i = 0; i < q.size(); i++)
        {
            std::vector<double> local_matrix = initial.matrix;
            double cost = 0;
            // Set current row and col q[i] to infinity
            for (int j = 0; j < size; j++)
            {
                // ROW
                local_matrix[j + curr_node_idx * size] = INFINITY;
                // COL
                local_matrix[get_val_from_q(q, i) + j * size] = INFINITY;
            }
            // Set [0,i] to inf
            local_matrix[curr_node_idx + get_val_from_q(q, i) * size] = INFINITY;

            auto tmp = reduce_matrix(local_matrix);
            // print_distances(tmp.matrix, size);
            cost = root_cost + tmp.cost + initial.matrix[get_val_from_q(q, i) + curr_node_idx * size];
            if (cost < tmp_min_cost)
            {
                // generate next path of the tree and remember visited nodes
                // remeber evalkuated costs for nodes
            }
        }
    }
}

int main(int argc, char const *argv[])
{
    std::vector<double> dst = {INFINITY, 4, 12, 7,
                               5, INFINITY, INFINITY, 18,
                               11, INFINITY, INFINITY, 6,
                               10, 2, 3, INFINITY};
    tsp test_holder;
    test_holder.distanceMatrix = dst;
    test_holder.ids = {0, 1, 2, 3};
    tsp tsp_holder = read_tsp_file("ulysses22.tsp.txt");
    // print_distances(tsp_holder.distanceMatrix, sqrt(tsp_holder.distanceMatrix.size()));
    // std::cout << std::endl;
    run_tsp(test_holder);
    return 0;
}
