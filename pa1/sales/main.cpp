#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <omp.h>

// std::vector<double> distances;

int main(int argc, char const *argv[])
{
    std::vector<double> permutation_base{1, 2, 3};

    int n = permutation_base.size();
    // #pragma omp parallel for
    for (int i = 0; i < n; ++i)
    {
        // Make a copy of permutation_base
        auto perm = permutation_base;
        // rotate the i'th  element to the front
        // keep the other elements sorted
        std::rotate(perm.begin(), perm.begin() + i + 1, perm.begin() + i + 1);
        // Now go through all permutations of the last `n-1` elements.
        // Keep the first element fixed.
        // for (int i = 0; i < perm.size(); i++)
        // {
        //     std::cout << perm[i];
        // }
        // std::cout << std::endl;

        do
        {
            // cost()
            for (int i = 0; i < perm.size(); i++)
            {
                std::cout << perm[i];
            }
            std::cout << std::endl;

        } while (std::next_permutation(perm.begin() + 1, perm.end()));
    }

    return 0;
}
