import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practical/app/data/models/now_playing_model.dart';
import 'package:practical/app/presentation/home_screen/widgets/movie_card.dart';
import 'package:practical/app/shared/extensions/extensions.dart';

import 'cubits/now_playing/movie_cubit.dart';
import 'cubits/now_playing/movie_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    final movieCubit = context.read<MovieCubit>();
    movieCubit.fetchNowPlayingMovies(_currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (movieCubit.state is MovieLoaded && !movieCubit.isFetching) {
          _currentPage++;
          movieCubit.fetchNowPlayingMovies(_currentPage, append: true);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF040f13), Color(0xFF071e26)],
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Now Playing",
                style: GoogleFonts.bebasNeue(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Movies Grid with Pagination
              Expanded(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading && _currentPage == 1) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MovieLoaded) {
                      return _ShowNowPlayingGrid(
                        movies: state.movieResponse.results,
                        scrollController: _scrollController,
                        isLoadingMore: context.read<MovieCubit>().isFetching,
                      );
                    } else if (state is MovieError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Error: ${state.message}",
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _currentPage = 1;
                                context
                                    .read<MovieCubit>()
                                    .fetchNowPlayingMovies(_currentPage);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                              ),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ).padSymmetric(h: 16, v: 40),
        ],
      ),
    );
  }
}

class _ShowNowPlayingGrid extends StatelessWidget {
  final List<Movie> movies;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const _ShowNowPlayingGrid({
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
          // Show loader at bottom while fetching more
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


