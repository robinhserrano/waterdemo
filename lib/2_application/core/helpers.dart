import 'dart:math' as math;

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;

  return text[0].toUpperCase() + text.substring(1);
}

int getHighestJobNumber(List<String> jobNumbers) {
  final numberRegex = RegExp(r'\d+');
  final numbers = jobNumbers
      .map(
        (jobNumber) => int.parse(numberRegex.firstMatch(jobNumber)!.group(0)!),
      )
      .toList();

  if (numbers.isEmpty) {
    return -1;
  }

  return numbers.reduce(math.max);
}
