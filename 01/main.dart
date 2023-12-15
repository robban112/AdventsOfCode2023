import 'dart:io';

import '../template.dart';

int getFirstLast(String input) {
  final characters = Utils.characters(input);
  String? first = characters.firstWhere((element) => int.tryParse(element) != null);
  String? last = characters.lastWhere((element) => int.tryParse(element) != null);
  //print("$input : $first$last");
  return int.parse("${first}$last");
}

void main() {
  // Prompt the user for the file path
  final input = FileReader.readFile();
  int sum = input.fold(0, (previousValue, element) => previousValue + getFirstLast(element));
  stdout.write(sum);
}
