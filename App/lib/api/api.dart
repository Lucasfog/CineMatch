import 'dart:convert';

import 'package:cine_match/constants.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await http.get(Uri.parse(Constants.trendingUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(Constants.topRatedUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<MovieModel>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(Constants.upcomingUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      return decodedData.map((movie) => MovieModel.fromJson(movie)).toList();
    } else {
      throw Exception('Something happened');
    }
  }

  Future<List<MovieModel>> getFavoriteMovies(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('${Constants.routeLoadFavorite}$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> favoriteList = jsonDecode(response.body);
        List<int> favoriteIds =
            favoriteList.map((item) => item['IdFilme'] as int).toList();

        List<MovieModel> favoriteMovies = [];
        for (int id in favoriteIds) {
          final movieResponse = await http.get(Uri.parse(
              'https://api.themoviedb.org/3/movie/$id?api_key=${Constants.apiKey}'));
          if (movieResponse.statusCode == 200) {
            favoriteMovies
                .add(MovieModel.fromJson(jsonDecode(movieResponse.body)));
          }
        }
        return favoriteMovies;
      } else {
        throw Exception('Erro ao buscar IDs de filmes favoritos');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> fetchMovies(String query) async {
    if (query.isEmpty) return [];

    var fetchUrl =
        'https://api.themoviedb.org/3/search/movie?api_key=${Constants.apiKey}&query=$query&language=pt-BR&include_adult=false';

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Falha ao carregar filmes');
    }
  }

// ---------------------------------------------------------------------------

  Future<http.Response> login(String email, String senha) async {
    final url = Uri.parse(Constants.routeLogin);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senha}),
    );

    return response;
  }

  Future<http.Response> registerUser(Map<String, String> userData) async {
    final url = Uri.parse(Constants.routeUser);

    final body = jsonEncode(userData);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response;
  }

  Future<http.Response> passwordRecovery(String email) async {
    final url = Uri.parse(Constants.routePasswordRecovery);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          "Erro ao solicitar recuperação de senha: ${response.body}");
    }
  }

  Future<http.Response> validateCode(String email, String resetCode) async {
    final response = await http.post(
      Uri.parse(Constants.routeValidateCode),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'resetCode': resetCode,
      }),
    );
    return response;
  }

  Future<http.Response> resetPassword(String email, String novaSenha) async {
    final response = await http.post(
      Uri.parse(Constants.routeResetPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': novaSenha,
      }),
    );
    return response;
  }

  Future<http.Response> addMovieToFavorites(int userId, int movieId) async {
    final url = Uri.parse(Constants.routeAddFavorites);

    final body = jsonEncode({"idUsuario": userId, "idFilme": movieId});

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response;
  }

  Future<http.Response> removeMovieFromFavorites(
      int userId, int movieId) async {
    final url = Uri.parse(Constants.routeRemoveFavorites);

    final body = json.encode({"idUsuario": userId, "idFilme": movieId});

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return response;
  }

  Future<http.Response> isMovieFavorite(userId, movieId) async {
    final url = Uri.parse(
        '${Constants.routeFavoriteCheck}?userId=$userId&movieId=$movieId');
    final response = await http.get(url);

    return response;
  }
}
