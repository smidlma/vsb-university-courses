#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>

struct Node
{
    int label;
    std::vector<int> features;
};

std::vector<Node> read_file(const char *filename)
{
    std::vector<Node> data;
    std::ifstream file(filename);
    std::string value;

    if (file.is_open())
    {
        std::string line;
        std::getline(file, line);

        while (std::getline(file, line))
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
        }
    }
    return data;
}

void mean_shift(std::vector<Node> nodes)
{
    auto original_data = nodes;

    while (true)
    {
        for (int i = 0; i < nodes.size(); i++)
        {
            for (int j = 0; j < nodes.size(); j++)
            {
                if (i != j)
                {
                    std::transform(original_data[j].features.begin(), original_data[j].features.end(), nodes[i].features.begin(), nodes[i].features.begin(), std::minus<int>());
                }
            }
        }
    }
}

int main(int argc, char const *argv[])
{
    std::vector<Node> data = read_file("mnist_test.csv");

    // std::cout << data[0].label << "/";
    // for (auto f : data[0].features)
    // {
    //     std::cout << f << " ";
    // }

    std::cout << "Hello World!" << std::endl;
    return 0;
}
