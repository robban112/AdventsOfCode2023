import 'dart:io';

class FileReader {
  static List<String> readFile({String filename = "input/input.txt"}) {
    // Read the file path from the user

    try {
      // Open the file
      File file = File(filename);
      if (!file.existsSync()) {
        print('File not found.');
        throw ArgumentError("File not found");
      }

      // Read the contents of the file
      String fileContent = file.readAsStringSync();

      // Display the file content
      return fileContent.split("\n");
    } catch (e) {
      print('An error occurred: $e');
      rethrow;
    }
  }
}

class Utils {
  static List<String> characters(String input) {
    return input.runes.map((e) => String.fromCharCode(e)).toList();
  }
}
