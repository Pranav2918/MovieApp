import 'package:flutter/material.dart';

import '../../../data/models/now_playing_model.dart';
import '../../details_screen/movie_details_screen.dart';
import 'movie_card.dart';

class ShowNowPlayingGrid extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const ShowNowPlayingGrid({super.key,
    required this.movies,
    required this.scrollController,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      itemCount: isLoadingMore ? movies.length + 1 : movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        mainAxisExtent: MediaQuery.of(context).size.height * 0.30,
      ),
      itemBuilder: (context, index) {
        if (index < movies.length) {
          return Hero(
              tag: "poster_${movies[index].id}",
              child: MovieCard(movie: movies[index]));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ShowNowPlayingList extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const ShowNowPlayingList({
    super.key,
    required this.movies,
    required this.scrollController,
    required this.isLoadingMore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: isLoadingMore ? movies.length + 1 : movies.length,
      itemBuilder: (context, index) {
        if (index < movies.length) {
          final movie = movies[index];
          return ListTile(
            leading: Hero(
              tag: "poster_${movie.id}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "https://image.tmdb.org/t/p/w200${movie.posterPath}",
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Text(
              movie.title,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              movie.overview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movie: movie),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
