import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:group_16_entertainment_app/main.dart';

class GameScreen extends StatefulWidget {
  final String userId; // Declare userId as a field
  final int prevScore;
  const GameScreen({super.key, required this.userId, required this.prevScore});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Map<String, dynamic>? questionData;
  String? selectedAnswer;
  int score = 0;
  int timer = 30;
  late Timer countdownTimer;

  final String apiUrl =
      "https://quizapi.io/api/v1/questions?apiKey=Ieaj2jbcNs2s4ijvgnyJTTG76HZzfSyau6A2I2Aj&limit=1";

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
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          questionData = data.isNotEmpty ? data[0] : null;
          timer = 30;
          startCountdown();
        });
      } else {
        throw Exception("Failed to load question");
      }
    } catch (e) {
      print("Error fetching question: $e");
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
      countdownTimer.cancel(); // Stop the timer
      print('Countdown timer stopped.');
    }
  }

  void checkAnswer(String answerKey) {
    final correctAnswers = questionData?['correct_answers'] ?? {};
    if (correctAnswers["${answerKey}_correct"] == "true") {
      setState(() {
        score += 10; // Increment score for correct answer
        saveProgress(score);
      });
    }
    showResult();
  }

  void saveProgress(int points) async {
    try {
      // Perform the UPDATE query using Supabase client
      final response = await Supabase.instance.client
          .from('users') // Replace with your actual table name
          .update({'points': points})
          .eq('user_id', widget.userId) // Match the user_id
          .select('user_id, points');

      if (response.isEmpty) {
        // Handle error from the update query
        print('Error updating points!');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving progress!')));
      } else {
        // Update was successful
        print('Progress saved successfully for user: ${widget.userId}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress saved successfully!')),
        );
      }
    } catch (e) {
      // Handle unexpected errors
      print('Unexpected error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unexpected error: $e')));
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
                    (context) =>
                        HomePage(userId: widget.userId, prevScore: score),
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
                              ), // Add spacing between items
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
