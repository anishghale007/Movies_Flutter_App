import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class VideoProvider {

  static Future<String> getKey(int movieId) async{
    final api = '245ffda9464a4090aeefdb1533be6de9';
    final dio = Dio();
    try{
        final response = await dio.get('https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$api&language=en-US');
        return response.data['results'][0]['key'];
    } on DioError catch (err) {
      print(err);
        return '';
    }
  }

}