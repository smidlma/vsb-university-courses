#include <iostream>
#include <stdio.h>
#include <chrono>
#include <thread>
#include <omp.h>

using namespace std;
using json = nlohmann::json;

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

void downloadAllNames(httplib::Client &cli, int count)
{
    omp_set_num_threads(count);
#pragma omp parallel
    {
#pragma omp for schedule(dynamic)
        for (int i = 0; i < count; i++)
        {
            string path = "/api/v1/names/" + std::to_string(i) + ".json";
            // cout << path << endl;
            auto res = cli.Get(path);
            // cout << res->status << endl;
            // cout << res->body << endl;
            if (res->status == 200)
            {
                json data = json::parse(res->body);
#pragma omp critical
                cout << omp_get_thread_num() << ": " << data["Person"]["Id"].get<string>() << endl;
            }
        }
    }
}

int main()
{

    httplib::Client cli("http://name-service.appspot.com");

    start_timer();
    {
        // cout << "Hello World!" << endl;
        // std::this_thread::sleep_for(std::chrono::milliseconds(1000));
        downloadAllNames(cli, 3309);
    }
    end_timer();
    print_elapsed_time();

    std::getchar();
    return 0;
}
