import 'package:flutter/material.dart';
import 'package:movie_booking_app/core/api/api_service.dart';
import '../models/movie_list_model/movie_list_model.dart';

class MovieListViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool isMoreLoading = false;

  int page = 1;
  bool hasMore = true;

  List<Result> movies = [];

  Future<void> fetchMovies({bool loadMore = false}) async {
    if (isLoading || isMoreLoading || !hasMore) return;

    if (loadMore) {
      isMoreLoading = true;
    } else {
      isLoading = true;
      page = 1;
      movies.clear();
      hasMore = true;
    }

    notifyListeners();

    try {

      final url =
          "https://api.themoviedb.org/3/search/movie"
          "?api_key=8fdf0c121fc212884a2a2e7eb9e9c753"
          "&query=avengers"
          "&language=en-US"
          "&include_adult=false"
          "&page=$page";

      final res = await ApiService().get(url);

      if (res != null) {
        final model = MovieListModel.fromJson(res);

        final newMovies = model.results;

        if (newMovies.isEmpty) {
          hasMore = false;
        } else {
          movies.addAll(newMovies);
          page++;
        }
      }
    } catch (e) {
      debugPrint("pagination error: $e");
    } finally {
      isLoading = false;
      isMoreLoading = false;
      notifyListeners();
    }
  }
}
