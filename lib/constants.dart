class Constants {
  static const apiKey = String.fromEnvironment('API_KEY');
  static const imagePath = 'https://image.tmdb.org/t/p/original';

  String formatDate(String text) {
    List<String> parts = text.split('-');
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
