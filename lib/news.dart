import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<NewsItem> newsItems; // Define the list of news items
  String? selectedSport; // Define the selected sport for filtering
  late List<NewsItem> filteredNewsItems; // Define the list of filtered news items
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize the list of news items
    newsItems = [
      NewsItem(
        title: 'Football Tournament Finals',
        description: 'Exciting finals of the inter-college football tournament happening next weekend!',
        date: 'March 20, 2024',
        sport: 'Football',
      ),
      NewsItem(
        title: 'Cricket Match Results',
        description: 'College A defeats College B in the cricket match held yesterday.',
        date: 'March 25, 2024',
        sport: 'Cricket',
      ),
      NewsItem(
        title: 'Table Tennis Championship',
        description: 'College C emerges as the winner of the table tennis championship.',
        date: 'March 28, 2024',
        sport: 'Table Tennis',
      ),
      NewsItem(
        title: 'Kabaddi Tournament Announcement',
        description: 'College A is organizing a kabaddi tournament next month. Register now!',
        date: 'April 5, 2024',
        sport: 'Kabaddi',
      ),
      NewsItem(
        title: 'Chess Club Meeting',
        description: 'Chess club meeting scheduled for next Saturday at College B.',
        date: 'April 10, 2024',
        sport: 'Chess',
      ),
      NewsItem(
        title: 'Basketball League Finals',
        description: 'Exciting finals of the college basketball league to be held on April 15, 2024.',
        date: 'April 15, 2024',
        sport: 'Basketball',
      ),
      NewsItem(
        title: 'Athletics Meet Results',
        description: 'College A secures top position in the inter-college athletics meet.',
        date: 'April 20, 2024',
        sport: 'Athletics',
      ),
      // Add more news items here
    ];
    filteredNewsItems = newsItems;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        filteredNewsItems = newsItems;
      });
      return;
    }
    setState(() {
      isSearching = true;
      filteredNewsItems = newsItems.where((news) => news.title.toLowerCase().contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('News')
            : TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
              _searchController.clear();
            },
            icon: Icon(isSearching ? Icons.close : Icons.search),
          ),
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme(); // Toggle theme when the button is pressed
            },
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedSport,
                dropdownColor: themeProvider.isDarkMode ? Colors.grey[900] : null, // Set dropdown color based on theme
                style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black), // Set text color based on theme
                onChanged: (value) {
                  setState(() {
                    selectedSport = value;
                    filterNews(value);
                  });
                },
                items: ['All Sports', 'Football', 'Cricket', 'Table Tennis', 'Kabaddi', 'Chess', 'Basketball', 'Athletics']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredNewsItems.length,
                itemBuilder: (context, index) {
                  final newsItem = filteredNewsItems[index];
                  return _buildNewsItem(
                    title: newsItem.title,
                    description: newsItem.description,
                    date: newsItem.date,
                    isDarkMode: themeProvider.isDarkMode,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsItem({required String title, required String description, required String date, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to news details page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailsPage(title: title, description: description, date: date),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: isDarkMode ? Colors.grey[900] : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: $date',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void filterNews(String? sport) {
    if (sport == 'All Sports') {
      setState(() {
        filteredNewsItems = newsItems;
      });
    } else {
      setState(() {
        filteredNewsItems = newsItems.where((news) => news.sport == sport).toList();
      });
    }
  }
}

class NewsItem {
  final String title;
  final String description;
  final String date;
  final String sport;

  NewsItem({required this.title, required this.description, required this.date, required this.sport});
}

class NewsDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String date;

  const NewsDetailsPage({Key? key, required this.title, required this.description, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
