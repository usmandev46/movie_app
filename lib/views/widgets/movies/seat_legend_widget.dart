import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/colors.dart';
import '../../../core/utils/app_size.dart';


class SeatLegendWidget extends StatelessWidget {
  final double iconWidth;
  final double iconHeight;
  final double fontSize;

  const SeatLegendWidget({
    super.key,
    required this.iconWidth,
    required this.iconHeight,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final legendItems = [
      {"color": AppColors.selectedSeat, "label": "Selected"},
      {"color": AppColors.unselectedSeat, "label": "Not Available"},
      {"color": AppColors.vipSeat, "label": "VIP (150 \$)"},
      {"color": AppColors.secondary, "label": "Regular (50 \$)"},
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: AppSize.h(1),
      crossAxisSpacing: AppSize.w(2),
      childAspectRatio: 3.5,
      physics: const NeverScrollableScrollPhysics(),
      children: legendItems.map((item) {
        return Row(
          children: [
            SvgPicture.asset(
              "assets/Seat.svg",
              color: item["color"] as Color,
              width: iconWidth,
              height: iconHeight,
            ),
            SizedBox(width: AppSize.w(2)),
            Text(
              item["label"] as String,
              style: TextStyle(fontSize: fontSize),
            ),
          ],
        );
      }).toList(),
    );
  }
}
