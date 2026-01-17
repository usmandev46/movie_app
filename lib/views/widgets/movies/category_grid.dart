import 'package:flutter/material.dart';
import 'package:movie_booking_app/views/widgets/movies/search_movie_card.dart';
import '../../../core/utils/app_size.dart';
import '../../../models/movie_list_model/category_model.dart';

class CategoryGrid extends StatelessWidget {
  CategoryGrid({super.key});

  final List<CategoryModel> categories = [
    CategoryModel(
      title: "Action",
      imageUrl: "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2",
    ),
    CategoryModel(
      title: "Comedy",
      imageUrl: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    ),
    CategoryModel(
      title: "Drama",
      imageUrl: "https://images.unsplash.com/photo-1606112219348-204d7d8b94ee",
    ),
    CategoryModel(
      title: "Horror",
      imageUrl: "https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d",
    ),
    CategoryModel(
      title: "Music",
      imageUrl: "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2",
    ),
    CategoryModel(
      title: "Romance",
      imageUrl: "https://images.unsplash.com/photo-1524985069026-dd778a71c7b4",
    ),
    CategoryModel(
      title: "Sci-Fi",
      imageUrl: "https://images.unsplash.com/photo-1519125323398-675f0ddb6308",
    ),
    CategoryModel(
      title: "Documentary",
      imageUrl: "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    ),
    CategoryModel(
      title: "Fantasy",
      imageUrl: "https://images.unsplash.com/photo-1470770841072-f978cf4d019e",
    ),
    CategoryModel(
      title: "Thriller",
      imageUrl: "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSize.h(1),
        crossAxisSpacing: AppSize.w(2),
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return SearchMovieCard(
          title: category.title,
          imageUrl: category.imageUrl,
          onTap: () {},
        );
      },
    );
  }
}
