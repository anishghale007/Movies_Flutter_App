import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/api.dart';
import 'package:flutter_movies/provider/movie_provider.dart';
import 'package:flutter_movies/widgets/popular_page.dart';
import 'package:flutter_movies/widgets/tab_bar_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 170,
          flexibleSpace: Image.asset('assets/images/background.jpg', fit: BoxFit.cover,),
          bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50),
            child: Consumer(
              builder: (context,ref,child) {
              return TabBar(
                onTap: (index) {
                  print(index);
                  ref.read(stateMovieProvider.notifier).updateCategory(index);
                },
                indicatorColor: Colors.purple,
                tabs: [
                  Tab(
                    icon: Icon(Icons.cast),
                    text: 'Popular Movies',
                  ),
                  Tab(
                    icon: Icon(CupertinoIcons.wand_rays),
                    text: 'Top Rated Movies',
                  ),
                  Tab(
                    icon: Icon(Icons.wysiwyg),
                    text: 'Upcoming Movies',
                  ),
                ],
              );
            }
           ),
          ),
        ),
        body: Column(
          children: [
            Consumer(
                builder: (context, ref, child) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                    child: TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (val) {
                        ref.read(stateMovieProvider.notifier).searchMovies(val);
                        searchController.clear();
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText: 'Search for movies',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                }
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  PopularPage('page 1'),
                  TabBarWidget(Api.getTopRated, 'page 2'),
                  TabBarWidget(Api.getUpcoming, 'page 3'),
                ],
              ),
            ),
          ],
        ),
    ),
    );
  }
}
