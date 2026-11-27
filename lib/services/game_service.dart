import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/game_detail_model.dart';
import '../models/game_model.dart';

class GameService extends GetxService {
  final String baseUrl = 'https://www.freetogame.com/api';

  Future<List<GameModel>> getGames({
    String? platform,
    String? category,
    String? sortBy,
  }) async {
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

    final Uri uri = Uri.parse('$baseUrl/games').replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => GameModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    throw Exception('Erro ao buscar jogos');
  }

  Future<GameDetailModel> getGameById(int id) async {
    final Uri uri = Uri.parse('$baseUrl/game').replace(
      queryParameters: {'id': id.toString()},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      Map<String, dynamic>.from(jsonDecode(response.body));
      return GameDetailModel.fromJson(data);
    }

    throw Exception('Erro ao buscar detalhes do jogo');
  }
}