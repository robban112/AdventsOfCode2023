import 'dart:io';

import '../template.dart';

/// Returns the map given by the title, e.g "seed-to-soil map" and
/// the describing list of sources, destinations and lengths.
List<List<int>> getMap(String title, List<String> input) {
  List<List<int>> map = [];
  bool hasFoundTitle = false;
  for (int i = 0; i < input.length; i++) {
    String line = input[i];
    if (line == "") {
      hasFoundTitle = false;
    } else if (line.contains(title)) {
      hasFoundTitle = true;
      continue;
    }
    if (hasFoundTitle) {
      map.add(Utils.lineToListInt(line));
    }
  }
  return map;
}

// Returns the destination explained by a start point
// and the map describing the destination
// start -> [[destination, source, length]]
int getDestination(int startSource, List<List<int>> map) {
  int mappedDestination = startSource;
  for (var sourceMap in map) {
    int dest = sourceMap[0];
    int source = sourceMap[1];
    int length = sourceMap[2];

    int diff = dest - source;
    int endSource = source + length;

    if (startSource >= source && startSource <= endSource) {
      return startSource + diff;
    }
  }
  return mappedDestination;
}

/// Traverses the location of a categoryNumber (seed) and returns
/// the final location.
int traverseToLocation(
  int categoryNumber,
  int currCategory,
  List<List<List<int>>> listOfMap, {
  String? traversal,
}) {
  if (currCategory >= listOfMap.length) {
    print(traversal);
    sleep(const Duration(milliseconds: 50));
    return categoryNumber;
  }
  int nextCategoryNumber = getDestination(
    categoryNumber,
    listOfMap[currCategory],
  );
  //print("$categoryNumber -> $nextCategoryNumber");
  if (traversal != null) {
    traversal += " -> $nextCategoryNumber";
  }
  return traverseToLocation(
    nextCategoryNumber,
    currCategory + 1,
    listOfMap,
    traversal: traversal,
  );
}

void partOne(List<int> seeds, List<List<List<int>>> gardenMaps) {
  print(seeds
      .map((seed) => traverseToLocation(seed, 0, gardenMaps))
      .reduce((value, element) => value < element ? value : element));
}

List<List<Range>> parseGardenMapsToRanges(List<List<List<int>>> input) {
  return input
      .map((e) => e.map((e) => Range(e[1], e[2], offset: e[0] - e[1])).toList())
      .toList();
}

void partTwo(List<int> seeds, List<List<List<int>>> gardenMaps) {
  final map = parseGardenMapsToRanges(gardenMaps);

  List<Range> ranges =
      Utils.groupList(seeds, 2).map((e) => Range(e[0], e[1])).toList();
  for (var categoryRangeList in map) {
    List<Range> additionalRanges = [];
    List<Range> replacedRanges = [];
    for (var range in ranges) {
      for (var categoryRange in categoryRangeList) {
        var newRanges =
            range.calcNewRanges(categoryRange, categoryRange.offset!);
        if (newRanges.isNotEmpty) {
          replacedRanges.add(range);
          additionalRanges.addAll(newRanges);
        }
        print("range: {{ $range X $categoryRange }} ---> $newRanges");
      }
    }
    print("------");
    ranges = ranges.where((range) => !replacedRanges.contains(range)).toList();
    ranges.addAll(additionalRanges.toList());
    ranges.sort((a, b) => a.start.compareTo(b.start));
    print(ranges);
  }

  print(ranges
      .reduce((value, element) => value.end < element.end ? value : element)
      .end);
}

void main() {
  final input = FileReader.readFile();
  final seeds = Utils.lineToListInt(input.first);

  // [DESTINATION, SOURCE, LENGTH]

  final seedToSoil = getMap('seed-to-soil map', input);
  final soilToFertilizer = getMap('soil-to-fertilizer map', input);
  final fertilizerToWater = getMap('fertilizer-to-water map', input);
  final waterToLight = getMap('water-to-light map', input);
  final lightToTemperature = getMap('light-to-temperature map', input);
  final temperatureToHumidity = getMap('temperature-to-humidity map', input);
  final humidityToLocation = getMap('humidity-to-location map', input);

  final gardenMaps = [
    seedToSoil,
    soilToFertilizer,
    fertilizerToWater,
    waterToLight,
    lightToTemperature,
    temperatureToHumidity,
    humidityToLocation,
  ];

  partTwo(seeds, gardenMaps);

  // final x1 = Range(5, 2);
  // final y = Range(4, 4);
  // final x2 = Range(3, 3);
  // final x3 = Range(6, 4);
  // final x4 = Range(2, 7);
  // final x5 = Range(2, 3);
  // final x6 = Range(7, 3);
  // final x7 = Range(4, 2);
  // final x8 = Range(6, 2);

  // print(x1.calcNewRanges(y, 0));
  // print("------");
  // print(x2.calcNewRanges(y, 0));
  // print("------");
  // print(x3.calcNewRanges(y, 0));
  // print("------");
  // print(x4.calcNewRanges(y, 0));
  // print("------");
  // print(x5.calcNewRanges(y, 0));
  // print("------");
  // print(x6.calcNewRanges(y, 0));
  // print("------");
  // print(x7.calcNewRanges(y, 0));
  // print("------");
  // print(x8.calcNewRanges(y, 0));
}

class Range {
  final int start;

  final int length;

  int? offset;

  String? repr;

  int get end => start + length - 1;

  Range(this.start, this.length, {this.offset, this.repr});

  /// Returns whether a range is in another subRange in anyway
  bool isInOtherRange(Range otherRange) {
    return isX1(otherRange) ||
        isX2(otherRange) ||
        isX3(otherRange) ||
        isX4(otherRange);
  }

  bool isX1(Range otherRange) =>
      start >= otherRange.start && end <= otherRange.end;

  bool isX2(Range otherRange) =>
      start < otherRange.start &&
      end >= otherRange.start &&
      end <= otherRange.end;

  bool isX3(Range otherRange) =>
      start <= otherRange.end &&
      end >= otherRange.end &&
      start >= otherRange.start;

  bool isX4(Range otherRange) =>
      start < otherRange.start && end > otherRange.end;

  /// Returns subranges based on overlaps on `otherRange`. Uses offset
  /// to map the overlapping values while the non-overlapping values
  /// are not mapped.
  List<Range> calcNewRanges(Range otherRange, int offset) {
    // Range's end is in the otherRange but not the start
    if (isX2(otherRange)) {
      // "x2"
      return [
        Range(start, otherRange.start - start),
        Range(otherRange.start + offset, end - otherRange.start + 1, repr: "X2")
      ];
    }

    // Range is in the otherRange completely
    if (isX1(otherRange)) {
      // "x1"
      return [Range(start + offset, length)];
    }

    // Range start is below otherRange end, range end is above other range end
    if (isX3(otherRange)) {
      // "x3"
      return [
        Range(start + offset, otherRange.end - start + 1, repr: "X3"),
        Range(otherRange.end + 1, end - otherRange.end)
      ];
    }

    // Range start is less than other range end but the end is above the other range's end
    if (isX4(otherRange)) {
      // "x4"
      return [
        Range(start, otherRange.start - start),
        Range(otherRange.start + offset, otherRange.length),
        Range(otherRange.end + 1, end - otherRange.end)
      ];
    }

    // No overlaps found. Return nothing.
    return [];
  }

  @override
  String toString() {
    return "Range(start: $start, length: $length, end: $end${repr != null ? ", repr: " + repr.toString() : ""})";
  }

  @override
  // TODO: implement hashCode
  int get hashCode => start ^ end ^ length;
}
