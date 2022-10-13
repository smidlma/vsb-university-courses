#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <cmath>
#include <vector>
#include <algorithm>
#include <chrono>
#include <omp.h>

#define PARALER

using namespace std;

vector<double> distances;

std::chrono::high_resolution_clock::time_point t1;
std::chrono::high_resolution_clock::time_point t2;

void start_timer()
{
	std::cout << "Timer started" << endl;
	t1 = std::chrono::high_resolution_clock::now();
}

void end_timer()
{
	t2 = std::chrono::high_resolution_clock::now();
	std::cout << "Timer ended" << endl;
}
void print_elapsed_time()
{
	std::cout << "Time elapsed: " << std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count() << " milliseconds\n"
			  << endl;
}

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
		vector<double> xs, ys, ids, min_vector, cities;

		std::string line;

		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		std::getline(file, line);
		const int N = 11;
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

		float min_travel_dist = MAXFLOAT;
		for (int i = 1; i < ids.size(); i++)
		{
			cities.push_back(ids[i]);
		}
		start_timer();

#ifdef PARALER
#pragma omp parallel for
		for (int i = 0; i < cities.size(); ++i)
		{
			// Make a copy of permutation_base
			auto perm = cities;
			// rotate the i'th  element to the front
			// keep the other elements sorted
			std::rotate(perm.begin(), perm.begin() + i, perm.begin() + i + 1);
			// Now go through all permutations of the last `n-1` elements.
			// Keep the first element fixed.
			float tmp = MAXFLOAT;
			vector<double> path;
			do
			{
				float travel_distance = compute_distance(xs[0], ys[0], xs[perm[0] - 1], ys[perm[0] - 1]);
				for (int i = 0; i < perm.size(); i++)
				{
					travel_distance += compute_distance(xs[perm[i] - 1], ys[perm[i] - 1], xs[perm[i + 1] - 1], ys[perm[i + 1] - 1]);
				}
				if (travel_distance < tmp)
				{
					tmp = travel_distance;
					path = perm;
				}
			} while (std::next_permutation(perm.begin() + 1, perm.end()));
#pragma omp critical
			{
				if (tmp < min_travel_dist)
				{
					min_travel_dist = tmp;
					min_vector = path;
				}
			}
		}
#else
		do
		{
			float travel_distance = 0;
			for (int i = 0; i < ids.size(); i++)
			{
				travel_distance += compute_distance(xs[ids[i] - 1], ys[ids[i] - 1], xs[ids[i + 1] - 1], ys[ids[i + 1] - 1]);
			}

			if (min_travel_dist == 0 || travel_distance < min_travel_dist)
			{
				min_travel_dist = travel_distance;
				min_vector = ids;
			}
		} while (next_permutation(ids.begin() + 1, ids.end()));
#endif
		end_timer();
		print_elapsed_time();

		std::cout
			<< "1 ";
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
