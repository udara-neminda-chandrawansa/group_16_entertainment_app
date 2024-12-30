import 'package:flutter/material.dart';
import 'dart:async';
import 'package:group_16_entertainment_app/main.dart';
import 'package:group_16_entertainment_app/services/gameService.dart';

class GameScreen extends StatefulWidget {
  final String userId;
  final String username;
  final int prevScore;
  final String category;
  final String difficulty;

  const GameScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.prevScore,
    required this.category,
    required this.difficulty,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<String, dynamic>? questionData;
  String? selectedAnswer;
  int score = 0;
  int timer = 30;
  late Timer countdownTimer;
  final GameService gameService = GameService();

  @override
  void initState() {
    super.initState();
    score = widget.prevScore;
    fetchQuestion();
  }

  @override
  void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }

  Future<void> fetchQuestion() async {
    questionData = await gameService.fetchQuestion(
      widget.category,
      widget.difficulty,
    );
    if (questionData != null) {
      setState(() {
        timer = 30;
        startCountdown();
      });
    } else {
      print("Error: Could not fetch question.");
    }
  }

  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (this.timer > 0) {
          this.timer--;
        } else {
          timer.cancel();
          showResult(isTimeUp: true);
        }
      });
    });
  }

  void stopCountdown() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  void checkAnswer(String answerKey) {
    final correctAnswers = questionData?['correct_answers'] ?? {};
    if (correctAnswers["${answerKey}_correct"] == "true") {
      setState(() {
        score += 10;
        saveProgress();
      });
    }
    showResult();
  }

  Future<void> saveProgress() async {
    try {
      await gameService.saveProgress(widget.userId, score);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving progress: $e')));
    }
  }

  void showResult({bool isTimeUp = false}) {
    countdownTimer.cancel();
    String correctAnsw = getCorrectAnswer();
    String message =
        isTimeUp
            ? "Time's up! The correct answer: $correctAnsw"
            : "Correct Answer: $correctAnsw \nYour answer: ${selectedAnswer ?? 'skipped'}";
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Quiz Result"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  fetchQuestion();
                },
                child: const Text("Next Question"),
              ),
            ],
          ),
    );
  }

  String getCorrectAnswer() {
    final correctAnswers = questionData?['correct_answers'] ?? {};
    final answers = questionData?['answers'] ?? {};
    for (var key in correctAnswers.keys) {
      if (correctAnswers[key] == "true") {
        return answers[key.replaceFirst("_correct", "")] ?? "Unknown";
      }
    }
    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz App"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: "Back to Home",
          onPressed: () {
            stopCountdown();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => HomePage(
                      userId: widget.userId,
                      username: widget.username,
                      prevScore: score,
                    ),
              ),
            );
          },
        ),
      ),
      body:
          questionData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionData?['question'] ?? "Loading question...",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...questionData?['answers'].entries.map((entry) {
                          if (entry.value != null) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedAnswer = entry.value;
                                  });
                                  checkAnswer(entry.key);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 20,
                                  ),
                                ),
                                child: Text(entry.value),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }).toList() ??
                        [],
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Score: $score",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Time Left: $timer s",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
