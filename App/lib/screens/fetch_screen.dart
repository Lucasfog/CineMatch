import 'package:cine_match/api/api.dart';
import 'package:cine_match/constants.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:cine_match/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class FetchScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onMovieAdded;
  final VoidCallback onReloadFavorite;

  const FetchScreen({
    super.key,
    required this.onMovieAdded,
    required this.onReloadFavorite,
  });

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;
  final Api _api = Api();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _fetchMovies(String query) async {
    final movies = await _api.fetchMovies(query);
    return List<Map<String, dynamic>>.from(movies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                focusNode: _focusNode,
                cursorColor: DefaultColor.primaryColor,
                decoration: InputDecoration(
                  labelText: 'Buscar filmes',
                  labelStyle: TextStyle(
                    color: _isFocused ? DefaultColor.primaryColor : Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: DefaultColor.primaryColor, width: 2.0),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) async {
                return await _fetchMovies(pattern);
              },
              itemBuilder: (context, suggestion) {
                final movie = suggestion;
                return ListTile(
                  leading: movie['poster_path'] != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                        )
                      : const SizedBox(
                          width: 50, height: 50, child: Icon(Icons.movie)),
                  title: Text(movie['title']),
                  subtitle:
                      Text('Data de lançamento: ${movie['release_date']}'),
                );
              },
              onSuggestionSelected: (suggestion) {
                final movie = MovieModel(
                  id: suggestion['id'],
                  title: suggestion['title'] ?? '',
                  originalTitle: suggestion['original_title'] ?? '',
                  backDropPath: suggestion['backdrop_path'] ?? '',
                  posterPath: suggestion['poster_path'] ?? '',
                  overview: suggestion['overview'] ?? '',
                  releaseDate: suggestion['release_date'] ?? '',
                  voteAverage: (suggestion['vote_average'] ?? 0).toDouble(),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      movie: movie,
                      onReloadFavorite: () {},
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
