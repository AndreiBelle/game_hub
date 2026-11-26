class SystemRequirementsModel {
  final String os;
  final String processor;
  final String memory;
  final String graphics;
  final String storage;

  SystemRequirementsModel({
    required this.os,
    required this.processor,
    required this.memory,
    required this.graphics,
    required this.storage,
  });

  factory SystemRequirementsModel.fromJson(Map<String, dynamic> json) {
    return SystemRequirementsModel(
      os: json['os'] ?? 'Não informado',
      processor: json['processor'] ?? 'Não informado',
      memory: json['memory'] ?? 'Não informado',
      graphics: json['graphics'] ?? 'Não informado',
      storage: json['storage'] ?? 'Não informado',
    );
  }
}

class GameDetailModel {
  final int id;
  final String title;
  final String thumbnail;
  final String description;
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;
  final SystemRequirementsModel? minimumSystemRequirements;

  GameDetailModel({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
    this.minimumSystemRequirements,
  });

  factory GameDetailModel.fromJson(Map<String, dynamic> json) {
    return GameDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      description: json['description'] ?? '',
      gameUrl: json['game_url'] ?? '',
      genre: json['genre'] ?? '',
      platform: json['platform'] ?? '',
      publisher: json['publisher'] ?? '',
      developer: json['developer'] ?? '',
      releaseDate: json['release_date'] ?? '',
      minimumSystemRequirements: json['minimum_system_requirements'] != null
          ? SystemRequirementsModel.fromJson(
        json['minimum_system_requirements'],
      )
          : null,
    );
  }
}