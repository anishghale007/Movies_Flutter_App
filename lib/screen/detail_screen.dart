import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/model/movie.dart';
import 'package:flutter_movies/provider/video_provider.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;
  DetailScreen(this.movie);

  @override
  Widget build(BuildContext context) {
    final videoProvider =
        FutureProvider((ref) => VideoProvider.getKey(movie.id));
    return Scaffold(
      body: SafeArea(
        child: OfflineBuilder(
            builder: (context) => Text('asasd'),
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              if (connectivity == ConnectivityResult.none) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_outlined,
                        size: 150,
                      ),
                      Text(
                        'No Internet Connection',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                );
              }
              return Consumer(builder: (context, ref, child) {
                final videoData = ref.watch(videoProvider);
                return ListView(
                  children: [
                    videoData.when(
                      data: (data) {
                        return YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: data,
                            flags: YoutubePlayerFlags(
                              autoPlay: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        );
                      },
                      error: (err, stack) => Text('$err'),
                      loading: () => Container(),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 90),
                      height: 300,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          'http://image.tmdb.org/t/p/w600_and_h900_bestv2/${movie.poster_path}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                movie.release_date,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            movie.overview,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 1, fontFamily: 'Bebas'),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Ratings: ${movie.vote_average}',
                            style: TextStyle(fontFamily: 'Bebas'),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              });
            }),
      ),
    );
  }
}
