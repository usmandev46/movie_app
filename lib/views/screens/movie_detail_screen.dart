import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/views/screens/select_seat_screen.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../models/movie_list_model/genre_map.dart';
import '../../viewmodels/movie_detail_viewmodel.dart';
import '../widgets/custom_cached_image.dart';


class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  String formattedDate(DateTime? date) {
    if (date == null) return "N/A";
    return DateFormat("MMMM dd, yyyy").format(date);
  }

  void _playTrailer(BuildContext context, String youtubeKey) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => _TrailerDialog(youtubeKey: youtubeKey),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Scaffold(
      body: Consumer<MovieDetailsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (vm.movie == null) {
            return const Center(child: Text("No movie data found"));
          }

          final movie = vm.movie!;
          final trailerKey = vm.getTrailer()?.key;

          return Column(
            children: [
              SizedBox(
                height: AppSize.h(50),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.h(50),
                      child: CustomCachedImage(
                        imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                        fit: BoxFit.fill,
                         borderRadius: .circular(0),
                      ),
                    ),

                    Positioned(
                      top: AppSize.h(5),
                      left: AppSize.w(4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "Watch",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: AppSize.h(3),
                      left: AppSize.w(4),
                      right: AppSize.w(4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "In theaters ${formattedDate(movie.releaseDate)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: AppSize.h(1)),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SelectSeatScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              padding: EdgeInsets.symmetric(
                                vertical: AppSize.h(1.5),
                                horizontal: AppSize.w(16),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Get Ticket",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: AppSize.h(1)),
                          if (trailerKey != null && trailerKey.isNotEmpty)
                            OutlinedButton.icon(
                              onPressed: () => _playTrailer(context, trailerKey),
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              label: const Text(
                                "Watch Trailer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.secondary),
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSize.h(1.5),
                                  horizontal: AppSize.w(10),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.w(4),
                    vertical: AppSize.h(2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Genres",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSize.h(1)),
                      Wrap(
                        spacing: AppSize.w(2),
                        runSpacing: AppSize.h(1),
                        children: movie.genres.map(
                              (g) {
                            final color = genreColors[g.name] ?? Colors.grey;

                            return Chip(
                              label: Text(g.name),
                              backgroundColor: color,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(height: AppSize.h(2)),
                      const Text(
                        "Overview",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppSize.h(1)),
                      Text(
                        maxLines: 15,
                        movie.overview,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF8F8F8F)),
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

class _TrailerDialog extends StatefulWidget {
  final String youtubeKey;
  const _TrailerDialog({required this.youtubeKey});

  @override
  State<_TrailerDialog> createState() => _TrailerDialogState();
}

class _TrailerDialogState extends State<_TrailerDialog> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeKey,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: AppSize.h(30),
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}