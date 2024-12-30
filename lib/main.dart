import 'package:flutter/material.dart';
import 'package:group_16_entertainment_app/screens/CategorySelectionScreen.dart';
import 'package:group_16_entertainment_app/screens/LeaderBoard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:group_16_entertainment_app/screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nzkxkiobcvdsdjlthjtd.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56a3hraW9iY3Zkc2RqbHRoanRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNzg1MTAsImV4cCI6MjA1MDk1NDUxMH0.RPT2E9NFxpE9fym4i1Jk8m3_Hj59pS4uaJC_prKieU8',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quiz App - Group 16",
      theme: ThemeData.light(), // Use a dark theme if desired
      home: LoginPage(), // Set LeaderboardScreen as the home screen
    );
  }
}

class HomePage extends StatelessWidget {
  final String userId; // Declare userId as a field
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
