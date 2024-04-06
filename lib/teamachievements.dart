import 'package:flutter/material.dart';

class TeamAchievementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Achievements'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImageColumn(),
            SizedBox(height: 20),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageColumn() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: Column(
        children: [
          _buildImageRow(1),
          _buildImageRow(3),
        ],
      ),
    );
  }

  Widget _buildImageRow(int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Image.network('https://kccollege.edu.in/wp-content/uploads/2024/01/Untitled-design-19.png'),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Image.network('https://kccollege.edu.in/wp-content/uploads/2024/01/Untitled-design-19.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() => GridView.extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(20), // Increased count to 40
    shrinkWrap: true,
  );

  List<Container> _buildGridTileList(int count) {
    return List.generate(
      count,
          (i) => Container(
        child: Image.network('https://kccollege.edu.in/wp-content/uploads/2024/01/Untitled-design-19.png'),
      ),
    );
  }
}
