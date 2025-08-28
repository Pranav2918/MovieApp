import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repository/app_repository.dart';
import '../now_playing/movie_states.dart';


class GenreCubit extends Cubit<GenreState> {
  final AppRepository repository;
  GenreCubit(this.repository) : super(GenreInitial());

  Future<void> fetchGenres() async {
    try {
      emit(GenreLoading());
      final genreResponse = await repository.fetchGenres();
      print("Genre Response: $genreResponse");
      emit(GenreLoaded(genreResponse));
    } catch (e) {
      emit(GenreError(e.toString()));
    }
  }
}
