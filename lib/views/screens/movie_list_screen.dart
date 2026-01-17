import 'package:flutter/material.dart';
import 'package:movie_booking_app/core/constants/colors.dart';
import 'package:provider/provider.dart';
import '../../core/utils/app_size.dart';
import '../../viewmodels/movie_detail_viewmodel.dart';
import '../../viewmodels/movie_list_viewmodel.dart';
import 'movie_detail_screen.dart';
import 'search_screen.dart';
import '../widgets/movies/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final vm = context.read<MovieListViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.fetchMovies();
    });


    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        vm.fetchMovies(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    final vm = context.watch<MovieListViewModel>();

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: AppSize.h(6),
            pinned: true,
            title: const Text('Watch', style: TextStyle(fontSize: 16)),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),

          if (vm.isLoading && vm.movies.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else
            SliverPadding(
              padding: .all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index < vm.movies.length) {
                    final movie = vm.movies[index];
                    return MovieCard(
                      title: movie.title,
                      posterPath: "https://image.tmdb.org/t/p/w500${movie.posterPath}",
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

                  return vm.isMoreLoading
                      ? const Padding(
                          padding: .all(16),
                          child: Center(
                            child: CircularProgressIndicator(color: AppColors.primary),
                          ),
                        )
                      : const SizedBox();
                }, childCount: vm.movies.length + 1),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}