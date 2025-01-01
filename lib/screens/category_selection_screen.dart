import 'package:flutter/material.dart';
import 'package:group_16_entertainment_app/screens/game_screen.dart';

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

  // method to proceed to the game screen
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
            // Category Cards
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryCard(
                    icon: category["icon"] as IconData,
                    title: category["name"],
                    // if selectedCategory is equal to the current category name, isSelected is true
                    isSelected: selectedCategory == category["name"],
                    onTap: () {
                      setState(() {
                        selectedCategory = category["name"];
                      });
                    },
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

// CategoryCard widget
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blue[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        elevation: isSelected ? 8 : 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
