import 'package:flutter/foundation.dart';
import '../../../core/api/api_service.dart';
import '../core/api/tmdb_endpoints.dart';
import '../models/movie_list_model/movie_details_model.dart';
import '../models/movie_list_model/movie_video_model.dart';

class MovieDetailsViewModel extends ChangeNotifier {
  MovieDetailsModel? movie;
  List<VideoResult> videos = [];
  bool isLoading = false;
  String error = "";

  Future<void> fetchMovieDetails(int movieId) async {
    isLoading = true;
    error = "";
    notifyListeners();

    final url = TMDBEndpoints.movieDetails(movieId);

    try {
      final res = await ApiService().get(url);
      if (res != null) {
        movie = MovieDetailsModel.fromJson(res);
        await fetchMovieVideos(movieId);
      } else {
        error = "Failed to load movie details";
      }
    } catch (e) {
      error = e.toString();
      if (kDebugMode) print("Movie Details Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMovieVideos(int movieId) async {
    final url = TMDBEndpoints.movieVideos(movieId);

    try {
      final res = await ApiService().get(url);
      if (res != null && res['results'] != null) {
        videos = (res['results'] as List)
            .map((e) => VideoResult.fromJson(e))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) print("Movie Videos Error: $e");
    }

    notifyListeners();
  }

  VideoResult? getTrailer() {
    try {
      return videos.firstWhere(
            (v) => v.type.toLowerCase() == "trailer" && v.site.toLowerCase() == "youtube",
        orElse: () => videos.firstWhere(
              (v) => v.type.toLowerCase() == "teaser" && v.site.toLowerCase() == "youtube",
        ),
      );
    } catch (_) {
      return null;
    }
  }


}
