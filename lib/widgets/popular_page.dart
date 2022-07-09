import 'package:flutter/material.dart';
import 'package:flutter_movies/provider/movie_provider.dart';
import 'package:flutter_movies/screen/detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';


class PopularPage extends StatelessWidget {

  final String page;
  PopularPage(this.page);

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
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
                  Icon(Icons.wifi_off_outlined, size: 150,),
                  Text('No Internet Connection', style: TextStyle(fontSize: 15),),
                ],
              ),
            );
          } else {
            return Consumer(
              builder: (context, ref, child) {
                final stateMovies = ref.watch(stateMovieProvider);
                // final movies = ref.watch(movieProvider(apiPath));
                return stateMovies.movies.isEmpty ? Center(
                  child: CircularProgressIndicator(color: Colors.purple,),)
                    : stateMovies.movies[0].title == 'not available' ? Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No matches for your search'),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.refresh(stateMovieProvider);
                          }, child: Text('Refresh'),
                        ),
                      ),
                    ],
                  ),
                ) : Padding(
                  padding: EdgeInsets.only(top: 15, right: 10, left: 10),
                  child: NotificationListener(
                    onNotification: (onNotification) {
                      if (onNotification is ScrollEndNotification) {
                        final before = onNotification.metrics.extentBefore;
                        final max = onNotification.metrics.maxScrollExtent;
                        if (before == max) {
                          ref.read(stateMovieProvider.notifier).loadMore();
                        }
                      }
                      return true;
                    },
                    child: GridView.builder(
                        key: PageStorageKey(page),
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: stateMovies.movies.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 2 / 3,
                        ),
                        itemBuilder: (context, index) {
                          final movie = stateMovies.movies[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => DetailScreen(movie), transition: Transition.leftToRight);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: movie.poster_path == ''
                                  ? Image.asset('assets/images/no-image.png')
                                  : CachedNetworkImage(
                                imageUrl: 'http://image.tmdb.org/t/p/w600_and_h900_bestv2/${movie.poster_path}',
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                );
              },
              child: Container(

              ),
            );
          }
        }
    );
  }
}
