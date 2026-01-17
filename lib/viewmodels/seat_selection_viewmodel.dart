import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeatSelectionViewModel extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;

  late Map<String, List<String>> showtimesByDate;

  SeatSelectionViewModel() {
    _generateNext7DaysShowtimes();
    _updateShowtimesForSelectedDate();
  }

  List<DateTime> get next7Days => List.generate(
    7, (i) => DateTime.now().add(Duration(days: i)),
  );

  List<String> showtimes = [];

  void selectDate(DateTime date) {
    selectedDate = date;
    selectedTime = null;
    _updateShowtimesForSelectedDate();
    notifyListeners();
  }

  void selectTime(String time) {
    selectedTime = time;
    notifyListeners();
  }

  void _generateNext7DaysShowtimes() {
    showtimesByDate = {};
    final random = Random();

    for (final date in next7Days) {
      final key = DateFormat('yyyy-MM-dd').format(date);

      final possibleTimes = [
        '10:30',
        '12:30',
        '15:00',
        '18:30',
        '21:00',
      ];

      possibleTimes.shuffle();

      final count = random.nextInt(4) + 1;

      showtimesByDate[key] = possibleTimes.take(count).toList();
    }
  }

  void _updateShowtimesForSelectedDate() {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    showtimes = showtimesByDate[key] ?? [];
  }
}
