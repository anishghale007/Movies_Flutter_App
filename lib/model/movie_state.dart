import 'package:flutter_movies/api.dart';
import 'package:flutter_movies/model/movie.dart';

class MovieState {
  late String apiPath;
  late String searchText;
  late List<Movie> movies;
  late int page;

  MovieState(
      {required this.apiPath,
      required this.searchText,
      required this.movies,
      required this.page});

  // Default value
  MovieState.initState()
      : searchText = '',
        page = 1,
        movies = [],
        apiPath = Api.getPopular;

  MovieState copyWith(
      {String? apiPath, String? searchText, List<Movie>? movies, int? page}) {
    return MovieState(
      apiPath: apiPath ?? this.apiPath,
      searchText: searchText ?? this.searchText,
      movies: movies ?? this.movies,
      page: page ?? this.page,
    );
  }
}
