import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_service.dart';
import 'package:group_16_entertainment_app/entities/question.dart';

// GameService Provider
final gameServiceProvider = Provider<GameService>((ref) => GameService());

// Fetch Question Provider
final fetchQuestionProvider =
    FutureProvider.family<Question?, Map<String, String>>((ref, params) async {
      final gameService = ref.watch(gameServiceProvider);
      return gameService.fetchQuestion(
        params['category']!,
        params['difficulty']!,
      );
    });

// Save Progress Provider
final saveProgressProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  params,
) async {
  final gameService = ref.watch(gameServiceProvider);
  await gameService.saveProgress(params['userId'], params['points']);
});
