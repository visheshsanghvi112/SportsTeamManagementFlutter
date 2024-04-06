import 'dart:core';
import 'package:flutter/material.dart';
// Import the ManagePlayers page

// Defining the Player class to represent individual players
class Player {
  String name;
  String position;

  // Constructor for creating Player objects
  Player(this.name, this.position);
}

// Defining the Team class to manage a list of players and represent a team
class Team {
  String name;
  List<Player> players = [];

  // Constructor for creating Team objects
  Team(this.name);

  // Method to add a player to the team
  void addPlayer(Player player) {
    players.add(player);
  }

  // Method to remove a player from the team
  void removePlayer(Player player) {
    players.remove(player);
  }

  // Method to list all players in the team
  void listPlayers() {
    print("Players in Team $name:");
    players.forEach((player) => print("Name: ${player.name}, Position: ${player.position}"));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ManagePlayers(), // Use ManagePlayers as the home page
    );
  }
}

class ManagePlayers extends StatefulWidget {
  const ManagePlayers({Key? key}) : super(key: key);

  @override
  _ManagePlayersState createState() => _ManagePlayersState();
}

class _ManagePlayersState extends State<ManagePlayers> {
  // List to store teams
  List<Team> teams = [];

  // Method to merge two teams
  void mergeTeams(String team1Name, String team2Name) {
    var mergedTeamPlayers = <Player>[];
    for (var team in teams) {
      if (team.name == team1Name || team.name == team2Name) {
        mergedTeamPlayers.addAll(team.players);
      }
    }
    var mergedTeam = Team('$team1Name-$team2Name');
    mergedTeam.players = mergedTeamPlayers;
    teams.removeWhere((team) => team.name == team1Name || team.name == team2Name);
    teams.add(mergedTeam);
    setState(() {});
  }

  // Method to eliminate a player from a team
  void eliminatePlayer(String teamName, String playerName) {
    for (var team in teams) {
      if (team.name == teamName) {
        team.players.removeWhere((player) => player.name == playerName);
        break;
      }
    }
    setState(() {});
  }

  // Method to add a member to a team
  void addMember(String teamName, String memberName, String memberPosition) {
    for (var team in teams) {
      if (team.name == teamName) {
        var newMember = Player(memberName, memberPosition);
        team.addPlayer(newMember);
        break;
      }
    }
    setState(() {});
  }

  // Method to remove a member from a team
  void removeMember(String teamName, String memberName) {
    for (var team in teams) {
      if (team.name == teamName) {
        var playerToRemove = team.players.firstWhere((player) => player.name == memberName, orElse: () => Player('', ''));
        if (playerToRemove.name.isNotEmpty) {
          team.removePlayer(playerToRemove);
        }
        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Management'),
      ),
      body: ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(teams[index].name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      teams.removeAt(index);
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.merge_type),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return MergeTeamDialog(
                          teams: teams,
                          onMerge: (team1Name, team2Name) {
                            mergeTeams(team1Name, team2Name);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return TeamMembersDialog(
                    teamName: teams[index].name,
                    members: teams[index].players,
                    onAdd: (memberName, memberPosition) {
                      addMember(teams[index].name, memberName, memberPosition);
                      Navigator.pop(context);
                    },
                    onDelete: (memberName) {
                      removeMember(teams[index].name, memberName);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddTeamDialog(
                onAdd: (teamName) {
                  teams.add(Team(teamName));
                  setState(() {});
                  Navigator.pop(context);
                },
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTeamDialog extends StatelessWidget {
  final Function(String) onAdd;

  AddTeamDialog({Key? key, required this.onAdd}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Team'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter Team Name',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              onAdd(_controller.text);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class MergeTeamDialog extends StatefulWidget {
  final List<Team> teams;
  final Function(String, String) onMerge;

  MergeTeamDialog({Key? key, required this.teams, required this.onMerge}) : super(key: key);

  @override
  _MergeTeamDialogState createState() => _MergeTeamDialogState();
}

class _MergeTeamDialogState extends State<MergeTeamDialog> {
  String? team1;
  String? team2;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Merge Teams'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: team1,
            hint: const Text('Select Team 1'),
            onChanged: (value) {
              setState(() {
                team1 = value;
              });
            },
            items: widget.teams.map((team) {
              return DropdownMenuItem<String>(
                value: team.name,
                child: Text(team.name),
              );
            }).toList(),
          ),
          DropdownButtonFormField<String>(
            value: team2,
            hint: const Text('Select Team 2'),
            onChanged: (value) {
              setState(() {
                team2 = value;
              });
            },
            items: widget.teams.map((team) {
              return DropdownMenuItem<String>(
                value: team.name,
                child: Text(team.name),
              );
            }).toList(),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (team1 != null && team2 != null && team1 != team2) {
              widget.onMerge(team1!, team2!);
            }
          },
          child: const Text('Merge'),
        ),
      ],
    );
  }
}

class TeamMembersDialog extends StatelessWidget {
  final String teamName;
  final List<Player> members;
  final Function(String, String) onAdd;
  final Function(String) onDelete;

  TeamMembersDialog({Key? key, required this.teamName, required this.members, required this.onAdd, required this.onDelete}) : super(key: key);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Manage Team Members'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Team: $teamName'),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Enter Member Name',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _positionController,
            decoration: const InputDecoration(
              hintText: 'Enter Member Position',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty && _positionController.text.isNotEmpty) {
                    onAdd(_nameController.text, _positionController.text);
                  }
                },
                child: const Text('Add Member'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.isNotEmpty) {
                    onDelete(_nameController.text);
                  }
                },
                child: const Text('Delete Member'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Current Members:'),
          const SizedBox(height: 8),
          if (members.isNotEmpty)
            Column(
              children: members.map((member) {
                return ListTile(
                  title: Text(member.name),
                  subtitle: Text(member.position),
                );
              }).toList(),
            )
          else
            const Text('No members in this team'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
