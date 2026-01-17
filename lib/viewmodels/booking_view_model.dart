import 'package:flutter/material.dart';

import '../models/movie_list_model/seat_model.dart';

class BookingViewModel extends ChangeNotifier {
  final int totalRows = 10;
  final int centerSeats = 14;
  double seatSize = 15;

  List<List<Seat>> rows = [];

  BookingViewModel() {
    _initSeats();
  }

  void increaseSeatSize() {
    if (seatSize < 25) {
      seatSize += 2;
      notifyListeners();
    }
  }

  void decreaseSeatSize() {
    if (seatSize > 18) {
      seatSize -= 2;
      notifyListeners();
    }
  }

  int sideSeatCount(int row) {
    if (row < 1) return 2;
    if (row <= 3) return 4;
    return 5;
  }

  void _initSeats() {
    rows = List.generate(totalRows, (rowIndex) {
      SeatState rowState =
      rowIndex == 9 ? SeatState.vipseat : SeatState.available;

      int sideSeats = sideSeatCount(rowIndex);

      List<Seat> rowSeats = [];

      for (int i = 0; i < sideSeats; i++) {
        rowSeats.add(Seat(rowIndex: rowIndex, seatIndex: i, state: rowState));
      }

      for (int i = 0; i < centerSeats; i++) {
        rowSeats.add(Seat(
            rowIndex: rowIndex, seatIndex: sideSeats + i, state: rowState));
      }

      for (int i = 0; i < sideSeats; i++) {
        rowSeats.add(Seat(
            rowIndex: rowIndex,
            seatIndex: sideSeats + centerSeats + i,
            state: rowState));
      }

      return rowSeats;
    });
    notifyListeners();
  }

  void toggleSeat(Seat seat) {
    if (seat.state == SeatState.available) {
      seat.state = SeatState.selected;
    } else if (seat.state == SeatState.selected) {
      seat.state = SeatState.available;
    }
    notifyListeners();
  }
}
