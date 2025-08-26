import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practical/app/shared/extensions/extensions.dart';

import '../../../data/models/now_playing_model.dart';
import '../../../shared/theme/sizer.dart';
import '../../details_screen/movie_details_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
        );
      },
      child: Stack(
        children: [
          Container(
            height: Sizer.hPercent(30),
            width: Sizer.wPercent(45),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                ),
                fit: BoxFit.cover,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            height: Sizer.hPercent(30),
            width: Sizer.wPercent(45),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.50, 1.0],
                colors: [Colors.transparent, Colors.black87],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Positioned(
            top: 8.0,
            right: 10.0,
            child: Icon(Icons.star_border_purple500, color: Colors.deepOrange),
          ),
          Text(
            movie.title ?? '',
            style: GoogleFonts.bebasNeue(fontSize: 18, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).padAll(8).alignBottomRight(),
        ],
      ),
    );
  }
}
