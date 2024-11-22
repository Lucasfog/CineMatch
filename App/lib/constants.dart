import 'package:flutter/material.dart';

class Constants {
  static const apiKey = String.fromEnvironment('API_KEY');
  static const serverUrl = String.fromEnvironment('SERVER_URL');

  static const routeUser = '$serverUrl/users/add';
  static const routeLogin = '$serverUrl/login';
  static const routePasswordRecovery = '$serverUrl/password-recovery';
  static const routeValidateCode = '$serverUrl/validate-code';
  static const routeResetPassword = '$serverUrl/reset-password';
  static const routeAddFavorites = '$serverUrl/favorites/add';
  static const routeRemoveFavorites = '$serverUrl/favorites/remove';
  static const routeFavoriteCheck = '$serverUrl/favorites/check';
  static const routeLoadFavorite = '$serverUrl/favorites/load/';

  static const trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?language=pt-br&api_key=$apiKey';

  static const topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?language=pt-br&page=1&api_key=$apiKey';

  static const upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?language=pt-br&page=1&api_key=$apiKey';

  static const imagePath = 'https://image.tmdb.org/t/p/original';

  String formatDate(String text) {
    List<String> parts = text.split('-');
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}

class DefaultColor {
  static const scaffoldBgColor = Color(0xFF23272E);
  static const ratingColor = Color(0xFFFFC107);
  static const primaryColor = Colors.blue;
}
