import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peliculas_app/data/origin/remote/movies_request.dart';
import 'package:peliculas_app/presentation/components/movie_card_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.actorId});
  final String actorId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> actorDetails;

  @override
  void initState() {
    super.initState();
    actorDetails = MoviesRequest().getActorDetails(widget.actorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: actorDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No actor information available'));
          }

          final actor = snapshot.data!;
          final actorName = actor['name'];
          final actorBio = actor['biography'] ?? 'No biography available.';
          final actorImage = actor['profile_path'] != null
              ? 'https://image.tmdb.org/t/p/w500${actor['profile_path']}'
              : 'https://archive.org/download/placeholder-image/placeholder-image.jpg'; // Placeholder if no image

          return FutureBuilder<Map<String, dynamic>>(
            future: MoviesRequest().getActorMovies(widget.actorId),
            builder: (context, movieSnapshot) {
              if (movieSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (movieSnapshot.hasError) {
                return Center(child: Text('Error: ${movieSnapshot.error}'));
              } else if (!movieSnapshot.hasData) {
                return const Center(child: Text('No movies found'));
              }

              final movies = movieSnapshot.data!['cast'];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 24, left: 24, top: 60, bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Back Button
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.greenAccent.withValues(alpha: 0.9),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                        ),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const SizedBox(height: 16),
                      // Actor Profile Section (Image and Name/Bio)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(actorImage),
                          ),
                          const SizedBox(width: 16),
                          // Actor Name and Biography
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Actor Name
                                Text(
                                  actorName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Actor Biography
                                Text(
                                  actorBio,
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5, // Limit to 5 lines
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Movies Section
                      const Text(
                        'Casted on',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                          height: 500, child: MovieCardGrid(movies: movies)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
