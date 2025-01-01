import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // method to fetch leaderboard data
  Future<List<Map<String, dynamic>>> fetchLeaderboardData() async {
    // Fetch the top 10 players from the database
    final response = await Supabase.instance.client
        .from('users') // Replace 'users' with your actual table name
        .select('username, points')
        .order('points', ascending: false) // Order by points descending
        .limit(10); // Limit to top 10 players
    if (response.isEmpty) {
      throw Exception("Empty Response!");
    }
    // Convert the response to a list of maps
    final data = response as List;
    // Return the data as a list of maps
    return data.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final user = entry.value;
      return {'rank': rank, 'name': user['username'], 'score': user['points']};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8A2BE2), // Purple background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: "Back",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  '👑 Leaderboard',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchLeaderboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No leaderboard data available.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final leaderboardData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Top 10 Players',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                LeaderboardList(leaderboardData: leaderboardData),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LeaderboardList extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboardData;

  const LeaderboardList({Key? key, required this.leaderboardData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder:
            (context, index) =>
                PlayerCard(player: leaderboardData[index], index: index),
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;
  final int index;

  const PlayerCard({Key? key, required this.player, required this.index})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade700,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildRankAvatar(),
                    const SizedBox(width: 16),
                    _buildPlayerName(),
                  ],
                ),
                _buildScore(),
              ],
            ),
          )
          .animate(delay: (50 * index).ms)
          .fadeIn(duration: 300.ms)
          .slideX(begin: 0.2, end: 0)
          .scale(begin: const Offset(0.95, 0.95)),
    );
  }

  Widget _buildRankAvatar() {
    return CircleAvatar(
      backgroundColor: _getRankColor(),
      child: Text(
        player['rank'].toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlayerName() {
    return Text(
      player['name'],
      style: const TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildScore() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${player['score']} pts',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getRankColor() {
    switch (player['rank']) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey.shade300;
      case 3:
        return Colors.brown.shade300;
      default:
        return Colors.blue;
    }
  }
}
