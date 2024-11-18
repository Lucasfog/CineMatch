class MovieModel {
  int id;
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;

  MovieModel({
    required this.id,
    required this.title,
    required this.backDropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  // Método de fábrica para criar o objeto a partir de um Map JSON
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json["id"],
      title: json["title"],
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDate: json["release_date"],
      voteAverage: json["vote_average"].toDouble(),
    );
  }

  // Método para converter o objeto para Map JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "overview": overview,
      };
}
