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

  Future<List<MovieModel>> getFavoriteMovies(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/loadfavoritos/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> favoriteList = jsonDecode(response.body);
        List<int> favoriteIds =
            favoriteList.map((item) => item['IdFilme'] as int).toList();

        // Busca detalhes de cada filme usando seus IDs
        List<MovieModel> favoriteMovies = [];
        for (int id in favoriteIds) {
          final movieResponse = await http.get(Uri.parse(
              'https://api.themoviedb.org/3/movie/$id?api_key=${Constants.apiKey}'));
          if (movieResponse.statusCode == 200) {
            favoriteMovies
                .add(MovieModel.fromJson(jsonDecode(movieResponse.body)));
          } else {
            print(
                'Erro ao buscar detalhes do filme $id: ${movieResponse.body}');
          }
        }
        return favoriteMovies;
      } else {
        throw Exception('Erro ao buscar IDs de filmes favoritos');
      }
    } catch (e) {
      print('Erro geral: $e');
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

  final String baseUrl = "http://192.168.0.111:3000";

  Future<List<dynamic>> fetchDados() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usuarios'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Falha ao carregar dados");
      }
    } catch (e) {
      throw Exception("Erro de conexão: $e");
    }
  }

  Future<http.Response> login(String email, String senha) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senha}),
    );

    return response;
  }

  Future<http.Response> registerUser(Map<String, String> userData) async {
    final url = Uri.parse("$baseUrl/usuarios");

    // Codificando os dados para JSON
    final body = jsonEncode(userData);

    // Enviando a requisição POST com o cabeçalho de Content-Type: application/json
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response;
  }

  // Função para recuperação de senha
  Future<http.Response> recoverPassword(String email) async {
    final url = Uri.parse('$baseUrl/recuperacao-senha');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return response; // Sucesso, código de recuperação enviado.
    } else {
      throw Exception(
          "Erro ao solicitar recuperação de senha: ${response.body}");
    }
  }

// Função para validar codigo
  Future<http.Response> validarCodigo(String email, String resetCode) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/validar-codigo'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'resetCode': resetCode,
      }),
    );
    return response;
  }

// Função para redefinir a senha
  Future<http.Response> redefinirSenha(String email, String novaSenha) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/redefinir-senha'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'newPassword': novaSenha, // E passe a nova senha com o nome correto
      }),
    );
    return response;
  }

  // Função para adicionar um filme aos favoritos
  Future<http.Response> addMovieToFavorites(int userId, int movieId) async {
    final url = Uri.parse('$baseUrl/favoritos/adicionar');

    // Corpo da requisição com o ID do filme
    final body = jsonEncode({"idUsuario": userId, "idFilme": movieId});

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    return response;
  }

  // Função para remover um filme dos favoritos
  Future<http.Response> removeMovieFromFavorites(
      int userId, int movieId) async {
    final url = Uri.parse('$baseUrl/favoritos/remover');

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
        '$baseUrl/favoritos/validation?userId=$userId&movieId=$movieId');
    final response = await http.get(url);

    return response;
  }
}
