import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HelperFunction {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd/MM/yyyy').format(date);
    final onlyTime = DateFormat('hh:mm').format(date);
    return '$onlyDate at $onlyTime';
  }

  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('hh:mm a - dd MMMM yy');
    return formatter.format(dateTime);
  }
}