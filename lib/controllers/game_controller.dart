import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/game_detail_model.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';

class GameController extends GetxController {
  final GameService gameService = GameService();

  final RxList<GameModel> allGames = <GameModel>[].obs;
  final RxList<GameModel> filteredGames = <GameModel>[].obs;
  final RxList<GameModel> favoriteGames = <GameModel>[].obs;

  final Rx<GameDetailModel?> selectedGameDetail = Rx<GameDetailModel?>(null);

  final RxBool isLoadingGames = false.obs;
  final RxBool isLoadingDetail = false.obs;

  final RxString gamesErrorMessage = ''.obs;
  final RxString detailErrorMessage = ''.obs;

  final RxString selectedPlatform = 'all'.obs;
  final RxString selectedCategory = 'all'.obs;
  final RxString selectedSortBy = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGames();
  }

  Future<void> fetchGames() async {
    isLoadingGames.value = true;
    gamesErrorMessage.value = '';

    try {
      final List<GameModel> result = await gameService.getGames(
        platform: selectedPlatform.value,
        category: selectedCategory.value,
        sortBy: selectedSortBy.value.isEmpty ? null : selectedSortBy.value,
      );

      allGames.assignAll(result);
      applyLocalSearch();
    } catch (error) {
      allGames.clear();
      filteredGames.clear();
      gamesErrorMessage.value =
      'Não foi possível carregar os jogos no momento. Verifique sua conexão e tente novamente.';
    } finally {
      isLoadingGames.value = false;
    }
  }

  Future<void> fetchGameDetail(int id) async {
    isLoadingDetail.value = true;
    detailErrorMessage.value = '';
    selectedGameDetail.value = null;

    try {
      final GameDetailModel detail = await gameService.getGameById(id);
      selectedGameDetail.value = detail;
    } catch (error) {
      detailErrorMessage.value =
      'Não foi possível carregar os detalhes deste jogo. Tente novamente.';
    } finally {
      isLoadingDetail.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyLocalSearch();
  }

  void clearSearch() {
    searchQuery.value = '';
    applyLocalSearch();
  }

  void applyLocalSearch() {
    final String term = searchQuery.value.trim().toLowerCase();

    if (term.isEmpty) {
      filteredGames.assignAll(allGames);
      return;
    }

    final List<GameModel> matches = allGames.where((GameModel game) {
      return game.title.toLowerCase().contains(term);
    }).toList();

    filteredGames.assignAll(matches);
  }

  Future<void> selectPlatform(String platform) async {
    selectedPlatform.value = platform;
    await fetchGames();
  }

  Future<void> selectCategory(String category) async {
    selectedCategory.value = category;
    await fetchGames();
  }

  Future<void> selectSortBy(String sortBy) async {
    selectedSortBy.value = sortBy;
    await fetchGames();
  }

  Future<void> clearFilters() async {
    selectedPlatform.value = 'all';
    selectedCategory.value = 'all';
    selectedSortBy.value = '';
    await fetchGames();
  }

  bool isFavorite(int gameId) {
    return favoriteGames.any((GameModel game) => game.id == gameId);
  }

  void toggleFavoriteFromDetail(GameDetailModel detail) {
    final bool alreadyExists = isFavorite(detail.id);

    if (alreadyExists) {
      favoriteGames.removeWhere((GameModel game) => game.id == detail.id);
      Get.snackbar(
        'Favoritos',
        '${detail.title} foi removido dos favoritos.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      final GameModel gameItem = GameModel(
        id: detail.id,
        title: detail.title,
        thumbnail: detail.thumbnail,
        genre: detail.genre,
        platform: detail.platform,
        releaseDate: detail.releaseDate,
      );
      favoriteGames.add(gameItem);
      Get.snackbar(
        'Favoritos',
        '${detail.title} foi adicionado aos favoritos.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeFavorite(int gameId) {
    favoriteGames.removeWhere((GameModel game) => game.id == gameId);
    Get.snackbar(
      'Favoritos',
      'Jogo removido dos favoritos.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}