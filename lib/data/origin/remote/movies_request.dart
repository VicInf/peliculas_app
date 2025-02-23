import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MoviesRequest {
  final apikey = dotenv.env['API_KEY'];
  final path = 'https://api.themoviedb.org/3/movie';

  Future<Map<String, dynamic>> fetchPopularMovies() async {
    final url = Uri.parse(
      '$path/popular?api_key=$apikey',
    );

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(String movieId) async {
    final url = Uri.parse(
      '$path/$movieId/credits?api_key=$apikey',
    );

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Fetch actor's details using their ID
  Future<Map<String, dynamic>> getActorDetails(String actorId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/person/$actorId?api_key=$apikey', // Replace with your API key
    );

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load actor details');
    }
  }

  // Fetch the movies the actor has been in
  Future<Map<String, dynamic>> getActorMovies(String actorId) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/person/$actorId/movie_credits?api_key=$apikey',
    );

    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load actor movies');
    }
  }
}
