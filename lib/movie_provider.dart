import 'package:cine_match/api/api.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:flutter/material.dart';

class MovieProvider extends ChangeNotifier {
  late Future<List<MovieModel>> favoriteMovies;
  bool isLoadingFavorites = false; // Indicador de carregamento

  Future<List<MovieModel>> reloadFavorite(String userId) async {
    isLoadingFavorites = true; // Inicia o estado de carregamento
    notifyListeners(); // Notifica widgets dependentes

    try {
      favoriteMovies = Api().getFavoriteMovies(userId as int);
      return favoriteMovies;
    } catch (e) {
      print("Erro ao carregar filmes favoritos: $e");
      return [];
    } finally {
      isLoadingFavorites = false; // Finaliza o estado de carregamento
      notifyListeners(); // Atualiza os widgets dependentes
    }
  }
}
