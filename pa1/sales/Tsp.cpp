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

struct Node
{
    int idx;
    std::vector<double> reduction_matrix;
    double cost;
};
std::chrono::high_resolution_clock::time_point t1;
std::chrono::high_resolution_clock::time_point t2;

void start_timer()
{
    std::cout << "Timer started" << std::endl;
    t1 = std::chrono::high_resolution_clock::now();
}

void end_timer()
{
    t2 = std::chrono::high_resolution_clock::now();
    std::cout << "Timer ended" << std::endl;
}
void print_elapsed_time()
{
    std::cout << "Time elapsed: " << std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count() << " milliseconds\n"
              << std::endl;
}
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

Node find_min_node(std::vector<Node> nodes)
{
    Node min = nodes[0];
    for (int i = 1; i < nodes.size(); i++)
    {
        if (nodes[i].cost < min.cost)
        {
            min = nodes[i];
        }
    }

    return min;
}
void run_tsp(tsp tsp_holder)
{
    double upper_bound = INFINITY;
    matrix_reduction initial = reduce_matrix(tsp_holder.distanceMatrix);
    double root_cost = initial.cost;
    int size = sqrt(initial.matrix.size());
    std::vector<Node> nodes_to_explore;
    std::vector<Node> visited_nodes;
    Node root_node = {0, initial.matrix, initial.cost};
    Node current_node = root_node;

    // add first layer
    for (int i = 1; i < size; i++)
    {
        Node n;
        n.idx = i;
        nodes_to_explore.push_back(n);
    }

    while (!nodes_to_explore.empty())
    {
        for (int i = 0; i < nodes_to_explore.size(); i++)
        {
            std::vector<double> local_matrix = current_node.reduction_matrix;

            // Set current row and col q[i] to infinity
            for (int j = 0; j < size; j++)
            {
                // ROW
                local_matrix[j + current_node.idx * size] = INFINITY;
                // COL
                local_matrix[nodes_to_explore[i].idx + j * size] = INFINITY;
            }
            // Set [curr,i] to inf
            local_matrix[current_node.idx + nodes_to_explore[i].idx * size] = INFINITY;

            auto tmp = reduce_matrix(local_matrix);
            nodes_to_explore[i].reduction_matrix = tmp.matrix;
            nodes_to_explore[i].cost = current_node.cost + tmp.cost + root_node.reduction_matrix[nodes_to_explore[i].idx + current_node.idx * size];
        }
        // find min cost of level
        Node min_node = find_min_node(nodes_to_explore);

        // std::cout << min_node.cost << std::endl;
        visited_nodes.push_back(current_node);
        // visited_nodes.push_back(min_node);
        nodes_to_explore.clear();
        // generate new path
        for (int i = 1; i < size; i++)
        {
            bool add_flag = true;
            for (int j = 0; j < visited_nodes.size(); j++)
            {
                if (visited_nodes[j].idx == i)
                {
                    add_flag = false;
                    break;
                }
            }
            if (add_flag)
            {
                Node n;
                n.idx = i;
                nodes_to_explore.push_back(n);
            }
        }
        current_node = min_node;
    }
    visited_nodes.push_back(root_node);
    for (auto v : visited_nodes)
    {
        std::cout << v.idx << ":" << v.cost << ", ";
    }
    std::cout << "Cost: " << visited_nodes[visited_nodes.size() - 2].cost << std::endl;
}

int main(int argc, char const *argv[])
{
    // https://www.gatevidyalay.com/travelling-salesman-problem-using-branch-and-bound-approach/
    std::vector<double> dst = {INFINITY, 4, 12, 7,
                               5, INFINITY, INFINITY, 18,
                               11, INFINITY, INFINITY, 6,
                               10, 2, 3, INFINITY};
    tsp test_holder;
    test_holder.distanceMatrix = dst;
    test_holder.ids = {0, 1, 2, 3};
    tsp tsp_holder = read_tsp_file("ulysses22.tsp.txt");

    start_timer();
    run_tsp(test_holder);
    end_timer();
    print_elapsed_time();
    return 0;
}
