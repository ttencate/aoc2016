import haxe.io.Eof;
import haxe.io.Input;

class TwentyTwoA {
  static function main() {
    Sys.stdout().writeString('${run(Sys.stdin())}\n');
  }

  private static function run(input: Input): Int {
    var nodes = [];
    try {
      while (true) {
        var node = parse(input.readLine());
        if (node != null) {
          nodes.push(node);
        }
      }
    } catch (endOfFile: Eof) {
    }

    var byUsed = nodes.copy();
    byUsed.sort(function(a, b) { return a.used - b.used; });
    var byAvail = nodes.copy();
    byAvail.sort(function(a, b) { return a.avail - b.avail; });

    var count = 0;
    var availIndex = 0;
    for (node in byUsed) {
      while (availIndex < byAvail.length && byAvail[availIndex].avail < node.used) {
        availIndex++;
      }
      count += byAvail.length - availIndex - 1;
    }
    return count;
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
