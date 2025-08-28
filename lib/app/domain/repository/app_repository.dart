import '../../data/models/genre_model.dart';
import '../../data/models/now_playing_model.dart';
import '../../shared/constants/app_constants.dart';
import '../dio_helper/dio_helper.dart';

class AppRepository {
  static final DioHelper _dioHelper = DioHelper();

  Future<MovieResponse> fetchNowPlayingMovies(int page) async {
    var response = await _dioHelper.get(
      url: nowPlayingUrl,
      isAuthRequired: true,
      queryParams: {'language': "en-US", 'page': page},
    );

    return MovieResponse.fromJson(response);
  }

  Future<MovieResponse> fetchPopularMovies(int page) async {
    var response = await _dioHelper.get(
      url: popularMoviesUrl,
      isAuthRequired: true,
      queryParams: {'language': "en-US", 'page': page},
    );
    return MovieResponse.fromJson(response);
  }

  Future<MovieResponse> fetchTopRatedMovies(int page) async {
    var response = await _dioHelper.get(
      url: topRatedUrl,
      isAuthRequired: true,
      queryParams: {'language': "en-US", 'page': page},
    );
    return MovieResponse.fromJson(response);
  }

  Future<MovieResponse> fetchUpcomingMovies(int page) async {
    var response = await _dioHelper.get(
      url: upcomingUrl,
      isAuthRequired: true,
      queryParams: {'language': "en-US", 'page': page},
    );
    return MovieResponse.fromJson(response);
  }

  Future<GenreResponse> fetchGenres() async {
    var response = await _dioHelper.get(
      url: genreListUrl,
      isAuthRequired: true,
      queryParams: {'language': "en"},
    );
    return GenreResponse.fromJson(response);
  }
}