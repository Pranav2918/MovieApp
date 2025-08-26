import 'package:equatable/equatable.dart';
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
