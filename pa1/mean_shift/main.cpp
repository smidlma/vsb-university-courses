#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>
#include <omp.h>

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

struct Node
{
    int label;
    std::vector<int> features;
};

void show_features(Node n)
{
    for (auto f : n.features)
    {
        std::cout << f << " ";
    }
    std::cout << std::endl;
}

std::vector<Node> read_file(const char *filename)
{
    int records_max = 1000;
    int records_counter = 0;
    std::vector<Node> data;
    std::ifstream file(filename);
    std::string value;

    if (file.is_open())
    {
        std::string line;
        std::getline(file, line);

        while (std::getline(file, line) && records_counter < records_max)
        {
            Node tmp;
            std::stringstream str(line);
            std::getline(str, value, ',');
            tmp.label = std::stoi(value);
            while (std::getline(str, value, ','))
            {
                tmp.features.push_back(std::stoi(value));
            }
            data.push_back(tmp);
            records_counter += 1;
        }
    }
    return data;
}

int euclide_distance(Node *p, Node *p_tmp)
{
    int dist = 0;
    for (int i = 0; i < p->features.size(); i++)
    {
        dist += std::sqrt(std::pow(p_tmp->features[i] - p->features[i], 2));
    }
    return dist;
}

double kernel(int dist)
{
    double kernel_bandwitch = 2000;
    return std::exp(-dist / (2 * (kernel_bandwitch * kernel_bandwitch)));
}

Node shift(Node point, std::vector<Node> original_points)
{
    double scale_factor = 0;
    for (auto p_temp : original_points)
    {
        int dist = euclide_distance(&point, &p_temp);
        // std::cout << "dist" << dist << std::endl;
        double weight = kernel(dist);
        // std::cout << "weight" << weight << std::endl;
        // #pragma omp parallel for
        for (int i = 0; i < point.features.size(); i++)
        {
            point.features[i] += p_temp.features[i] * weight;
        }
        scale_factor += weight;
    }
    for (int i = 0; i < point.features.size(); i++)
    {
        point.features[i] /= scale_factor;
    }
    return point;
}

void mean_shift(std::vector<Node> nodes)
{
    auto points_copy = nodes;
    int MAX_ITERS = 50000;
    int iter = 0;

    while (true && iter < MAX_ITERS)
    {
        // save previous position
        auto prev_centroids = points_copy;

// shift every point
#pragma omp parallel for
        for (int i = 0; i < points_copy.size(); i++)
        {
            points_copy[i] = shift(points_copy[i], nodes);
        }

        bool optimized = true;
        // Check if centroids moved from previous position
        for (int i = 0; i < points_copy.size(); i++)
        {
            if (points_copy[i].features != prev_centroids[i].features)
            {
                optimized = false;
                break;
            }
        }

        iter += 1;
        std::cout << "Iteration rounds: " << iter << std::endl;
        // if all centroids are optimized end the mean shift
        if (optimized)
        {
            std::cout << "Optimazed solution" << std::endl;
            break;
        }
    }
}

int main(int argc, char const *argv[])
{
    std::vector<Node> data = read_file("mnist_test.csv");
    start_timer();
    mean_shift(data);
    end_timer();
    print_elapsed_time();
    return 0;
}
