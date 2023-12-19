import '../template.dart';

List<List<int>> parseInput() {
  final lines = FileReader.readFile();

  final times = lines[0]
      .split(":")[1]
      .split(" ")
      .map((e) => int.tryParse(e))
      .nonNulls
      .toList();

  final distances = lines[1]
      .split(":")[1]
      .split(" ")
      .map((e) => int.tryParse(e))
      .nonNulls
      .toList();

  return Utils.zip(times, distances);
}

int getNumWaysToBeatRecord(int time, int distance) {
  return List.generate(time - 2, (i) => i)
      .map((i) => i * (time - i) > distance)
      .fold(0, (prev, curr) => prev + (curr ? 1 : 0));
}

void main() {
  final solution = (parseInput()
      .map((e) => getNumWaysToBeatRecord(e[0], e[1]))
      .fold(1, (prev, curr) => prev * curr));
  print(solution);
}
