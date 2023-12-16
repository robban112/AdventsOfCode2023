import 'dart:io';

import '../template.dart';

(int, List<Set>) parseInput(String input) {
  final splits = input.split(":");
  final id = splits[0].split(" ")[1];

  final setsSplit = splits[1].split(";");
  List<Set> sets = [];
  for (var setsSplitStr in setsSplit) {
    final colorSplit = setsSplitStr.split(",");
    int numRed = 0, numBlue = 0, numGreen = 0;
    colorSplit.forEach((element) {
      final cubes = element.trimLeft().split(" ");
      final number = int.parse(cubes[0]);
      final cubeColor = Utils.cleanString(cubes[1]);

      if (cubeColor == "red") numRed = number;
      if (cubeColor == "blue") numBlue = number;
      if (cubeColor == "green") numGreen = number;
    });

    sets.add(Set(numRed, numBlue, numGreen));
  }
  print(input);
  print(sets);
  return (int.parse(id), sets);
}

bool isGamePossible(List<Set> game, int maxRed, int maxBlue, int maxGreen) {
  final answer = !game.map((set) {
    final isSetPossible = set.numBlue <= maxBlue &&
        set.numRed <= maxRed &&
        set.numGreen <= maxGreen;
    return isSetPossible;
  }).any((element) => !element);

  return answer;
}

void main() {
  final lines = FileReader.readFile();
  final maxRed = 12;
  final maxGreen = 13;
  final maxBlue = 14;

  final answer = lines.map(parseInput).fold(
        0,
        (previousValue, game) =>
            previousValue +
            (isGamePossible(game.$2, maxRed, maxBlue, maxGreen) ? game.$1 : 0),
      );

  print(answer);
}

class Set {
  final int numRed;
  final int numBlue;
  final int numGreen;

  const Set(this.numRed, this.numBlue, this.numGreen);

  @override
  String toString() {
    return "(numRed: $numRed, numBlue: $numBlue, numGreen: $numGreen)";
  }
}
