import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/api/api_service.dart';
import '../core/api/tmdb_endpoints.dart';
import '../models/movie_list_model/movie_list_model.dart';

class SearchViewModel extends ChangeNotifier {
  String query = "";
  List<Result> searchResults = [];
  bool isLoading = false;
  bool isMoreLoading = false;
  int currentPage = 1;
  int totalPages = 1;

  Timer? _debounce;
  CancelToken? _cancelToken;

  void updateQuery(String value) {
    query = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchMovies(value);
    });
    notifyListeners();
  }

  void clearQuery() {
    query = "";
    _debounce?.cancel();
    _cancelToken?.cancel();
    searchResults.clear();
    currentPage = 1;
    totalPages = 1;
    isLoading = false;
    isMoreLoading = false;
    notifyListeners();
  }

  bool get isSearching => query.isNotEmpty;

  Future<void> searchMovies(String newQuery, {bool loadMore = false}) async {
    if (newQuery.isEmpty) return;

    if (_cancelToken != null && !_cancelToken!.isCancelled) {
      _cancelToken!.cancel();
    }

    _cancelToken = CancelToken();

    if (loadMore) {
      if (currentPage >= totalPages) return;
      isMoreLoading = true;
    } else {
      query = newQuery;
      searchResults.clear();
      currentPage = 1;
      totalPages = 1;
      isLoading = true;
    }

    notifyListeners();

    final url = TMDBEndpoints.searchMovies(
      query: query,
      page: currentPage,
    );

    try {
      final res = await ApiService().get(url.toString(),cancelToken: _cancelToken);
      if (res != null && res['results'] != null) {
        List movies = res['results'];
        final newResults = movies.map((e) => Result.fromJson(e)).toList();
        searchResults.addAll(newResults);
        isLoading = false;
        totalPages = res['total_pages'] ?? 1;
        currentPage++;
      }
    } catch (e) {
      isLoading = false;
      if (kDebugMode) print("Search API Error: $e");
    } finally {
      isMoreLoading = false;
      notifyListeners();
    }
  }

}
