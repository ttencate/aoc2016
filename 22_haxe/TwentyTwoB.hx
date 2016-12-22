import haxe.io.Eof;
import haxe.io.Input;

class TwentyTwoB {
  static function main() {
    Sys.stdout().writeString(run(Sys.stdin()));
  }

  private static function run(input: Input): String {
    var nodes = [];
    try {
      while (true) {
        var node = parse(input.readLine());
        if (node != null) {
          if (nodes[node.y] == null) {
            nodes[node.y] = [];
          }
          var s = ".";
          if (node.size > 100) {
            s = "#";
          } else if (node.avail == node.size) {
            s = "_";
          }
          nodes[node.y][node.x] = s;
        }
      }
    } catch (endOfFile: Eof) {
    }

    nodes[0][nodes[0].length - 1] = "G";
    var output = '';
    for (row in nodes) {
      output += row.join('') + "\n";
    }
    return output;
  }

  private static function parse(line: String) {
    var match = ~/^\/dev\/grid\/node-x(\d+)-y(\d+)\s+(\d+)T\s+(\d+)T\s+(\d+)T.*$/;
    if (!match.match(line)) {
      return null;
    }
    return {
      x: Std.parseInt(match.matched(1)),
      y: Std.parseInt(match.matched(2)),
      size: Std.parseInt(match.matched(3)),
      used: Std.parseInt(match.matched(4)),
      avail: Std.parseInt(match.matched(5)),
    };
  }
}
