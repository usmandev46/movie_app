import 'package:flutter/material.dart';
import 'package:movie_booking_app/views/widgets/bottom_bar/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/bottom_nav_viewmodel.dart';
import '../../core/navigation/bottom_nav_screens.dart';


class MovieBottomBarScreen extends StatelessWidget {
  const MovieBottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BottomNavViewModel>();

    return Scaffold(
      body: IndexedStack(
        index: vm.currentIndex,
        children: BottomNavScreens.screens,
      ),
      bottomNavigationBar: const MainBottomBar(),
    );
  }
}
