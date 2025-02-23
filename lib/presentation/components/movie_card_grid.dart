import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_app/router/app_router_constants.dart';

class MovieCardGrid extends StatelessWidget {
  const MovieCardGrid({super.key, required this.movies});

  final dynamic movies;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Wrap GridView in Expanded to avoid cutoff of last item
      child: GridView.builder(
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
            offset: Offset(
                0,
                isOddIndex
                    ? 20
                    : 0), // Move every second card down by 20 pixels
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
                  'rating':
                      '${(movie['vote_average'] * 10).round()}% User Score',
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map<String, String> movie;
  const MovieCard({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // More rounded corners
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Match card's rounded corners
        child: Stack(
          alignment: Alignment.bottomLeft, // Align text to the bottom left
          children: [
            Image.network(
              movie['image']!,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover, // Cover the entire space
            ),
            // Gradient overlay for better text visibility
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6), // Darker overlay
                    Colors.transparent, // Transparent at the top
                  ],
                ),
              ),
            ),
            // Movie title and rating
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Spacing between title and rating
                  Text(
                    movie['rating']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
