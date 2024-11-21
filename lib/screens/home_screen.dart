import 'dart:convert';

import 'package:cine_match/api/api.dart';
import 'package:cine_match/models/movie_model.dart';
import 'package:cine_match/widgets/movies_slider.dart';
import 'package:cine_match/widgets/trending_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

late Future<List<MovieModel>> trendingMovies;
late Future<List<MovieModel>> topRatedMovies;
late Future<List<MovieModel>> upcomingMovies;
late Future<List<MovieModel>> favoriteMovies;

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
    trendingMovies = Api().getTrendingMovies();
    topRatedMovies = Api().getTopRatedMovies();
    upcomingMovies = Api().getUpcomingMovies();
    favoriteMovies = Api().getFavoriteMovies(userId);
  }

  void reloadFavorite() {
    setState(() {
      favoriteMovies = Api().getFavoriteMovies(userId);
    });
  }

  var userId = 0;

  // Carrega os dados do usuário do SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('usuarioLogado');

    if (userData != null) {
      final userMap = json.decode(userData);
      setState(() {
        userId = userMap['id'] ?? 0;
      });
    }

    favoriteMovies = Api().getFavoriteMovies(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filmes em Alta',
                style: GoogleFonts.aBeeZee(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                child: FutureBuilder(
                  future: trendingMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return TrendingSlider(
                        onReloadFavorite: reloadFavorite,
                        snapshot: snapshot,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Filmes Bem Avaliados',
                style: GoogleFonts.aBeeZee(fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: FutureBuilder(
                  future: topRatedMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return MoviesSlider(
                        onReloadFavorite: reloadFavorite,
                        snapshot: snapshot,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Em breve',
                style: GoogleFonts.aBeeZee(fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: FutureBuilder(
                  future: upcomingMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return MoviesSlider(
                        onReloadFavorite: reloadFavorite,
                        snapshot: snapshot,
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Favoritos',
                style: GoogleFonts.aBeeZee(fontSize: 25),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                child: FutureBuilder(
                  future: favoriteMovies,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      // Verifica se a lista de favoritos está vazia
                      final List<MovieModel> movies = snapshot.data!;
                      if (movies.isEmpty) {
                        return Center(
                          child: Text(
                            'Sem favoritos',
                            style: GoogleFonts.aBeeZee(
                                fontSize: 20, color: Colors.grey),
                          ),
                        );
                      } else {
                        return MoviesSlider(
                          onReloadFavorite: reloadFavorite,
                          snapshot: snapshot,
                        );
                      }
                    } else {
                      return const Center(
                        child: Text('Erro inesperado ao carregar favoritos'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
