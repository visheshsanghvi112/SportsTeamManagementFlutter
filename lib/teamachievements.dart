import 'package:flutter/material.dart';

class TeamAchievementsPage extends StatelessWidget {
  final List<String> achievementImages = [
    'https://images.pexels.com/photos/3621104/pexels-photo-3621104.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621194/pexels-photo-3621194.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3076509/pexels-photo-3076509.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621311/pexels-photo-3621311.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621163/pexels-photo-3621163.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/1618200/pexels-photo-1618200.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621225/pexels-photo-3621225.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621078/pexels-photo-3621078.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621161/pexels-photo-3621161.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621227/pexels-photo-3621227.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621196/pexels-photo-3621196.jpeg?auto=compress&cs=tinysrgb&w=800',
    'https://images.pexels.com/photos/3621224/pexels-photo-3621224.jpeg?auto=compress&cs=tinysrgb&w=800',
  ];

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Our Achievements',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.0,
    ),
    padding: const EdgeInsets.all(16),
    itemCount: achievementImages.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          achievementImages[index],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: Icon(Icons.error, color: Colors.red),
            );
          },
        ),
      );
    },
  );
}
