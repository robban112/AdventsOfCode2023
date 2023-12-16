import '../template.dart';

List<List<String>> parseGrid(List<String> input) {
  return input
      .map((e) => e.codeUnits.map(String.fromCharCode).toList())
      .toList();
}

bool isAdjacentToSymbol(
  Number number,
  List<List<String>> grid,
) {
  return getNeighbours(number, grid).any(isSymbol);
}

List<String> getNeighbours(
  Number number,
  List<List<String>> grid,
) {
  List<String> neighbours = [];

  // GET LEFT SIDE
  if (number.startX > 0) {
    // LEFT
    Logger.log("LEFT");
    neighbours.add(grid[number.startY][number.startX - 1]);

    // LEFT-TOP
    if (number.startY > 0) {
      Logger.log("LEFT-TOP");
      neighbours.add(grid[number.startY - 1][number.startX - 1]);
    }

    // LEFT-BOTTOM
    if (number.startY < grid.length - 1) {
      Logger.log("LEFT-BOTTOM");
      neighbours.add(grid[number.startY + 1][number.startX - 1]);
    }
  }

  // GET RIGHT SIDE
  if (number.endX < grid.first.length - 1) {
    // RIGHT
    Logger.log("RIGHT");
    neighbours.add(grid[number.startY][number.endX + 1]); // To the right same y

    // RIGHT-TOP
    if (number.startY > 0) {
      Logger.log("RIGHT-TOP");
      neighbours.add(grid[number.startY - 1][number.endX + 1]);
    }

    // RIGHT-BOTTOM
    if (number.startY < grid.length - 1) {
      Logger.log("RIGHT-BOTTOM");
      neighbours.add(grid[number.startY + 1][number.endX + 1]);
    }
  }

  // TOP SIDE
  if (number.startY > 0) {
    for (var x = number.startX; x < number.startX + number.length; x++) {
      Logger.log("TOP");
      neighbours.add(grid[number.startY - 1][x]);
    }
  }

  // BOTTOM SIDE
  if (number.startY < grid.length - 1) {
    for (var x = number.startX; x < number.startX + number.length; x++) {
      Logger.log("BOTTOM");
      neighbours.add(grid[number.startY + 1][x]);
    }
  }

  return neighbours;
}

bool isSymbol(String char) =>
    int.tryParse(char) == null && char != "." && char.isNotEmpty;

List<Number> parseNumbers(List<List<String>> grid) {
  List<Number> numbers = [];
  for (var y = 0; y < grid.length; y++) {
    final row = grid[y];

    for (int x = 0; x < row.length; x++) {
      final char = row[x];
      final num = int.tryParse(char);
      if (num != null) {
        String fullNum = num.toString();
        int jumpOver = 1;
        bool nextCharIsNum = true;
        while (nextCharIsNum && (x + jumpOver < row.length)) {
          var nextNum = int.tryParse(row[x + jumpOver]);
          nextCharIsNum = nextNum != null;
          if (nextCharIsNum) {
            fullNum = fullNum + "$nextNum";
          }
          jumpOver++;
        }

        numbers.add(Number(x, y, int.parse(fullNum), fullNum.length));
        x += jumpOver - 1;
      }
    }
  }
  return numbers;
}

void main() {
  final grid = parseGrid(FileReader.readFile());
  final numbers = parseNumbers(grid);
  var total = 0;
  numbers.forEach((number) {
    if (isAdjacentToSymbol(number, grid)) {
      //print(number.number);
      total += number.number;
    }
  });
  //print("---");
  print(total);
}

class Number {
  final int startX;
  final int startY;
  final int number;
  final int length;

  const Number(this.startX, this.startY, this.number, this.length);

  int get endX => startX + length - 1;

  @override
  String toString() {
    return 'Number{startX: $startX, startY: $startY, number: $number, length: $length}';
  }
}
