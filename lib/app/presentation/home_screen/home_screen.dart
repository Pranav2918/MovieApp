import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practical/app/presentation/home_screen/widgets/movies_grid.dart';
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
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  bool _isGridView = true;
  String _searchQuery = "";

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

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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
              // Title + Toggle Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Now Playing",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isGridView ? Icons.view_list : Icons.grid_view,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isGridView = !_isGridView;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search movies...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Movies with Pagination
              Expanded(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading && _currentPage == 1) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MovieLoaded) {
                      final allMovies = state.movieResponse.results;

                      final movies = _searchQuery.isEmpty
                          ? allMovies
                          : allMovies.where((m) =>
                          (m.title ?? "")
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase())).toList();

                      if (movies.isEmpty) {
                        return const Center(
                          child: Text(
                            "No movies found",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return _isGridView
                          ? ShowNowPlayingGrid(
                        movies: movies,
                        scrollController: _scrollController,
                        isLoadingMore: context.read<MovieCubit>().isFetching,
                      )
                          : ShowNowPlayingList(
                        movies: movies,
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