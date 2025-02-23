import 'package:flutter/material.dart';
import 'package:peliculas_app/data/origin/remote/movies_request.dart';
import 'package:peliculas_app/presentation/components/movie_card_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of movies fetched from the API
  late Future<Map<String, dynamic>> moviesRequest;

  @override
  void initState() {
    super.initState();
    moviesRequest = MoviesRequest().fetchPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Latest',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: moviesRequest,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading movies'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No movies found'),
            );
          } else {
            final movies = snapshot.data!['results'];
            return MovieCardGrid(movies: movies);
          }
        },
      ),
    );
  }
}
