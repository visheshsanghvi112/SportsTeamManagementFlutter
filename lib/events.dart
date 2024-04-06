import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme_provider.dart';
import 'eventsignup.dart'; // Import EventSignUpPage

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Container(
        color: themeProvider.isDarkMode ? Colors.black : Colors.white, // Set the main background color based on theme
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Section 1: Featured Event
            _buildFeaturedEventCard(themeProvider),

            const SizedBox(height: 16),

            // Section 2: Upcoming Events
            _buildUpcomingEventsSection(themeProvider),

            const SizedBox(height: 16),

            // Section 3: Animated Countdown Timer
            _buildCountdownTimerSection(themeProvider),

            const SizedBox(height: 16),

            // Section 4: Event with Map
            _buildEventWithMapSection(context, themeProvider),

            const SizedBox(height: 16),

            // Section 5: Interactive Event
            _buildInteractiveEventSection(themeProvider, context),
          ],
        ),
      ),
    );
  }

  // Feature 1: Featured Event Card
  Widget _buildFeaturedEventCard(ThemeProvider themeProvider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white, // Adjust background color based on theme
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.isDarkMode ? [Colors.blue.shade900, Colors.purple.shade900] : [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ListTile(
          title: Text(
            'Football Championship',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: June 10, 2024', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              Text('Time: 3:00 PM', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
              Text('Location: Stadium XYZ', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            ],
          ),
          onTap: () {
            // Navigate to the detailed event page
          },
        ),
      ),
    );
  }

  // Feature 2: Upcoming Events Section
  Widget _buildUpcomingEventsSection(ThemeProvider themeProvider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white, // Adjust background color based on theme
      child: ListTile(
        title: Text(
          'Upcoming Events',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Basketball Tournament - February 15, 2024', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            Text('2. Marathon Challenge - March 10, 2024', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            // Add more upcoming events as needed
          ],
        ),
        onTap: () {
          // Navigate to the upcoming events page
        },
      ),
    );
  }

  // Feature 3: Animated Countdown Timer Section
  Widget _buildCountdownTimerSection(ThemeProvider themeProvider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white, // Adjust background color based on theme
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.isDarkMode ? Colors.orange.shade900 : Colors.orange,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: themeProvider.isDarkMode ? Colors.orange.shade900.withOpacity(0.5) : Colors.transparent,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Countdown Timer',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
              onTap: () {
                // Navigate to the countdown timer details page
              },
            ),
            const SizedBox(height: 16),
            Container(
              height: 127,
              decoration: BoxDecoration(
                color: Colors.blue, // Replace with your desired color
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: CountdownTimer(
                  endTime: DateTime.now().millisecondsSinceEpoch + 3 * 24 * 60 * 60 * 1000, // 3 days in milliseconds
                  textStyle: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  onEnd: () {
                    // Handle the end of the countdown
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Feature 4: Event with Map Section
  Widget _buildEventWithMapSection(BuildContext context, ThemeProvider themeProvider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white, // Adjust background color based on theme
      child: ListTile(
        title: Text(
          'Run for a Cause',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: April 5, 2024', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            Text('Time: 8:00 AM', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
            Text('Location: Central Park', style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black)),
          ],
        ),
        trailing: Icon(Icons.location_on, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        onTap: () {
          _launchURL();
        },
      ),
    );
  }

  // Feature 5: Interactive Event Section
  Widget _buildInteractiveEventSection(ThemeProvider themeProvider, BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: themeProvider.isDarkMode ? Colors.grey.shade900 : Colors.white, // Adjust background color based on theme
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              'Interactive Event',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
            ),
            onTap: () {
              // Navigate to the interactive event details page
            },
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/sportsday.jpg'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventSignUpPage(eventName: 'Cricket',)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Change button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Join Now', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Function to launch URL
  _launchURL() async {
    const url = 'https://maps.app.goo.gl/CJQ178smnAjJEmWE9';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
