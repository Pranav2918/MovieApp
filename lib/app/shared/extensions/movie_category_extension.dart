enum MovieCategory {
  nowPlaying,
  popular,
  topRated,
  upcoming,
}

extension MovieCategoryExtension on MovieCategory {
  String get label {
    switch (this) {
      case MovieCategory.nowPlaying:
        return "Now Playing";
      case MovieCategory.popular:
        return "Popular";
      case MovieCategory.topRated:
        return "Top Rated";
      case MovieCategory.upcoming:
        return "Upcoming";
    }
  }
}
