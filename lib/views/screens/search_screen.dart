import 'package:flutter/material.dart';
import 'package:movie_booking_app/core/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_size.dart';
import '../../models/movie_list_model/genre_map.dart';
import '../../viewmodels/movie_detail_viewmodel.dart';
import '../../viewmodels/search_viewmodel.dart';
import '../widgets/movies/category_grid.dart';
import '../widgets/movies/custom_search_bar.dart';
import '../widgets/movies/search_vert_card.dart';
import '../widgets/bottom_bar/bottom_nav_bar.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    _scrollController.addListener(() {
      final vm = context.read<SearchViewModel>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!vm.isLoading) {
          vm.searchMovies(vm.query, loadMore: true);
        }
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final vm = context.watch<SearchViewModel>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.h(8)),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: CustomSearchBar(
            controller: searchController,
            onChanged: (value) {
              vm.updateQuery(value);
              vm.searchMovies(value);
            },
            onClear: () {
              searchController.clear();
              vm.clearQuery();
              vm.searchResults.clear();
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.w(3),
          vertical: AppSize.h(1),
        ),
        child: vm.isSearching
            ? Builder(
                builder: (context) {
                  if (vm.isLoading && vm.searchResults.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (!vm.isLoading && vm.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: const [
                          Icon(Icons.search_off, size: 60, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "No results found",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: .w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(AppSize.w(3)),
                        child: const Text(
                          "Top Results",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(thickness: 0.5),

                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: vm.searchResults.length + (vm.isMoreLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < vm.searchResults.length) {
                              final movie = vm.searchResults[index];

                              return SearchVertCard(
                                title: movie.title,
                                subtitle: movie.genreIds.isNotEmpty
                                    ? (genreMap[movie.genreIds.first]?['name'] ?? "Unknown")
                                    : "Unknown",
                                imageUrl: movie.posterPath != null
                                    ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                                    : "https://static.vecteezy.com/system/resources/thumbnails/021/850/617/small/realistic-cinema-poster-vector.jpg",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (_) => MovieDetailsViewModel()
                                          ..fetchMovieDetails(movie.id),
                                        child: const MovieDetailScreen(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            return const Padding(
                              padding: .all(16),
                              child: Center(
                                child: CircularProgressIndicator(color: AppColors.primary),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              )
            : CategoryGrid(),
      ),
      bottomNavigationBar: const MainBottomBar(),
    );
  }
}
