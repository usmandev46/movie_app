import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/app_size.dart';
import '../../models/movie_list_model/seat_model.dart';
import '../../viewmodels/booking_view_model.dart';
import '../widgets/movies/booking_screen_widget.dart';
import '../widgets/movies/seat_legend_widget.dart';

class SeatWidget extends StatelessWidget {
  final Seat seat;

  const SeatWidget({super.key, required this.seat});

  @override
  Widget build(BuildContext context) {
    final seatSize = Provider.of<BookingViewModel>(context).seatSize;

    Color color;
    switch (seat.state) {
      case SeatState.selected:
        color = AppColors.selectedSeat;
        break;
      case SeatState.vipseat:
        color = AppColors.vipSeat;
        break;
      case SeatState.regularSeat:
        color = AppColors.secondary;
        break;
      case SeatState.notAvailiable:
        color = AppColors.unselectedSeat;
        break;
      default:
        color = AppColors.unselectedSeat;
    }

    return GestureDetector(
      onTap: () {
        Provider.of<BookingViewModel>(context, listen: false).toggleSeat(seat);
      },
      child: Container(
        width: seatSize,
        height: seatSize,
        margin: EdgeInsets.all(AppSize.h(.5)),
        child: SvgPicture.asset("assets/Seat.svg", color: color),
      ),
    );
  }
}

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double seatIconWidth = AppSize.w(2.5);
    final double seatIconHeight = AppSize.h(2.5);
    final double fontSize = 14;
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(),
      child: Consumer<BookingViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: AppSize.h(8),
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: AppSize.h(1),
                  leading: IconButton(
                    icon: const Icon(CupertinoIcons.back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.only(bottom: AppSize.h(1)),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'The King’s Man',
                          style: TextStyle(fontSize: 11),
                        ),
                        SizedBox(height: AppSize.h(0.5)),
                        const Text(
                          'In theaters December 22, 2021',
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Stack(
                    alignment: AlignmentGeometry.bottomRight,
                    children: [
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.h(3)),
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: AppSize.h(2)),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Text(
                                    "SCREEN",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Image(
                                    height: AppSize.h(7),
                                    width: AppSize.w(150),
                                    image: AssetImage("assets/boarder.png"),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSize.h(3)),

                              ...List.generate(
                                vm.rows.length,
                                (rowIndex) => buildSeatRowVM(
                                  vm.rows[rowIndex],
                                  vm,
                                  rowIndex,
                                ),
                              ),

                              SizedBox(height: AppSize.h(4)),
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        right: 20,
                        bottom: AppSize.h(1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RawMaterialButton(
                              onPressed: () {
                                Provider.of<BookingViewModel>(
                                  context,
                                  listen: false,
                                ).increaseSeatSize();
                              },
                              elevation: 2,
                              fillColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(AppSize.h(1)),
                              constraints: BoxConstraints(),
                              child: Icon(Icons.add, size: AppSize.h(2)),
                            ),
                            SizedBox(width: AppSize.w(1)),
                            RawMaterialButton(
                              onPressed: () {
                                Provider.of<BookingViewModel>(
                                  context,
                                  listen: false,
                                ).decreaseSeatSize();
                              },
                              elevation: 2,
                              fillColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(AppSize.h(1)),
                              constraints: BoxConstraints(),
                              child: Icon(
                                Icons.remove,
                                color: Colors.grey.shade700,
                                size: AppSize.h(2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: AppSize.h(36),
                    decoration: BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: AppSize.w(4)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SeatLegendWidget(
                          iconWidth: seatIconWidth,
                          iconHeight: seatIconHeight,
                          fontSize: fontSize,
                        ),

                        SizedBox(height: AppSize.h(10)),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300,
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.h(.5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSize.h(1),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Total price\n",
                                        style: TextStyle(
                                          fontSize: AppSize.h(1.4),
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "50\$",
                                        style: TextStyle(
                                          fontSize: AppSize.h(1.5),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSize.w(2)),
                            Expanded(
                              flex: 3,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.h(1.6),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSize.h(1),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "Proceed to Pay",
                                  style: TextStyle(
                                    fontSize: AppSize.h(1.8),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
