import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practical/app/presentation/home_screen/widgets/category_dropdown.dart';
import 'package:practical/app/shared/extensions/movie_category_extension.dart';
import 'package:practical/app/presentation/home_screen/widgets/movies_grid.dart';
import 'package:practical/app/shared/extensions/extensions.dart';
import 'package:practical/app/shared/theme/sizer.dart';

import '../../data/models/genre_model.dart';
import 'cubits/genre/genre_cubit.dart';
import 'cubits/movies/movie_cubit.dart';
import 'cubits/movies/movie_states.dart';

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
  Genre? _selectedGenre;

  MovieCategory _selectedCategory = MovieCategory.nowPlaying;

  @override
  void initState() {
    final movieCubit = context.read<MovieCubit>();
    movieCubit.fetchMovies(_selectedCategory, _currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (movieCubit.state is MovieLoaded && !movieCubit.isFetching) {
          _currentPage++;
          movieCubit.fetchMovies(_selectedCategory, _currentPage, append: true);
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
              // Title + View Toggle + Category Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedCategory.label,
                    style: GoogleFonts.bebasNeue(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      CategoryDropdown(
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            _selectedCategory = category;
                            _currentPage = 1;
                          });
                          context
                              .read<MovieCubit>()
                              .fetchMovies(category, _currentPage);
                        },
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
                ],
              ),
              10.h,
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
              20.h,
              // Genre filter row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: Sizer.hPercent(5),
                    width: Sizer.wPercent(40),
                    child: GenreDropdown(
                      onGenreSelected: (genre) {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // Movies with Pagination
              Expanded(
                child: BlocBuilder<MovieCubit, MovieState>(
                  builder: (context, state) {
                    if (state is MovieLoading && _currentPage == 1) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MovieLoaded) {
                      final allMovies = state.movieResponse.results;

                      // Search filter
                      var movies = _searchQuery.isEmpty
                          ? allMovies
                          : allMovies
                          .where((m) =>
                          (m.title ?? "")
                              .toLowerCase()
                              .contains(_searchQuery))
                          .toList();

                      // Genre filter
                      if (_selectedGenre != null) {
                        movies = movies
                            .where(
                              (m) =>
                          m.genreIds.contains(_selectedGenre!.id) ??
                              false,
                        )
                            .toList();
                      }

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
                        isLoadingMore:
                        context.read<MovieCubit>().isFetching,
                      )
                          : ShowNowPlayingList(
                        movies: movies,
                        scrollController: _scrollController,
                        isLoadingMore:
                        context.read<MovieCubit>().isFetching,
                      );
                    } else if (state is MovieError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Error: ${state.message}",
                              style: const TextStyle(color: Colors.red),
                            ),
                            10.h,
                            ElevatedButton(
                              onPressed: () {
                                _currentPage = 1;
                                context
                                    .read<MovieCubit>()
                                    .fetchMovies(_selectedCategory, _currentPage);
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
                    return 0.h;
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

class GenreDropdown extends StatefulWidget {
  final ValueChanged<Genre?> onGenreSelected;

  const GenreDropdown({super.key, required this.onGenreSelected});

  @override
  State<GenreDropdown> createState() => _GenreDropdownState();
}

class _GenreDropdownState extends State<GenreDropdown> {
  Genre? selectedGenre;

  @override
  void initState() {
    super.initState();
    context.read<GenreCubit>().fetchGenres();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreCubit, GenreState>(
      builder: (context, state) {
        if (state is GenreLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GenreLoaded) {
          return DropdownButton<Genre>(
            iconEnabledColor: Colors.deepOrange,
            dropdownColor: const Color(0xFF071e26),
            value: selectedGenre,
            hint: Text(
              "Select Genre",
              style: GoogleFonts.bebasNeue(fontSize: 18, color: Colors.grey),
            ),
            isExpanded: true,
            items: state.genreResponse.genres
                .map(
                  (genre) => DropdownMenuItem(
                    value: genre,
                    child: Text(
                      genre.name,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 18,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (Genre? value) {
              setState(() {
                selectedGenre = value;
              });
              widget.onGenreSelected(
                value,
              ); // <-- this sends selected genre to HomeScreen
            },
          );
        } else if (state is GenreError) {
          return GestureDetector(
            onTap: () {
              context.read<GenreCubit>().fetchGenres();
            },
            child: Text("Error: ${state.message}"),
          );
        }
        return 0.h;
      },
    );
  }
}