import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTeamsPage extends StatefulWidget {
  const ManageTeamsPage({Key? key}) : super(key: key);

  @override
  _ManageTeamsPageState createState() => _ManageTeamsPageState();
}

class _ManageTeamsPageState extends State<ManageTeamsPage> {
  Map<String, List<Team>> sportsTeams = {};

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchSportsTeams();
  }

  Future<void> _fetchSportsTeams() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('sports').get();
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.docs;
      setState(() {
        sportsTeams = Map.fromIterable(documents, key: (doc) => doc.id, value: (doc) => _parseTeams(doc.data()));
      });
    } catch (e) {
      print('Error fetching sports teams: $e');
    }
  }

  List<Team> _parseTeams(Map<String, dynamic> data) {
    final List<dynamic> teamsData = data['teams'];
    return teamsData.map<Team>((teamData) {
      return Team(
        name: teamData['name'],
        logo: teamData['logo'],
        members: List<String>.from(teamData['members']),
      );
    }).toList();
  }

  void addSport(String sport) async {
    try {
      await _firestore.collection('sports').doc(sport).set({'teams': []});
      _fetchSportsTeams();
    } catch (e) {
      print('Error adding sport: $e');
    }
  }

  void addTeam(String sport, Team team) async {
    try {
      await _firestore.collection('sports').doc(sport).update({
        'teams': FieldValue.arrayUnion([
          {'name': team.name, 'logo': team.logo, 'members': team.members}
        ]),
      });
      _fetchSportsTeams();
    } catch (e) {
      print('Error adding team: $e');
    }
  }

  void deleteTeam(String sport, Team team) async {
    try {
      await _firestore.collection('sports').doc(sport).update({
        'teams': FieldValue.arrayRemove([
          {'name': team.name, 'logo': team.logo, 'members': team.members}
        ]),
      });
      _fetchSportsTeams();
    } catch (e) {
      print('Error deleting team: $e');
    }
  }

  void fixMatch(String sport, Team team1, Team team2) {
    // Implement logic to fix a match
  }

  void mergeTeams(String sport, Team team1, Team team2) {
    // Implement logic to merge teams
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Teams'),
      ),
      body: ListView.builder(
        itemCount: sportsTeams.length,
        itemBuilder: (context, index) {
          final sport = sportsTeams.keys.elementAt(index);
          final teams = sportsTeams[sport]!;
          return ExpansionTile(
            title: Text(sport),
            children: [
              ...teams.map((team) {
                return ListTile(
                  title: Text(team.name),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(team.logo),
                  ),
                  subtitle: Text('Members: ${team.members.join(', ')}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.sports_soccer),
                        onPressed: () {
                          fixMatch(sport, team, teams.firstWhere((t) => t != team));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.merge_type),
                        onPressed: () {
                          mergeTeams(sport, team, teams.firstWhere((t) => t != team));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteTeam(sport, team);
                        },
                      ),
                    ],
                  ),
                );
              }),
              ListTile(
                title: const Text('Add New Team'),
                leading: const Icon(Icons.add),
                onTap: () {
                  _showAddTeamDialog(context, sport);
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSportDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddSportDialog(BuildContext context) async {
    String newSportName = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Sport'),
          content: TextField(
            onChanged: (value) {
              newSportName = value;
            },
            decoration: const InputDecoration(hintText: 'Enter sport name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newSportName.isNotEmpty) {
                  addSport(newSportName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddTeamDialog(BuildContext context, String sport) async {
    String newTeamName = '';
    String newTeamLogo = '';
    List<String> newTeamMembers = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Team'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    newTeamName = value;
                  },
                  decoration: const InputDecoration(hintText: 'Enter team name'),
                ),
                TextField(
                  onChanged: (value) {
                    newTeamLogo = value;
                  },
                  decoration: const InputDecoration(hintText: 'Enter team logo URL'),
                ),
                TextField(
                  onChanged: (value) {
                    newTeamMembers = value.split(',').map((e) => e.trim()).toList();
                  },
                  decoration: const InputDecoration(hintText: 'Enter team members (comma-separated)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTeam = Team(name: newTeamName, logo: newTeamLogo, members: newTeamMembers);
                addTeam(sport, newTeam);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Team {
  final String name;
  final String logo;
  final List<String> members;

  Team({required this.name, required this.logo, required this.members});
}
