import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter/material.dart';


double roundDecimal(double number, num places) {
  places = pow(10, places);
  return (number * places).round() / places;
}

NumberFormat nf = NumberFormat.decimalPattern("en_us");

String formatNumber(int number, {int digits=-1, int firstDigitsExponent=6, int digitsExponent=3, int decimals=2}) {
  /* Optional Parameters:
  digits - Limit for number of digits displayed (overrides following two parameters).
  firstDigitsExponent - Limit for number of digits displayed initially (before first shortening).
  digitsExponent - Limit for number of digits displayed after initial shortening.
  decimals - Limit for number of decimals shown after shortening.
  */
  if (digits != -1) {
    firstDigitsExponent = digitsExponent = digits;
  }
  double divide = 0;
  String abbreviation = "";
  if (number >= pow(10, firstDigitsExponent)) {
    if (number < pow (10, 3 + digitsExponent)) {
      divide = 1e3; abbreviation = "K";
    } else if (number < pow(10, 6 + digitsExponent)) {
      divide = 1e6; abbreviation = "M";
    } else if (number < pow(10, 9 + digitsExponent)) {
      divide = 1e9; abbreviation = "B";
    } else {
      divide = 1e12; abbreviation = "T";
    }
  }
  if (divide != 0) {
    return "${nf.format(roundDecimal(number / divide, decimals))}$abbreviation";
  }
  return nf.format(number);
}


AlertDialog popup(BuildContext context, String title, String message, {String? textAction, List<Widget>? actions}) {
  /* General usage:
  showDialog(
    context: context,
    builder: (context) => popup(context, "Title", "Message"),
  ).then((value) {
    if (value) {
      // Do something if confirmed.
    }
  });
   */
  return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: actions ?? [
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(textAction ?? "CONFIRM"),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text("CANCEL"),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red,
        )
      ),
    ],
  );
}
