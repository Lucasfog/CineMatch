import 'package:cine_match/models/movie_model.dart';
import 'package:cine_match/widgets/release_date.dart';
import 'package:cine_match/widgets/vote_average.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Overview extends StatelessWidget {
  const Overview({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Visão Geral',
          style: GoogleFonts.openSans(
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          movie.overview,
          style: GoogleFonts.roboto(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        SizedBox(
          child: Column(
            children: [
              ReleaseDate(movie: movie),
              const SizedBox(
                height: 10,
              ),
              VoteAverage(movie: movie),
            ],
          ),
        )
      ],
    );
  }
}
