import 'dart:convert';

import 'package:flutter_movies/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter_movies/model/movie.dart';

class MovieService {
  // get movies
  static Future<List<Movie>> getMovies(String apiPath, int page) async {
    final prefs = await SharedPreferences.getInstance();
    final dio = Dio();
    try {
      final response = await dio.get(apiPath, queryParameters: {
        'api_key': '245ffda9464a4090aeefdb1533be6de9',
        'page': page
      });
      if (apiPath == Api.getPopular) {
        prefs.setString('movie', jsonEncode(response.data['results']));
      }
      final data = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      return data;
    } on DioError catch (err) {
      if (err.type == DioErrorType.other) {
        if (apiPath == Api.getPopular) {
          final decodedData = jsonDecode(prefs.getString('movie')!);
          final data =
              (decodedData as List).map((e) => Movie.fromJson(e)).toList();
          return data;
        }
        throw err;
      }
      throw err;
    }
  }

  // search movies
  static Future<List<Movie>> searchMovies(
      String apiPath, int page, String query) async {
    final dio = Dio();
    try {
      final response = await dio.get(apiPath, queryParameters: {
        'api_key': '245ffda9464a4090aeefdb1533be6de9',
        'page': page,
        'query': query,
      });
      final movies = (response.data['results'] as List)
          .map((e) => Movie.fromJson(e))
          .toList();
      if (movies.isEmpty) {
        return [Movie.initState()];
      } else {
        return movies;
      }
    } on DioError catch (err) {
      print(err);
      return [];
    }
  }
}
