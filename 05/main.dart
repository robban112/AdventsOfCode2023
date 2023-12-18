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
      mappedDestination = startSource + diff;
    }
  }
  return mappedDestination;
}

/// Traverses the location of a categoryNumber (seed) and returns
/// the final location.
int traverseToLocation(
  int categoryNumber,
  int currCategory,
  List<List<List<int>>> listOfMap,
) {
  if (currCategory >= listOfMap.length) return categoryNumber;
  int nextCategoryNumber = getDestination(
    categoryNumber,
    listOfMap[currCategory],
  );
  return traverseToLocation(nextCategoryNumber, currCategory + 1, listOfMap);
}

void partOne(List<int> seeds, List<List<List<int>>> gardenMaps) {
  print(seeds
      .map((seed) => traverseToLocation(seed, 0, gardenMaps))
      .reduce((value, element) => value < element ? value : element));
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

  partOne(seeds, gardenMaps);
}
