import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_controller.dart';
import '../models/game_detail_model.dart';

class GameDetailPage extends StatefulWidget {
  final int gameId;

  const GameDetailPage({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  final GameController gameController = Get.find<GameController>();

  @override
  void initState() {
    super.initState();
    gameController.fetchGameDetail(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Jogo'),
      ),
      body: Obx(() {
        if (gameController.isLoadingDetail.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (gameController.detailErrorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gameController.detailErrorMessage.value,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      gameController.fetchGameDetail(widget.gameId);
                    },
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        }

        final GameDetailModel? detail = gameController.selectedGameDetail.value;
        if (detail == null) {
          return const Center(
            child: Text('Nenhum detalhe encontrado.'),
          );
        }

        final bool isFav = gameController.isFavorite(detail.id);
        final SystemRequirementsModel? req = detail.minimumSystemRequirements;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  detail.thumbnail,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                detail.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    gameController.toggleFavoriteFromDetail(detail);
                  },
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                  ),
                  label: Text(
                    isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail.description.isNotEmpty
                    ? detail.description
                    : 'Descrição não informada.',
              ),
              const SizedBox(height: 16),
              Text(
                'Gênero: ${detail.genre.isNotEmpty ? detail.genre : 'Não informado'}',
              ),
              const SizedBox(height: 6),
              Text(
                'Plataforma: ${detail.platform.isNotEmpty ? detail.platform : 'Não informado'}',
              ),
              const SizedBox(height: 6),
              Text(
                'Desenvolvedora: ${detail.developer.isNotEmpty ? detail.developer : 'Não informado'}',
              ),
              const SizedBox(height: 6),
              Text(
                'Publicadora: ${detail.publisher.isNotEmpty ? detail.publisher : 'Não informado'}',
              ),
              const SizedBox(height: 6),
              Text(
                'Data de lançamento: ${detail.releaseDate.isNotEmpty ? detail.releaseDate : 'Não informada'}',
              ),
              const SizedBox(height: 16),
              const Text(
                'Requisitos mínimos do sistema',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              if (req != null) ...[
                Text('Sistema operacional: ${req.os}'),
                Text('Processador: ${req.processor}'),
                Text('Memória: ${req.memory}'),
                Text('Placa de vídeo: ${req.graphics}'),
                Text('Armazenamento: ${req.storage}'),
              ] else ...[
                const Text('Requisitos mínimos não informados para este jogo.'),
              ],
              const SizedBox(height: 16),
              const Text(
                'Link para acessar o jogo:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SelectableText(
                detail.gameUrl.isNotEmpty
                    ? detail.gameUrl
                    : 'Link não disponível',
              ),
            ],
          ),
        );
      }),
    );
  }
}