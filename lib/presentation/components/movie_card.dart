import 'package:flutter/material.dart';

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
