import 'dart:io';

import '../template.dart';

int getFirstLast(String input) {
  var newInput = replaceSpelledOutLetters(input);
  final characters = Utils.characters(newInput);
  String? first = Utils.firstWhereOrNull(
    characters,
    (element) => int.tryParse(element) != null,
  );
  String? last = Utils.lastWhereOrNull(
    characters,
    (element) => int.tryParse(element) != null,
  );

  print("$input # $newInput");
  return int.tryParse("${first}$last") ?? 0;
}

String getFirstSpelledOut(String input) {
  var firstIndex = -1;
  var firstDigit;
  for (var digit in getDigits()) {
    final indexForDigit = input.indexOf(digit.$1);
    if (indexForDigit < firstIndex) {
      firstIndex = indexForDigit;
      firstDigit = digit;
    }
  }

  print("first digit for $input is ${firstDigit.$1}");
  return firstDigit.$1;
}

List<(String, String)> getDigits() => [
      ("one", "1"),
      ("two", "2"),
      ("three", "3"),
      ("four", "4"),
      ("five", "5"),
      ("six", "6"),
      ("seven", "7"),
      ("eight", "8"),
      ("nine", "9"),
    ];

String replaceSpelledOutLetters(String input) {
  var digitsCp = getDigits().map((e) => (e, input.indexOf(e.$1))).where((e) => e.$2 != -1).toList();
  digitsCp.sort((a, b) => a.$2.compareTo(b.$2));
  for (var toReplace in digitsCp) {
    input = input.replaceAll(toReplace.$1.$1, toReplace.$1.$2);
  }
  return input;
}

void main() {
  // Prompt the user for the file path
  final input = FileReader.readFile();
  int sum = input.fold(0, (previousValue, element) => previousValue + getFirstLast(element));
  stdout.write(sum);
}
