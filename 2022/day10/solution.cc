#include <iostream>
#include <fstream>

int main(int argc, char **argv)
{
    for (int argNum = 1; argNum < argc; argNum++)
    {
        std::string line;
        std::ifstream input(argv[argNum]);

        char crt[6][40];

        int cycle = 0;
        int eax = 1;
        int part1Sum = 0;

        auto drawFrame = [&]()
        {
            int position = cycle - 1;
            int y = position / 40;
            int x = position % 40;
            crt[y][x] = abs(x - eax) < 2 ? '#' : '.';
        };

        auto doCycle = [&]()
        {
            cycle++;
            if (cycle == 20 || cycle == 60 || cycle == 100 || cycle == 140 || cycle == 180 || cycle == 220)
                part1Sum += eax * cycle;

            drawFrame();
        };

        while (std::getline(input, line))
        {
            doCycle();
            if (line == "noop")
                continue;
            doCycle();

            eax += std::stoi(line.substr(5));
        }

        std::cout << argv[argNum] << ":\nPart 1: " << part1Sum << "\n";
        for (auto &row : crt)
        {
            for (auto c : row)
                std::cout << c;

            std::cout << "\n";
        }
    }
}
