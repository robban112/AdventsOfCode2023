import '../template.dart';
import 'dart:math' as math;

// Return a tuple with (winningNumbers, myNumbers)
(List<int>, List<int>) parseInput(String line) {
  final gamesplit = line.split(" | ");
  final winningNumbers = gamesplit[0]
      .split(":")[1]
      .trimLeft()
      .split(" ")
      .map((e) => int.tryParse(e))
      .nonNulls
      .toList();

  final myNumbers =
      gamesplit[1].split(" ").map((e) => int.tryParse(e)).nonNulls.toList();
  return (winningNumbers, myNumbers);
}

// Input (winningNumbers, myNumbers)
int countPoints((List<int>, List<int>) arg) {
  int numWinners =
      arg.$1.fold(0, (prev, win) => prev + (arg.$2.contains(win) ? 1 : 0));
  if (numWinners == 0)
    return 0;
  else
    return math.pow(2, numWinners - 1).toInt();
}

void partOne() {
  final points = FileReader.readFile()
      .map(parseInput)
      .map(countPoints)
      .fold(0, (prev, e) => prev + e);
  print(points);
}

void partTwo() {}

void main() {}
