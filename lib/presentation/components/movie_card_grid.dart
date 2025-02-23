import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_app/presentation/components/movie_card.dart';
import 'package:peliculas_app/router/app_router_constants.dart';

class MovieCardGrid extends StatelessWidget {
  const MovieCardGrid({super.key, required this.movies});

  final dynamic movies;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.65, // Adjust ratio for card sizes
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        // Apply a vertical offset to every second card
        final isOddIndex = index.isOdd;
        return Transform.translate(
          offset: Offset(0,
              isOddIndex ? 20 : 0), // Move every second card down by 20 pixels
          child: GestureDetector(
            onTap: () {
              context.pushNamed(
                AppRouterConstants.movieDetails,
                extra: movie,
              );
            },
            child: MovieCard(
              movie: {
                'image': movie['poster_path'] != null
                    ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                    : 'https://archive.org/download/placeholder-image/placeholder-image.jpg', //Placeholder if no image
                'title': movie['title'],
                'rating': '${(movie['vote_average'] * 10).round()}% User Score',
              },
            ),
          ),
        );
      },
    );
  }
}
