import '../../data/models/now_playing_model.dart';
import '../../shared/constants/app_constants.dart';
import '../dio_helper/dio_helper.dart';

class AppRepository {
  static final DioHelper _dioHelper = DioHelper();

  Future<MovieResponse> fetchNowPlayingMovies(int page) async {
    var response = await _dioHelper.get(
        url: nowPlayingUrl,
        isAuthRequired: true,
        queryParams: {'language': "en-US", 'page': page});

    return MovieResponse.fromJson(response);
  }
}