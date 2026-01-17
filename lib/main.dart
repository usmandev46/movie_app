import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_app/viewmodels/booking_view_model.dart';
import 'package:movie_booking_app/viewmodels/bottom_nav_viewmodel.dart';
import 'package:movie_booking_app/viewmodels/movie_detail_viewmodel.dart';
import 'package:movie_booking_app/viewmodels/movie_list_viewmodel.dart';
import 'package:movie_booking_app/viewmodels/search_viewmodel.dart';
import 'package:movie_booking_app/viewmodels/seat_selection_viewmodel.dart';
import 'package:movie_booking_app/views/screens/movie_bottombar_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/constants/colors.dart';
import 'core/utils/size_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => MovieListViewModel()),
        ChangeNotifierProvider(create: (_) => MovieDetailsViewModel()),
        ChangeNotifierProvider(create: (_) => SeatSelectionViewModel()),
        ChangeNotifierProvider(create: (_) => BookingViewModel()),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return MaterialApp(
      title: 'Movie Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MovieBottomBarScreen(),
    );
  }
}
