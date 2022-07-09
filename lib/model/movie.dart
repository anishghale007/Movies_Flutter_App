class Movie {
  late int id;
  late String title;
  late String overview;
  late String poster_path;
  late String release_date;
  late String vote_average;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.poster_path,
    required this.release_date,
    required this.vote_average,
  });

  Movie.initState()
      : id = 0,
        overview = '',
        poster_path = '',
        release_date = '',
        title = 'not available',
        vote_average = '';

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      poster_path: json['poster_path'] ?? '',
      release_date: json['release_date'] ?? '',
      vote_average: '${json['vote_average']}',
    );
  }
}
