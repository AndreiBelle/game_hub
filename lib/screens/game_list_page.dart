import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/game_card.dart';
import '../controllers/game_controller.dart';
import 'favorite_page.dart';
import 'game_detail_page.dart';

class GameListPage extends StatefulWidget {
  const GameListPage({super.key});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  final GameController gameController = Get.find<GameController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openFilterBottomSheet() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filtros e Ordenação',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Plataforma',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: gameController.selectedPlatform.value,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todas')),
                    DropdownMenuItem(value: 'windows', child: Text('Windows')),
                    DropdownMenuItem(value: 'browser', child: Text('Navegador')),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      await gameController.selectPlatform(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Categoria',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: gameController.selectedCategory.value,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todas')),
                    DropdownMenuItem(value: 'shooter', child: Text('Shooter')),
                    DropdownMenuItem(value: 'mmorpg', child: Text('MMORPG')),
                    DropdownMenuItem(value: 'strategy', child: Text('Strategy')),
                    DropdownMenuItem(value: 'racing', child: Text('Racing')),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      await gameController.selectCategory(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ordenação',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: gameController.selectedSortBy.value,
                  items: const [
                    DropdownMenuItem(value: '', child: Text('Padrão')),
                    DropdownMenuItem(
                      value: 'popularity',
                      child: Text('Popularidade'),
                    ),
                    DropdownMenuItem(
                      value: 'alphabetical',
                      child: Text('Alfabética'),
                    ),
                    DropdownMenuItem(
                      value: 'release-date',
                      child: Text('Lançamento'),
                    ),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      await gameController.selectSortBy(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await gameController.clearFilters();
                          Get.back();
                        },
                        child: const Text('Limpar filtros'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('Fechar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Hub'),
        actions: [
          IconButton(
            onPressed: openFilterBottomSheet,
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtros e ordenação',
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const FavoritePage());
            },
            icon: const Icon(Icons.favorite),
            tooltip: 'Favoritos',
          ),
          IconButton(
            onPressed: () {
              gameController.fetchGames();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar jogo pelo nome...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    searchController.clear();
                    gameController.clearSearch();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (value) {
                gameController.updateSearchQuery(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (gameController.isLoadingGames.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (gameController.gamesErrorMessage.value.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gameController.gamesErrorMessage.value,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            gameController.fetchGames();
                          },
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (gameController.filteredGames.isEmpty) {
                return const Center(
                  child: Text('Nenhum jogo encontrado.'),
                );
              }

              return ListView.builder(
                itemCount: gameController.filteredGames.length,
                itemBuilder: (context, index) {
                  final game = gameController.filteredGames[index];
                  return GameCard(
                    game: game,
                    onTap: () {
                      Get.to(() => GameDetailPage(gameId: game.id));
                    },
                  );
                },
              );
            }),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Dados fornecidos por FreeToGame.com (https://www.freetogame.com)',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}