import 'package:cine_match/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoteAverage extends StatelessWidget {
  const VoteAverage({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Avaliação: ',
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          Text(
            '${movie.voteAverage.toStringAsFixed(1)}/10',
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
