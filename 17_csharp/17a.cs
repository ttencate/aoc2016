using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

public static class Seventeen {

  private static readonly MD5 md5 = MD5.Create();
  private static readonly string directions = "UDLR";
  private static readonly int width = 4;
  private static readonly int height = 4;
  private static readonly int goalX = 3;
  private static readonly int goalY = 3;

  private static string input;

  public static void Main(string[] args) {
    input = Console.ReadLine();

    MinHeap<State> queue = new MinHeap<State>(new State.GScoreComparer());
    queue.Add(new State(0, 0, ""));
    while (!queue.IsEmpty()) {
      State current = queue.RemoveMin();
      if (current.IsGoal()) {
        Console.WriteLine(current.path);
        break;
      }
      foreach (State neighbor in current.Neighbors()) {
        queue.Add(neighbor);
      }
    }
  }

  private class State {

    public readonly int x;
    public readonly int y;
    public readonly string path;
    public readonly int fScore;
    public readonly int gScore;

    public State(int x, int y, string path) {
      this.x = x;
      this.y = y;
      this.path = path;
      this.fScore = path.Length;
      this.gScore = this.fScore + Math.Abs(goalX - x) + Math.Abs(goalY - y);
    }

    override public string ToString() {
      return String.Format("{0}, {1}, {2}", x, y, path);
    }

    public bool IsGoal() {
      return x == goalX && y == goalY;
    }

    public class GScoreComparer : IComparer<State> {
      public int Compare(State a, State b) {
        if (a.gScore < b.gScore) return -1;
        if (a.gScore > b.gScore) return 1;
        return 0;
      }
    }

    public IEnumerable<State> Neighbors() {
      string hash = ByteArrayToString(md5.ComputeHash(Encoding.ASCII.GetBytes(input + path)));
      for (int i = 0; i < 4; i++) {
        char direction = directions[i];
        int x = this.x;
        int y = this.y;
        switch (direction) {
          case 'U':
            if (y <= 0) continue;
            y--;
            break;
          case 'D':
            if (y >= height - 1) continue;
            y++;
            break;
          case 'L':
            if (x <= 0) continue;
            x--;
            break;
          case 'R':
            if (x >= width - 1) continue;
            x++;
            break;
        }
        char c = hash[i]; 
        if ("bcdef".IndexOf(c) >= 0) {
          yield return new State(x, y, path + direction);
        }
      }
    }

    private static string ByteArrayToString(byte[] bytes) {
      StringBuilder hex = new StringBuilder(bytes.Length * 2);
      foreach (byte b in bytes) {
        hex.AppendFormat("{0:x2}", b);
      }
      return hex.ToString();
    }
  }

  private class MinHeap<T> {

    private readonly IComparer<T> comparer;
    private readonly IList<T> elements = new List<T>();

    public MinHeap(IComparer<T> comparer) {
      this.comparer = comparer;
    }

    public bool IsEmpty() {
      return elements.Count == 0;
    }

    public void Add(T element) {
      int index = elements.Count;
      elements.Add(element);
      while (index > 0) {
        int parentIndex = index >> 1;
        if (Smaller(index, parentIndex)) {
          elements.Swap(index, parentIndex);
          index = parentIndex;
        } else {
          break;
        }
      }
    }

    public T RemoveMin() {
      T result = elements[0];
      elements[0] = elements.Last();
      elements.RemoveAt(elements.Count - 1);
      int index = 0;
      while (true) {
        int leftChildIndex = index << 1;
        int rightChildIndex = leftChildIndex + 1;
        int smallest = index;
        if (leftChildIndex < elements.Count && Smaller(leftChildIndex, smallest)) {
          smallest = leftChildIndex;
        }
        if (rightChildIndex < elements.Count && Smaller(rightChildIndex, smallest)) {
          smallest = rightChildIndex;
        }
        if (smallest != index) {
          elements.Swap(index, smallest);
          index = smallest;
        } else {
          break;
        }
      }
      return result;
    }

    private bool Smaller(int i, int j) {
      return comparer.Compare(elements[i], elements[j]) < 0;
    }
  }

  public static void Swap<T>(this IList<T> list, int i, int j) {
    T tmp = list[i];
    list[i] = list[j];
    list[j] = tmp;
  }
}
