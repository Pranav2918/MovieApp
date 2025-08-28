import 'dart:convert';

class GenreResponse {
  final List<Genre> genres;

  GenreResponse({required this.genres});

  factory GenreResponse.fromJson(Map<String, dynamic> json) {
    return GenreResponse(
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'genres': genres.map((e) => e.toJson()).toList(),
    };
  }

  /// Utility to parse JSON string directly
  factory GenreResponse.fromRawJson(String str) =>
      GenreResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Genre.fromRawJson(String str) => Genre.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
