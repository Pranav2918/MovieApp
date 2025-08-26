import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/now_playing_model.dart';
import '../../../../domain/repository/app_repository.dart';
import 'movie_states.dart';

class MovieCubit extends Cubit<MovieState> {
  final AppRepository repository;
  bool isFetching = false;

  MovieCubit(this.repository) : super(MovieInitial());

  Future<void> fetchNowPlayingMovies(int page, {bool append = false}) async {
    if (isFetching) return;
    isFetching = true;

    try {
      if (!append) emit(MovieLoading());

      final moviesResponse = await repository.fetchNowPlayingMovies(page);

      if (append && state is MovieLoaded) {
        final current = (state as MovieLoaded).movieResponse;
        final combined = MovieResponse(
          dates: moviesResponse.dates,
          page: moviesResponse.page,
          results: [...current.results, ...moviesResponse.results],
          totalPages: moviesResponse.totalPages,
          totalResults: moviesResponse.totalResults,
        );
        emit(MovieLoaded(combined));
      } else {
        emit(MovieLoaded(moviesResponse));
      }
    } catch (e) {
      emit(MovieError(e.toString()));
    } finally {
      isFetching = false;
    }
  }
}

