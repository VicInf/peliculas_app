import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_app/data/origin/remote/movies_request.dart';
import 'package:peliculas_app/presentation/components/cast_member_card.dart';
import 'package:peliculas_app/router/app_router_constants.dart';

class MovieDetailsScreen extends StatefulWidget {
  // Specific details of a movie like actor cast
  const MovieDetailsScreen({required this.movie, super.key});
  // Movie details passed from the previous screen
  final dynamic movie;
  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<Map<String, dynamic>> movieCredits;

  @override
  void initState() {
    super.initState();
    movieCredits =
        MoviesRequest().getMovieCredits(widget.movie['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: movieCredits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!['cast'].isEmpty) {
            return const Center(
              child: Text('No cast information available'),
            );
          } else {
            final cast = snapshot.data!['cast'];
            final firstThreeCast =
                cast.take(3).toList(); // Get first 3 cast members

            return Stack(
              children: [
                // Full-Screen Movie Image
                Hero(
                  tag: 'movie-title-${widget.movie['id'] ?? 'default'}',
                  child: Image.network(
                    widget.movie['poster_path'] != null
                        ? 'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}'
                        : 'https://archive.org/download/placeholder-image/placeholder-image.jpg', // Placeholder if no image
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.fill,
                  ),
                ),
                // Gradient Overlay to make text stand out
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black
                            .withValues(alpha: 0.7), // Corrected opacity
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Back Button ("X") at the top left
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent
                                .withValues(alpha: 0.6)), // Corrected opacity
                        child: Icon(Icons.close, color: Colors.grey[800])),
                    onPressed: () {
                      // Reset navigation stack and go to the Home screen
                      context.goNamed(AppRouterConstants
                          .home); // Navigates to Home, clearing stack
                    },
                  ),
                ),
                // Movie Details Scrollable Section (at the bottom of the image)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Title
                        Text(
                          widget.movie['title'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Movie User Score
                        Text(
                          '${(widget.movie['vote_average'] * 10).round()}% User Score',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Cast Section
                        // Actor Images Row (Horizontal Scroll)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: firstThreeCast.map<Widget>((actor) {
                              return GestureDetector(
                                child: CastMemberCard(
                                  imageUrl: actor['profile_path'] != null
                                      ? 'https://image.tmdb.org/t/p/w500${actor['profile_path']}'
                                      : 'https://archive.org/download/placeholder-image/placeholder-image.jpg', // Placeholder if no image
                                  name: actor['name'],
                                  character: actor['character'],
                                ),
                                onTap: () {
                                  context.pushNamed(
                                    AppRouterConstants.profileScreen,
                                    pathParameters: {
                                      'actorId': actor['id'].toString()
                                    },
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
