import 'package:flutter/material.dart';
import 'package:group_16_entertainment_app/screens/category_selection_screen.dart';
import 'package:group_16_entertainment_app/screens/leader_board.dart';
import 'package:group_16_entertainment_app/screens/login.dart';

class HomePage extends StatelessWidget {
  final String userId; // vars needed for this screen
  final String username;
  final int prevScore;
  const HomePage({
    super.key,
    required this.userId,
    required this.username,
    required this.prevScore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tech Quiz Home\nWelcome $username',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Logout",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        actions: [Text("⚡ $prevScore  ")],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CategorySelectionScreen(
                          userId: userId,
                          username: username,
                          prevScore: prevScore,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Start Game', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20), // Space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'View Leaderboard',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
