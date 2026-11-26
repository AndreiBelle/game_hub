import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../models/game_model.dart';
import 'game_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find<GameController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos Favoritos'),
      ),
      body: Obx(() {
        if (gameController.favoriteGames.isEmpty) {
          return const Center(
            child: Text('Nenhum jogo adicionado aos favoritos.'),
          );
        }

        return ListView.builder(
          itemCount: gameController.favoriteGames.length,
          itemBuilder: (context, index) {
            final GameModel game = gameController.favoriteGames[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                onTap: () {
                  Get.to(() => GameDetailPage(gameId: game.id));
                },
                leading: SizedBox(
                  width: 80,
                  height: 50,
                  child: Image.network(
                    game.thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                ),
                title: Text(game.title),
                subtitle: Text('${game.genre} - ${game.platform}'),
                trailing: IconButton(
                  onPressed: () {
                    gameController.removeFavorite(game.id);
                  },
                  icon: const Icon(Icons.delete),
                  tooltip: 'Remover',
                ),
              ),
            );
          },
        );
      }),
    );
  }
}