import 'package:equatable/equatable.dart';
import '../../../../data/models/genre_model.dart';
import '../../../../data/models/now_playing_model.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final MovieResponse movieResponse;

  const MovieLoaded(this.movieResponse);

  @override
  List<Object?> get props => [movieResponse];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}

/// -------------------------
/// Genre States
/// -------------------------
abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final GenreResponse genreResponse;

  const GenreLoaded(this.genreResponse);

  @override
  List<Object?> get props => [genreResponse];
}

class GenreError extends GenreState {
  final String message;

  const GenreError(this.message);

  @override
  List<Object?> get props => [message];
}