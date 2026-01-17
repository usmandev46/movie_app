import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/views/screens/booking_screen.dart';
import 'package:provider/provider.dart';
import 'package:movie_booking_app/core/constants/colors.dart';
import '../../core/utils/app_size.dart';
import '../../viewmodels/seat_selection_viewmodel.dart';

class SelectSeatScreen extends StatelessWidget {
  const SelectSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      body: Consumer<SeatSelectionViewModel>(
        builder: (context, vm, _) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: AppSize.h(8),
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 1,
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
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppSize.w(4),
                    right: AppSize.w(4),
                    top: AppSize.h(10),
                  ),
                  child: Text(
                    "Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSize.h(8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.w(4),
                      vertical: AppSize.h(2),
                    ),
                    itemCount: vm.next7Days.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSize.w(2)),
                    itemBuilder: (context, index) {
                      final date = vm.next7Days[index];
                      final isSelected =
                          date.year == vm.selectedDate.year &&
                          date.month == vm.selectedDate.month &&
                          date.day == vm.selectedDate.day;

                      final day = DateFormat('d').format(date);
                      final month = DateFormat('MMM').format(date);

                      return GestureDetector(
                        onTap: () => vm.selectDate(date),
                        child: Container(
                          width: AppSize.w(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.secondary
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                day,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                month,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SliverPadding(padding: EdgeInsetsGeometry.only(bottom: AppSize.h(5),)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppSize.h(26),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.w(4)),
                    itemCount: vm.showtimes.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSize.w(3)),
                    itemBuilder: (context, index) {
                      final item = vm.showtimes[index];
                      final isSelected = item == vm.selectedTime;

                      return GestureDetector(
                        onTap: () => vm.selectTime(item),
                        child: SizedBox(
                          width: AppSize.w(70),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "$item ",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Cinetech + Hall 1",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: AppSize.h(1)),

                              SizedBox(
                                height: AppSize.h(18),
                                width: AppSize.w(65),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.secondary
                                          : Colors.grey.withValues(alpha: 0.2),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/Map Mobile.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: AppSize.h(1)),

                              RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "From ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "50\$",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text: " or ",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "2500 bonus",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),


              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.w(4),
                    vertical: AppSize.h(2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BookingScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: EdgeInsets.symmetric(vertical: AppSize.h(1.6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Select Seat",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          );
        },
      ),
    );
  }
}
