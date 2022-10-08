#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <omp.h>

using namespace std;

vector<double> distances;

void print_distances(vector<double> &dist, unsigned int n)
{
	for (unsigned int i = 0; i < dist.size(); i++)
	{
		cout << dist[i] << "\t";
		if ((i + 1) % n == 0)
			cout << endl;
	}
}

double compute_distance(double x1, double y1, double x2, double y2)
{
	return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
}

void read_tsp_file(const char *fname)
{
	std::ifstream file(fname);

	if (file.is_open())
	{
		vector<double> xs, ys, ids, min_vector;

		std::string line;

		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		const int N = 10;
		int j = 0;
		while (std::getline(file, line) && j < N)
		{
			j++;
			if (line[0] == 'E')
				break;

			stringstream sin(line);
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
		// for (int id : ids)
		// {
		// 	for (int x = 0; x < n; x++)
		// 	{
		// 		distances[x + (id - 1) * n] = compute_distance(xs[id - 1], ys[id - 1], xs[x], ys[x]);
		// 	}
		// }
		// int start_town = 1;

		float min_travel_dist = 0;

		int perm_base_size = ids.size();
#pragma omp parallel for
		for (int i = 0; i < perm_base_size; i++)
		{
			auto perm = ids;
			std::rotate(perm.begin(), perm.begin() + i, perm.begin() + i + 1);

			do
			{
				float travel_distance = 0;
				for (int i = 0; i < perm.size() - 1; i++)
				{
					travel_distance += compute_distance(xs[perm[i] - 1], ys[perm[i] - 1], xs[perm[i + 1] - 1], ys[perm[i + 1] - 1]);
				}
#pragma omp critical

				if (min_travel_dist == 0 || travel_distance < min_travel_dist)
				{
					min_travel_dist = travel_distance;
					min_vector = ids;
				}

			} while (std::next_permutation(perm.begin() + 1, perm.end()));
		}

		while (next_permutation(ids.begin(), ids.end()))
		{
			float travel_distance = 0;
			for (int i = 0; i < ids.size() - 1; i++)
			{
				travel_distance += compute_distance(xs[ids[i] - 1], ys[ids[i] - 1], xs[ids[i + 1] - 1], ys[ids[i + 1] - 1]);
			}

			if (min_travel_dist == 0 || travel_distance < min_travel_dist)
			{
				min_travel_dist = travel_distance;
				min_vector = ids;
			}
		}

		for (auto id : min_vector)
		{
			std::cout << id << " ";
		}
		std::cout << "distance => " << min_travel_dist << std::endl;

		file.close();
	}
	else
	{
		cout << fname << " file not open" << endl;
		return;
	}
}

int main()
{
	read_tsp_file("ulysses22.tsp.txt");
	return 0;
}
