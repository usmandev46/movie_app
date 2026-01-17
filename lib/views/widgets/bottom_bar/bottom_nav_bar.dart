import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../viewmodels/bottom_nav_viewmodel.dart';

class MainBottomBar extends StatelessWidget {
  const MainBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BottomNavViewModel>();

    return ClipRRect(
      borderRadius: .circular(25),
      child: BottomNavigationBar(
        currentIndex: vm.currentIndex,
        onTap: (v){
          vm.changeIndex(v, context);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11
        ),
        unselectedLabelStyle: const TextStyle( fontSize: 10),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Watch'),
          BottomNavigationBarItem(
            icon: Icon(Icons.media_bluetooth_on),
            label: 'Media Library',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.read_more_rounded), label: 'More'),
        ],
      ),
    );
  }
}
