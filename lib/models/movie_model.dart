class MovieModel {
  String title;
  String backDropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;

  MovieModel(
      {required this.title,
      required this.backDropPath,
      required this.originalTitle,
      required this.overview,
      required this.posterPath,
      required this.releaseDate,
      required this.voteAverage});

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      title: json["title"],
      backDropPath: json["backdrop_path"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      posterPath: json["poster_path"],
      releaseDate: json["release_date"],
      voteAverage: json["vote_average"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "overview": overview,
      };
}

// "backdrop_path": "/p5kpFS0P3lIwzwzHBOULQovNWyj.jpg",
//       "id": 1032823,
//       "title": "Armadilha",
//       "original_title": "Trap",
//       "overview": "Um pai e sua filha adolescente assistem a um badalado show de música pop, quando percebem que estão no epicentro de um evento sombrio e sinistro.",
//       "poster_path": "/ArVwz2CXHiY2SuCRYRsfRlG2Fac.jpg",
//       "media_type": "movie",
//       "adult": false,
//       "original_language": "en",
//       "genre_ids": [53],
//       "popularity": 398.238,
//       "release_date": "2024-07-31",
//       "video": false,
//       "vote_average": 6.438,
//       "vote_count": 579