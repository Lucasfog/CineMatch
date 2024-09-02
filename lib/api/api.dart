import 'dart:convert';

import 'package:cine_match/constants.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:http/http.dart' as http;

class Api {
  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?language=pt-br&api_key=${Constants.apiKey}';

  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?language=pt-br&page=1&api_key=${Constants.apiKey}';

  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?language=pt-br&page=1&api_key=${Constants.apiKey}';

  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(_trendingUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(_topRatedUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<MovieModel>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(_upcomingUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }
}
