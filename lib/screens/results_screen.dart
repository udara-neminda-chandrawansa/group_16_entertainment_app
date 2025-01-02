import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // custom component library
import 'game_screen.dart';
import 'home_page.dart';

class ResultsScreen extends StatelessWidget {
  final int finalScore;
  final int correctAnswers;
  final int totalQuestions;
  final String userId;
  final String username;
  final String category;
  final String difficulty;

  const ResultsScreen({
    super.key,
    required this.finalScore,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.userId,
    required this.username,
    required this.category,
    required this.difficulty,
  });

  // method to share the score (custom component)
  void shareScore(BuildContext context) {
    final String message =
        "I scored $finalScore points on the Tech Quiz App! 🎉\nCan you beat my score?";
    // Share the score using the Share plugin
    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: "Back to Home",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => HomePage(
                      userId: userId,
                      username: username,
                      prevScore: finalScore,
                    ),
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Your Final Score",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "${correctAnswers * 10}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Correct Answers: $correctAnswers / $totalQuestions",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => GameScreen(
                          userId: userId,
                          username: username,
                          prevScore: finalScore,
                          category: category, // Reset category
                          difficulty: difficulty, // Reset difficulty
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Play Again",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => shareScore(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                "Share Your Score",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
