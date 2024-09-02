class Constants {
  static const apiKey = '74ab60838726f35946d1075bf9e82a09';
  static const imagePath = 'https://image.tmdb.org/t/p/w500';

  String formatDate(String text) {
    List<String> parts = text.split('-');
    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }
}
