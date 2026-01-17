import 'package:flutter/material.dart';

import '../../../core/utils/app_size.dart';
import '../../../models/movie_list_model/seat_model.dart';
import '../../../viewmodels/booking_view_model.dart';
import '../../screens/booking_screen.dart';

Widget buildSeatRowVM(
    List<Seat> seats, BookingViewModel vm, int rowIndex)
{
  int sideSeats = vm.sideSeatCount(rowIndex);
  double leftExtraGap = AppSize.w(2);
  double rightExtraGap = AppSize.w(0);

  return Padding(
    padding: EdgeInsets.symmetric(vertical: AppSize.h(.5)),
    child: Row(
      mainAxisAlignment: .start,
      crossAxisAlignment: .start,
      children: [
        SizedBox(width: leftExtraGap),
        Row(
            children: seats.sublist(0, sideSeats).map((seat) => SeatWidget(seat: seat)).toList()),
        SizedBox(width: AppSize.w(6.5)),
        Row(
            children: seats
                .sublist(sideSeats, sideSeats + 14)
                .map((seat) => SeatWidget(seat: seat))
                .toList()),
        SizedBox(width: AppSize.w(6.5)),
        Row(
            children: seats
                .sublist(sideSeats + 14)
                .map((seat) => SeatWidget(seat: seat))
                .toList()),
        SizedBox(width: rightExtraGap),
      ],
    ),
  );
}