enum SeatState {
  available,
  selected,
  unavailable,
  vipseat,
  regularSeat,
  notAvailiable,
}

class Seat {
  final int rowIndex;
  final int seatIndex;
  SeatState state;

  Seat({
    required this.rowIndex,
    required this.seatIndex,
    required this.state,
  });
}
