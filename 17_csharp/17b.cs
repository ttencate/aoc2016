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
    Console.WriteLine("{0}", LongestPath(new State(0, 0, "")));
  }

  private static int LongestPath(State current) {
    if (current.IsGoal()) {
      return current.path.Length;
    }
    int longest = -1;
    foreach (State neighbor in current.Neighbors()) {
      longest = Math.Max(longest, LongestPath(neighbor));
    }
    return longest;
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
}
