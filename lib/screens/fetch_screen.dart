import 'package:cine_match/api/api.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:cine_match/screens/details_screen.dart'; // Certifique-se de ajustar o caminho
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
  Map<String, dynamic>? _selectedMovie;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _isFocused = false;
  final Api _api = Api(); // Instancia a classe da API

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

  // Função para buscar os filmes usando a API
  Future<List<Map<String, dynamic>>> _fetchMovies(String query) async {
    final movies = await _api.fetchMovies(query); // Chama o método da sua API
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
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                  labelText: 'Buscar filmes',
                  labelStyle: TextStyle(
                    color: _isFocused ? Colors.blue : Colors.grey,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
                  id: suggestion['id'], // Capturando o id
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
            const SizedBox(height: 20),
            if (_selectedMovie != null) ...[
              _selectedMovie!['backdrop_path'] != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500${_selectedMovie!['backdrop_path']}',
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(
                      height: 200, child: Icon(Icons.movie, size: 100)),
              const SizedBox(height: 20),
              Text(
                _selectedMovie!['title'],
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Nota: ${_selectedMovie!['vote_average']} / 10',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                _selectedMovie!['overview'] ?? 'Sem resumo disponível',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedMovie = null;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Voltar'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedMovie != null) {
                        // Chama a função onMovieAdded para passar o filme selecionado
                        widget.onMovieAdded(_selectedMovie!);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${_selectedMovie!['title']} adicionado à lista!'),
                          ),
                        );
                        _controller.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Adicionar à lista'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
