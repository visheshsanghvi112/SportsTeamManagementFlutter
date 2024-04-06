import 'package:flutter/material.dart';

class CurrentTeamPage extends StatelessWidget {
  final Map<String, List<Team>> sportsTeams;

  CurrentTeamPage({required this.sportsTeams});

  @override
  Widget build(BuildContext context) {
    // Assuming you want to display the first sport's first team as an example
    String firstSport = sportsTeams.keys.first;
    List<Team> firstSportTeams = sportsTeams[firstSport]!;
    Team currentTeam = firstSportTeams.isNotEmpty ? firstSportTeams.first : Team(name: '', logo: '', members: []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Current Team'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Current Sport: $firstSport',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ListTile(
            title: Text(currentTeam.name),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(currentTeam.logo),
            ),
            subtitle: Text('Members: ${currentTeam.members.join(', ')}'),
          ),
        ],
      ),
    );
  }
}

class Team {
  final String name;
  final String logo;
  final List<String> members;

  Team({required this.name, required this.logo, required this.members});
}
