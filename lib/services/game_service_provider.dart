import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_service.dart';
import 'package:group_16_entertainment_app/entities/question.dart';

// GameService Provider
final gameServiceProvider = Provider<GameService>((ref) => GameService());

// Fetch Question Provider method
// A `FutureProvider` that fetches a question based on the provided category and difficulty.
// This provider uses the `gameServiceProvider` to fetch a question from the game service and returns a map with keys `category` and `difficulty`
final fetchQuestionProvider =
    FutureProvider.family<Question?, Map<String, String>>((ref, params) async {
      final gameService = ref.watch(gameServiceProvider);
      return gameService.fetchQuestion(
        params['category']!,
        params['difficulty']!,
      );
    });

// Save Progress Provider method
// A `FutureProvider` that saves the progress of a game for a specific user. This provider takes a `Map<String, dynamic>` as parameters
// The provider uses the `gameServiceProvider` to call the `saveProgress` method with the provided `userId` and `points`
final saveProgressProvider = FutureProvider.family<void, Map<String, dynamic>>((
  ref,
  params,
) async {
  final gameService = ref.watch(gameServiceProvider);
  await gameService.saveProgress(params['userId'], params['points']);
});
