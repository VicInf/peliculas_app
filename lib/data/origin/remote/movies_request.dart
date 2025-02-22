import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MoviesRequest {
  final api_key = dotenv.env['API_KEY'];
  final path = 'https://api.themoviedb.org/3/movie';

  Future<Map<String, dynamic>> fetchPopularMovies() async {
    final url = Uri.parse(
      '$path/popular',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': '$api_key',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
