#include <algorithm>
#include <deque>
#include <iostream>
#include <limits>
#include <string>
#include <vector>

struct Pos {
  int x;
  int y;
  Pos() : x(0), y(0) {}
  Pos(int x, int y): x(x), y(y) {}

  Pos left() const { return Pos(x - 1, y); }
  Pos right() const { return Pos(x + 1, y); }
  Pos up() const { return Pos(x, y - 1); }
  Pos down() const { return Pos(x, y + 1); }
};

template<typename T>
class Grid : public std::vector<std::vector<T>> {
  public:
    Grid(int nx, int ny, T const &initial) :
      std::vector<std::vector<T>>(ny, std::vector<T>(nx, initial))
    {}

    using std::vector<std::vector<T>>::operator[];

    T const &operator[](Pos pos) const {
      return (*this)[pos.y][pos.x];
    }

    T &operator[](Pos pos) {
      return (*this)[pos.y][pos.x];
    }
};

template<typename T>
std::ostream &operator<<(std::ostream &out, Grid<T> const &grid) {
  for (auto &row : grid) {
    for (auto &element : row) {
      out << element << ' ';
    }
    out << '\n';
  }
  return out;
}

int main() {
  std::vector<Pos> destinations(10);
  int numDestinations = 0;
  Grid<char> maze(0, 0, '\0');
  std::string line;
  while (std::getline(std::cin, line)) {
    std::vector<char> row;
    for (int x = 0; x < line.size(); x++) {
      char c = line[x];
      int idx = c - '0';
      if (idx >= 0 && idx <= 9) {
        int y = maze.size();
        numDestinations = std::max(numDestinations, idx + 1);
        destinations[idx] = Pos(x, y);
      }
      row.emplace_back(c);
    }
    maze.emplace_back(row);
  }
  destinations.resize(numDestinations);

  Grid<int> distances(numDestinations, numDestinations, -1);
  for (int from = 0; from < numDestinations; from++) {
    Grid<int> shortest(maze[0].size(), maze.size(), std::numeric_limits<int>::max());
    std::deque<Pos> q;
    Pos start = destinations[from];
    q.emplace_back(start);
    shortest[start] = 0;
    while (!q.empty()) {
      Pos current = q.front();
      q.pop_front();
      char c = maze[current];
      int s = shortest[current];
      if (c != '#') {
        int to = c - '0';
        if (to >= 0 && to < numDestinations) {
          distances[from][to] = shortest[current];
          distances[to][from] = shortest[current];
        }

        for (auto step : {current.left(), current.right(), current.up(), current.down()}) {
          if (shortest[step] == std::numeric_limits<int>::max()) {
            shortest[step] = s + 1;
            q.emplace_back(step);
          }
        }
      }
    }
  }

  int shortest = std::numeric_limits<int>::max();
  std::vector<int> order;
  for (int i = 1; i < numDestinations; i++) {
    order.emplace_back(i);
  }
  do {
    int distance = distances[0][order[0]];
    for (int i = 1; i < order.size(); i++) {
      distance += distances[order[i - 1]][order[i]];
    }
    distance += distances[order.back()][0];
    shortest = std::min(shortest, distance);
  } while (std::next_permutation(order.begin(), order.end()));
  std::cout << shortest << '\n';
}
