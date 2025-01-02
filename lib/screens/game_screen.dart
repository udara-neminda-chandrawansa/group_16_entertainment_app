import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart';
import 'package:group_16_entertainment_app/services/game_service_provider.dart';
import 'package:group_16_entertainment_app/screens/results_screen.dart';
import 'package:group_16_entertainment_app/entities/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart'; // animation library for custom component

class GameScreen extends ConsumerStatefulWidget {
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
  // Create the mutable state for the GameScreen
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  // var to hold the question data fetched from `game_service.dart`
  Question? questionData;
  String? selectedAnswer;
  int totalQuestionsAsked = 0;
  int correctAnswersGiven = 0;
  int score = 0;
  int timer = 30;
  late Timer countdownTimer;

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

  // method to fetch a question
  Future<void> fetchQuestion() async {
    // get the `fetchQuestionProvider` from the `ref` object
    final params = {
      'category': widget.category,
      'difficulty': widget.difficulty,
    };
    // get the question data using the `fetchQuestionProvider`
    final questionAsync = await ref.read(fetchQuestionProvider(params).future);
    // set the question data to the fetched question
    setState(() {
      questionData = questionAsync;
      if (questionData != null) {
        timer = 30;
        startCountdown();
      }
    });
    // error display if the question data is null
    if (questionData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Could not fetch question.")),
        );
      }
    }
  }

  // method to start the countdown timer
  void startCountdown() {
    // set the timer to 30 seconds
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // if timer > 0, decrement the timer by 1 second
        if (this.timer > 0) {
          this.timer--;
        } else {
          // if timer reaches 0, cancel the timer and show the result
          timer.cancel();
          showResult(isTimeUp: true);
        }
      });
    });
  }

  // method to stop the countdown timer
  void stopCountdown() {
    if (countdownTimer.isActive) {
      countdownTimer.cancel();
    }
  }

  // method to check the answer
  void checkAnswer(String inputAnswer) {
    // get the correct answer
    final correctAnswer = getCorrectAnswer();
    if (correctAnswer == inputAnswer) {
      setState(() {
        score += 10;
        saveProgress();
      });
    }
    showResult();
  }

  // method to save the progress of the user
  Future<void> saveProgress() async {
    try {
      // save the progress using the `saveProgressProvider`
      final params = {'userId': widget.userId, 'points': score};
      // get the response from the `saveProgressProvider`
      await ref.read(saveProgressProvider(params).future);
      // success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Progress saved successfully!')),
        );
      }
    } catch (e) {
      //error handling
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving progress: $e')));
      }
    }
  }

  // method to show the result
  void showResult({bool isTimeUp = false}) {
    // cancel the countdown timer
    countdownTimer.cancel();
    // get the correct answer
    String correctAnsw = getCorrectAnswer();
    // message to show the result in a dialog
    String message =
        isTimeUp
            ? "Time's up! The correct answer: $correctAnsw"
            : "Correct Answer: $correctAnsw \nYour answer: ${selectedAnswer ?? 'skipped'}";
    // if the selected answer is correct, increment the correct answers given
    if (correctAnsw == selectedAnswer) {
      correctAnswersGiven++;
    }
    // increment the total questions asked
    totalQuestionsAsked++;
    // show the result in a dialog
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

  // method to get the correct answer
  String getCorrectAnswer() {
    // get the correct answer using the `Question` object
    final correctAnswer = questionData?.correctAnswer ?? '';
    switch (correctAnswer) {
      case 'answer_a':
        return questionData?.answers[0] ?? '';
      case 'answer_b':
        return questionData?.answers[1] ?? '';
      case 'answer_c':
        return questionData?.answers[2] ?? '';
      case 'answer_d':
        return questionData?.answers[3] ?? '';
      case 'answer_e':
        return questionData?.answers[4] ?? '';
      case 'answer_f':
        return questionData?.answers[5] ?? '';
    }
    return "";
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
        actions: [
          IconButton(
            icon: const Icon(Icons.scoreboard_rounded),
            tooltip: "View Results",
            onPressed: () {
              stopCountdown();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ResultsScreen(
                        userId: widget.userId,
                        username: widget.username,
                        finalScore: score,
                        correctAnswers: correctAnswersGiven,
                        totalQuestions: totalQuestionsAsked,
                        category: widget.category,
                        difficulty: widget.difficulty,
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body:
          questionData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ScoreTimerDisplay (custom component)
                    ScoreTimerDisplay(score: score, timer: timer),
                    const SizedBox(height: 20),
                    Text(
                      questionData?.question ?? "Loading question...",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...questionData?.answers.map((entry) {
                          if (entry.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedAnswer = entry;
                                  });
                                  checkAnswer(entry);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 20,
                                  ),
                                ),
                                child: Text(entry),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }).toList() ??
                        [],
                    const Spacer(),
                  ],
                ),
              ),
    );
  }
}

// ScoreTimerDisplay widget
class ScoreTimerDisplay extends StatelessWidget {
  final int score;
  final int timer;

  const ScoreTimerDisplay({Key? key, required this.score, required this.timer})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildAnimatedScore(), _buildAnimatedTimer()],
    );
  }

  Widget _buildAnimatedScore() {
    return TweenAnimationBuilder(
      tween: IntTween(begin: 0, end: score),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Score: $value",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.2, end: 0);
      },
    );
  }

  Widget _buildAnimatedTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: timer < 10 ? Colors.red[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Time Left: $timer s",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: timer < 10 ? Colors.red : Colors.green,
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, end: 0);
  }
}
