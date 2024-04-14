import 'dart:math' as math;

import 'package:flutter/services.dart';

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

class NumberTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final regExp = RegExp(r'^[0-9]+([0-9]?)?$');
    if (regExp.hasMatch(newText)) {
      return newValue;
    }
    return oldValue;
  }
}

class DoubleInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final regExp = RegExp(r'^[0-9]+([.][0-9]{2,})?$');
    if (regExp.hasMatch(newText)) {
      return newValue;
    }
    return oldValue;
  }
}
