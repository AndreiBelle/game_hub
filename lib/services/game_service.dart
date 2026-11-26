import 'package:get/get.dart';
import '../models/game_detail_model.dart';
import '../models/game_model.dart';

class GameService extends GetConnect {
  final String baseUrl = 'https://www.freetogame.com/api';

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 15);
    super.onInit();
  }

  Future<List<GameModel>> getGames({
    String? platform,
    String? category,
    String? sortBy,
  }) async {
    try {
      final Map<String, String> queryParameters = {};

      if (platform != null && platform.isNotEmpty && platform != 'all') {
        queryParameters['platform'] = platform;
      }

      if (category != null && category.isNotEmpty && category != 'all') {
        queryParameters['category'] = category;
      }

      if (sortBy != null && sortBy.isNotEmpty) {
        queryParameters['sort-by'] = sortBy;
      }

      final Response<dynamic> response = await get(
        '/games',
        query: queryParameters.isEmpty ? null : queryParameters,
      );

      if (response.status.hasError || response.statusCode != 200) {
        throw Exception('Erro na requisição: status ${response.statusCode}');
      }

      final dynamic body = response.body;
      if (body is! List) {
        throw Exception('Formato de resposta inválido');
      }

      final List<GameModel> games = [];
      for (final dynamic item in body) {
        if (item is Map<String, dynamic>) {
          games.add(GameModel.fromJson(item));
        } else if (item is Map) {
          games.add(GameModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      return games;
    } catch (error) {
      throw Exception('Falha ao carregar jogos: $error');
    }
  }

  Future<GameDetailModel> getGameById(int id) async {
    try {
      final Response<dynamic> response = await get(
        '/game',
        query: {'id': id.toString()},
      );

      if (response.status.hasError || response.statusCode != 200) {
        throw Exception('Erro na requisição: status ${response.statusCode}');
      }

      final dynamic body = response.body;
      if (body is Map<String, dynamic>) {
        return GameDetailModel.fromJson(body);
      }
      if (body is Map) {
        return GameDetailModel.fromJson(Map<String, dynamic>.from(body));
      }

      throw Exception('Formato de resposta inválido');
    } catch (error) {
      throw Exception('Falha ao carregar detalhes do jogo: $error');
    }
  }
}