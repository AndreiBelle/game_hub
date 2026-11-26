class GameModel {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;
  final String releaseDate;

  GameModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
    required this.releaseDate
});

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      genre: json['genre'] ?? '',
      platform: json['platform'] ?? '',
      releaseDate: json['release_date'] ?? '',
    );
  }
}
