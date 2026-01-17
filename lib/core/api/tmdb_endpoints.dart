class TMDBEndpoints {
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String apiKey = "8fdf0c121fc212884a2a2e7eb9e9c753";
  static const String language = "en-US";

  static const String movieList =
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
