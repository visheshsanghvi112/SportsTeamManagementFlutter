import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart'; // Import the ThemeProvider class

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access the ThemeProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: 'Appearance',
              children: [
                _buildListItem(
                  title: 'Dark Mode',
                  icon: Icons.nightlight_round,
                  trailing: Switch(
                    value: themeProvider.isDarkMode, // Use the themeProvider.isDarkMode
                    onChanged: (value) {
                      themeProvider.toggleTheme(); // Toggle the theme
                    },
                  ),
                ),
                _buildListItem(
                  title: 'Font',
                  icon: Icons.font_download,
                  trailing: DropdownButton<String>(
                    value: 'Roboto',
                    items: <String>['Roboto', 'Open Sans', 'Lato', 'Arial']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildSection(
              title: 'Notifications',
              children: [
                _buildListItem(
                  title: 'Enable Notifications',
                  icon: Icons.notifications,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildSection(
              title: 'Data Management',
              children: [
                _buildListItem(
                  title: 'Auto Refresh Data',
                  icon: Icons.refresh,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
                _buildListItem(
                  title: 'Notification Time (minutes)',
                  icon: Icons.access_time,
                  trailing: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: FlutterSlider(
                      values: [15],
                      min: 5,
                      max: 60,
                      onDragging: (handlerIndex, lowerValue, upperValue) {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildSection(
              title: 'Language',
              children: [
                _buildListItem(
                  title: 'Select Language',
                  icon: Icons.language,
                  trailing: DropdownButton<String>(
                    value: 'English',
                    items: <String>['English', 'Spanish', 'French', 'German']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required String title,
    required IconData icon,
    required Widget trailing,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
    );
  }
}
