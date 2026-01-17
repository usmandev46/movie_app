import 'package:flutter/material.dart';

import '../../views/screens/movie_list_screen.dart';

class BottomNavScreens {
  static const List<Widget> screens = [
    Center(child: Text('Dashboard')),
    MovieListScreen(),
    Center(child: Text('Media Library')),
    Center(child: Text('More')),
  ];
}
