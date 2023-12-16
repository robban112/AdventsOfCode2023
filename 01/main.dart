import 'dart:io';

import '../template.dart';

int getFirstLast(String input) {
  //var newInput = replaceSpelledOutLetters(input);
  String? first = replaceSpelledOutLetters(getFirst(input)!);
  String? last = replaceSpelledOutLetters(getLast(input)!);

  return int.tryParse("${first}$last")!;
}

String? getFirst(String input) {
  // Get the first occurence of a spelled out digit and the index for it
  var firstIndex = input.length + 1;
  var firstDigit;
  for (var digit in getDigits()) {
    final indexForDigit = input.indexOf(digit.$1);
    if (indexForDigit != -1) {
      if (indexForDigit < firstIndex) {
        firstIndex = indexForDigit;
        firstDigit = digit;
      }
    }
  }

  // Get the first occurrence of a digit 1-9
  final firstIndexForDigit = input.indexOf(RegExp(r'\d'));
  //print("$input");
  if (firstIndex < firstIndexForDigit || firstIndexForDigit == -1) {
    return firstDigit.$1;
  } else {
    final digit = getFirstDigit(input)!;
    return digit.toString();
  }
}

String? getLast(String input) {
  // Get the first occurence of a spelled out digit and the index for it
  var firstIndex = -2;
  var firstDigit;
  for (var digit in getDigits()) {
    final indexForDigit = input.lastIndexOf(digit.$1);
    if (indexForDigit != -1) {
      if (indexForDigit > firstIndex) {
        firstIndex = indexForDigit;
        firstDigit = digit;
      }
    }
  }

  // Get the first occurrence of a digit 1-9
  final firstIndexForDigit = input.lastIndexOf(RegExp(r'\d'));
  if (firstIndex > firstIndexForDigit || firstIndexForDigit == -1) {
    return firstDigit.$1;
  } else {
    final digit = getLastDigit(input)!;
    return digit.toString();
  }
}

int? getFirstDigit(String input) {
  final firstDigit = Utils.firstWhereOrNull<String>(
      Utils.characters(input), (p) => int.tryParse(p) != null);
  if (firstDigit != null) {
    return int.tryParse(firstDigit);
  }
  return null;
}

int? getLastDigit(String input) {
  final lastDigit = Utils.lastWhereOrNull<String>(
      Utils.characters(input), (p) => int.tryParse(p) != null);
  if (lastDigit != null) {
    return int.tryParse(lastDigit);
  }
  return null;
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
  var digitsCp = getDigits()
      .map((e) => (e, input.indexOf(e.$1)))
      .where((e) => e.$2 != -1)
      .toList();
  digitsCp.sort((a, b) => a.$2.compareTo(b.$2));
  for (var toReplace in digitsCp) {
    input = input.replaceAll(toReplace.$1.$1, toReplace.$1.$2);
  }
  return input;
}

void main() {
  // Prompt the user for the file path
  final input = FileReader.readFile();
  int sum = input.fold(
      0, (previousValue, element) => previousValue + getFirstLast(element));
  stdout.write(sum);
}
