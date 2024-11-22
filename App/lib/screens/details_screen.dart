import 'dart:convert';

import 'package:cine_match/api/api.dart';
import 'package:cine_match/constants.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:cine_match/widgets/overview.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatefulWidget {
  final VoidCallback onReloadFavorite;

  const DetailsScreen({
    super.key,
    required this.movie,
    required this.onReloadFavorite,
  });
  final MovieModel movie;

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isFavorite = false;
  final Api _apiService = Api();

  var userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuarioLogado');

    if (userData != null) {
      final userMap = json.decode(userData);
      setState(() {
        userId = userMap['id'] ?? 0;
      });

      _checkIfFavorite();
    }
  }

  Future<void> _checkIfFavorite() async {
    final response = await _apiService.isMovieFavorite(userId, widget.movie.id);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {
        _isFavorite = responseData['isFavorite'] ?? false;
      });
    } else {
      setState(() {
        _isFavorite = false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      if (_isFavorite) {
        await _apiService.removeMovieFromFavorites(userId, widget.movie.id);
        widget.onReloadFavorite();
      } else {
        await _apiService.addMovieToFavorites(userId, widget.movie.id);
        widget.onReloadFavorite();
      }

      setState(() {
        _isFavorite = !_isFavorite;
      });

      Fluttertoast.showToast(
        msg: _isFavorite
            ? "Filme adicionado aos favoritos!"
            : "Filme removido dos favoritos!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Erro ao atualizar favorito: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: const BackButton(),
            backgroundColor: DefaultColor.scaffoldBgColor,
            expandedHeight: 500,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    widget.movie.title,
                    style: GoogleFonts.belleza(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24)),
                child: Image.network(
                  '${Constants.imagePath}${widget.movie.backDropPath}',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Overview(movie: widget.movie),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleFavorite,
        backgroundColor: _isFavorite ? Colors.red : Colors.grey,
        child: Icon(
          _isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.white,
        ),
      ),
    );
  }
}
