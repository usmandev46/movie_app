import 'package:flutter_dotenv/flutter_dotenv.dart';

class TMDBEndpoints {
  static const String baseUrl = "https://api.themoviedb.org/3";
  static final String apiKey = dotenv.env['TMDB_API_KEY'] ?? "";
  static final String language = dotenv.env['TMDB_LANGUAGE'] ?? "en-US";

  static  String movieList =
      "$baseUrl/movie/upcoming"
      "?api_key=$apiKey"
      "&language=$language"
      "&include_adult=false";

  static String movieVideos(int movieId) =>
      "$baseUrl/movie/$movieId/videos?api_key=$apiKey";

  static String searchMovies({
    required String query,
    required int page,
    bool includeAdult = false,
  }) {
    return "$baseUrl/search/movie"
        "?api_key=$apiKey"
        "&query=$query"
        "&language=$language"
        "&include_adult=$includeAdult"
        "&page=$page";
  }

  static String movieDetails(int movieId) {
    return "$baseUrl/movie/$movieId"
        "?api_key=$apiKey"
        "&language=$language";
  }

  static const String imageW500 = "https://image.tmdb.org/t/p/w500";
  static const String imageOriginal = "https://image.tmdb.org/t/p/original";
}
