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
        // User Profile Section as title (custom component)
        title: UserProfile(username: username),
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
            // custom button widget for `Start Game` button
            Center(
              child: CustomButton(
                text: 'Start Game',
                onTap: () {
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
                color: Colors.green,
                icon: Icons.play_arrow,
                size: 20.0,
              ),
            ),
            const SizedBox(height: 20), // Space between buttons
            // custom button widget for `View Leaderboard` button
            Center(
              child: CustomButton(
                text: 'View Leaderboard',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaderboardScreen(),
                    ),
                  );
                },
                color: Colors.green,
                icon: Icons.people_alt_outlined,
                size: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomButton widget
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;
  final double size;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = Colors.blue,
    this.icon,
    this.size = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        fixedSize: Size(300, 50),
      ),
      icon:
          icon != null
              ? Icon(icon, size: size + 4, color: Colors.white)
              : const SizedBox.shrink(),
      label: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// UserProfile widget
class UserProfile extends StatelessWidget {
  final String username;

  const UserProfile({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.supervised_user_circle, color: Colors.white),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
