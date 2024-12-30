import 'package:flutter/material.dart';
import 'package:group_16_entertainment_app/screens/GameScreen.dart';

class CategorySelectionScreen extends StatefulWidget {
  final String userId;
  final String username;
  final int prevScore;

  const CategorySelectionScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.prevScore,
  });

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String? selectedCategory; // To store selected category
  String selectedDifficulty = "Easy"; // Default difficulty

  // List of categories
  final List<Map<String, dynamic>> categories = [
    {'name': 'Linux', 'icon': Icons.laptop_chromebook},
    {'name': 'DevOps', 'icon': Icons.cloud},
    {'name': 'WordPress', 'icon': Icons.wordpress},
    {'name': 'VueJS', 'icon': Icons.javascript},
    {'name': 'React', 'icon': Icons.javascript},
    {'name': 'SQL', 'icon': Icons.table_chart},
    {'name': 'Code', 'icon': Icons.code},
  ];

  void proceedToGame() {
    if (selectedCategory == null) {
      // Show a warning if no category is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category to proceed!')),
      );
      return;
    }

    // Navigate to the game screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => GameScreen(
              userId: widget.userId,
              username: widget.username,
              prevScore: widget.prevScore,
              category: selectedCategory!,
              difficulty: selectedDifficulty,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Category'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a Category',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Categories Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category['name'];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:
                            selectedCategory == category['name']
                                ? Colors.blue
                                : Colors.grey[300],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'],
                            size: 48,
                            color:
                                selectedCategory == category['name']
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  selectedCategory == category['name']
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Difficulty Selector
            const Text(
              'Select Difficulty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text('Easy'),
                  selected: selectedDifficulty == 'Easy',
                  onSelected: (selected) {
                    setState(() {
                      selectedDifficulty = 'Easy';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Medium'),
                  selected: selectedDifficulty == 'Medium',
                  onSelected: (selected) {
                    setState(() {
                      selectedDifficulty = 'Medium';
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text('Hard'),
                  selected: selectedDifficulty == 'Hard',
                  onSelected: (selected) {
                    setState(() {
                      selectedDifficulty = 'Hard';
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Proceed Button
            ElevatedButton(
              onPressed: proceedToGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Proceed', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
