import 'package:dio/dio.dart';
import 'package:flutter_movies/model/movie.dart';
import 'package:flutter_movies/model/movie_state.dart';
import 'package:flutter_movies/service/movie_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';


// final movieProvider = StateNotifierProvider.family<MovieProvider, List<Movie>, String>((ref, path) => MovieProvider(apiPath: path));

// class MovieProvider extends StateNotifier<List<Movie>>{
//   MovieProvider({required this.apiPath}) : super([]){
//     getMovies();
//   }

// final String apiPath;

// Future<void> getMovies() async {
//   final dio = Dio();
//   try{
//     final response = await dio.get(apiPath, queryParameters: {
//       'api_key' : '245ffda9464a4090aeefdb1533be6de9',
//       'language' : 'en-US',
//     });
//     state = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
//   } on DioError catch(err) {
//     print(err);
//   }
//
// }
//
//
// Future<void> searchMovies() async {
//   final dio = Dio();
//   try{
//     final response = await dio.get(apiPath, queryParameters: {
//       'api_key' : '245ffda9464a4090aeefdb1533be6de9',
//       'language' : 'en-US',
//     });
//     state = (response.data['results'] as List).map((e) => Movie.fromJson(e)).toList();
//   } on DioError catch(err) {
//     print(err);
//   }
//
// }

final stateMovieProvider = StateNotifierProvider<MovieProvider, MovieState >((ref) => MovieProvider());

  class MovieProvider extends StateNotifier<MovieState>{
    MovieProvider() : super(MovieState.initState()){
    getMovies();
}


    Future<void> getMovies() async {
      List<Movie> _movies = [];
      if(state.searchText == ''){
        if(state.apiPath == Api.getPopular) {
          _movies = await MovieService.getMovies(state.apiPath, state.page);
        } else if (state.apiPath == Api.getTopRated) {
          _movies = await MovieService.getMovies(state.apiPath, state.page);
        } else {
          _movies = await MovieService.getMovies(state.apiPath, state.page);
        }

      } else {
          _movies = await MovieService.searchMovies(state.apiPath, state.page, state.searchText);
      }
      state = state.copyWith(
       movies:  [...state.movies, ..._movies],
      );
    }

    // update category
    void updateCategory (int index) {
      switch(index) {
        case 0:
          state = state.copyWith(
            movies: [],
            apiPath: Api.getPopular,
            searchText: '',
          );
          getMovies();
          break;
        case 1:
          state = state.copyWith(
            movies: [],
            apiPath: Api.getTopRated,
            searchText: '',
          );
          getMovies();
          break;
        default:
          state = state.copyWith(
            movies: [],
            apiPath: Api.getUpcoming,
            searchText: '',
          );
          getMovies();
      }
    }


  // search movies
  void searchMovies(String searchText) {
      state = state.copyWith(
        searchText: searchText,
        apiPath: Api.getSearchMovie,
        movies: [],
      );

      getMovies();
  }

  //load more
  void loadMore () {
      state =state.copyWith(
        searchText: '',
        page: state.page + 1,
      );
      getMovies();
  }

}