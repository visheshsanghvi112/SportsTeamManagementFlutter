import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Team Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'FuturisticFont', // Use a futuristic font
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sports Team Chatbot'),
            SizedBox(width: 10),
            Hero(
              tag: 'teamLogo',
              child: Image.asset(
                'assets/hsnc_logo.png',
                height: 40,
                width: 40,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[50], // Add a subtle background color
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (_, index) => _messages[index],
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Send a message',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearChat, // Add a "clear chat" button
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    _addMessage(text, true); // User message
    _generateBotResponse(text);
  }

  void _generateBotResponse(String userQuery) {
    // Simulate bot typing indicator
    _addMessage('...', false);

    // Simulate delay for generating a response
    Future.delayed(Duration(seconds: 1), () {
      String botResponse = getAnswer(userQuery);
      _addMessage(botResponse, false); // Bot message
    });
  }

  void _addMessage(String text, bool isUser) {
    ChatMessage message = ChatMessage(
      text: text,
      isUser: isUser,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isUser
              ? Container()
              : Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: _buildAvatarContent(),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 30, right: 30, top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // Adjust border radius
                color: isUser ? Colors.blue : Colors.grey,
                border: Border.all(
                  color: isUser ? Colors.transparent : Colors.white,
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? Colors.transparent
                        : Theme.of(context).primaryColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: FadeTransition(
                opacity: AlwaysStoppedAnimation(1.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Image? _buildAvatarContent() {
    if (isUser) {
      return null;
    } else {
      return Image.asset(
        'assets/hsnc_logo.png',
        height: 40,
        width: 40,
      );
    }
  }
}



String getAnswer(String question) {
  question = question.toLowerCase();

  if (question.contains('hi') || question.contains('hello') || question.contains('sup')) {
    return "Hello! How can I assist you today?";
  } else if (question.contains('how are you')) {
    return "I'm just a bot, but I'm doing well! How can I help you?";
  } else if (question.contains('event')) {
    return "The next event is scheduled for next month. Stay tuned for more details!";
  } else if (question.contains('phone number') || question.contains('contact')) {
    return "For contact information, please visit our official website.";
  } else if (question.contains('resign') || question.contains('quit') || question.contains('leave')) {
    return "I'm sorry to hear that. Please contact HR for resignation-related queries.";
  } else if (question.contains('favorite player') || question.contains('best player')) {
    return "Our team has many talented players. Each one contributes to our success!";
  } else if (question.contains('next game') || question.contains('upcoming match')) {
    return "The next game is scheduled for this weekend. Get ready to cheer for our team!";
  } else if (question.contains('training schedule') || question.contains('practice')) {
    return "The team's training schedule varies, but they usually practice every weekday. Check the official schedule for details.";
  } else if (question.contains('merchandise') || question.contains('team store')) {
    return "You can purchase team merchandise from our official online store.";
  } else if (question.contains('social media') || question.contains('follow')) {
    return "Stay updated on our latest news and events by following us on social media!";
  } else if (question.contains('win') || question.contains('championship')) {
    return "Our goal is to win the championship this season. Go team!";
  } else if (question.contains('ticket') || question.contains('buy tickets')) {
    return "Tickets for upcoming games are available on our official website.";
  } else if (question.contains('website') || question.contains('official site')) {
    return "You can find all the information you need on our official website.";
  } else if (question.contains('coach') || question.contains('head coach')) {
    return "Our head coach is dedicated to leading the team to success.";
  } else if (question.contains('fan club') || question.contains('join fan club')) {
    return "Become a member of our fan club for exclusive benefits and experiences!";
  } else if (question.contains('team colors') || question.contains('jersey color')) {
    return "Our team colors are blue and white.";
  } else if (question.contains('award') || question.contains('trophy')) {
    return "Our team has won multiple awards and trophies over the years.";
  } else if (question.contains('playoffs') || question.contains('postseason')) {
    return "We're aiming for the playoffs this year. Fingers crossed!";
  } else if (question.contains('rival') || question.contains('biggest rival')) {
    return "Our biggest rival is known for intense matchups. It's always a thrilling game!";
  } else if (question.contains('mascot')) {
    return "Our team's mascot is a symbol of strength and team spirit.";
  } else if (question.contains('charity') || question.contains('community outreach')) {
    return "We actively engage in charity and community outreach programs. Learn more on our website.";
  } else if (question.contains('training facility') || question.contains('home ground')) {
    return "Our team's home ground is equipped with state-of-the-art training facilities.";
  } else if (question.contains('captain') || question.contains('team captain')) {
    return "Our team captain is a respected leader on and off the field.";
  } else if (question.contains('injury update') || question.contains('health')) {
    return "For the latest injury updates and player health, check our official announcements.";
  } else if (question.contains('watch game live') || question.contains('live streaming')) {
    return "You can catch our games live on various streaming platforms. Visit our website for details.";
  } else if (question.contains('post-game celebration') || question.contains('celebration')) {
    return "Join us for the post-game celebration after our next victory!";
  } else if (question.contains('merchandise discount') || question.contains('sale')) {
    return "Keep an eye out for special discounts and sales on team merchandise.";
  } else if (question.contains('team slogan') || question.contains('motto')) {
    return "Our team slogan is 'Together We Win!'";
  } else if (question.contains('stadium capacity') || question.contains('seating capacity')) {
    return "Our stadium has a seating capacity of [number].";
  } else if (question.contains('broadcasting network') || question.contains('tv channel')) {
    return "Our games are broadcasted on [network]. Check local listings for details.";
  } else if (question.contains('post-game interview') || question.contains('interviews')) {
    return "Catch post-game interviews with players and coaches on our official YouTube channel.";
  } else if (question.contains('nutrition') || question.contains('diet')) {
    return "Our players follow a strict nutrition plan to stay at peak performance.";
  } else if (question.contains('training camp') || question.contains('pre-season')) {
    return "The team's training camp typically begins in [month]. Check our schedule for details.";
  } else if (question.contains('team song') || question.contains('anthem')) {
    return "Our team anthem is a symbol of pride and unity among our fans.";
  } else if (question.contains('pre-game ritual') || question.contains('superstition')) {
    return "Some players have unique pre-game rituals that they believe bring good luck!";
  } else if (question.contains('retired jersey') || question.contains('legend')) {
    return "We've retired jerseys to honor legendary players who made significant contributions to the team.";
  } else if (question.contains('play of the year')) {
    return "Last year, the play of the year was an incredible [description].";
  } else if (question.contains('fans') || question.contains('supporters')) {
    return "Our fans are the heartbeat of the team. Thank you for your unwavering support!";
  } else if (question.contains('how are you')) {
    return "I'm just a bot, but I'm doing well! How can I help you?";
  } else if (question.contains('event')) {
    return "The next event is scheduled for next month. Stay tuned for more details!";
  } else if (question.contains('phone number') || question.contains('contact')) {
    return "For contact information, please visit our official website.";
  } else if (question.contains('resign') || question.contains('quit') || question.contains('leave')) {
    return "I'm sorry to hear that. Please contact HR for resignation-related queries.";
  } else if (question.contains('favorite player') || question.contains('best player')) {
    return "Our team has many talented players. Each one contributes to our success!";
  } else if (question.contains('favorite player') || question.contains('ok')) {
    return "Please feel free to ask more questions Thankyou !!!";
  } else if (question.contains('favorite player') || question.contains('fuckoff')) {
    return "You fuck off !";
  } else if (question.contains('favorite player') || question.contains('kese ho')) {
    return "I am good how about you !";
  } else if (question.contains('vishesh') || question.contains('i am vishesh')) {
    return "Hello Master Welcome how can I help you today !";
  } else if (question.contains('favorite player') || question.contains('Fuckkyouu')) {
    return "Fuckoff !";
  } else if (question.contains('favorite player') || question.contains('Hey')) {
    return "Hello how can I assist you  !";
  } else if (question.contains('favorite player') || question.contains('Hii')) {
    return "Hello how can I assist you  !";
  } else if (question.contains('favorite player') || question.contains('Hiiii')) {
    return "Hello how can I assist you  !";
  } else if (question.contains('favorite player') || question.contains('wassup')) {
    return "Nothing much you say  !";
  } else if (question.contains('favorite player') || question.contains('Bhalchandra sir number ')) {
    return "You will find that in the about section !";
  } else if (question.contains('sports committee ') || question.contains('who is the incharge of sports  committee')) {
    return " Bhalachandra Sir!";

  } else if (question.contains('next game') || question.contains('upcoming match')) {
    return "The next game is scheduled for this weekend. Get ready to cheer for our team!";
  } else if (question.contains('training schedule') || question.contains('practice')) {
    return "The team's training schedule varies, but they usually practice every weekday. Check the official schedule for details.";
  } else if (question.contains('merchandise') || question.contains('team store')) {
    return "You can purchase team merchandise from our official online store.";
  } else if (question.contains('social media') || question.contains('follow')) {
    return "Stay updated on our latest news and events by following us on social media!";
  } else if (question.contains('win') || question.contains('championship')) {
    return "Our goal is to win the championship this season. Go team!";
  } else if (question.contains('ticket') || question.contains('buy tickets')) {
    return "Tickets for upcoming games are available on our official website.";
  } else if (question.contains('website') || question.contains('official site')) {
    return "You can find all the information you need on our official website.";
  } else if (question.contains('coach') || question.contains('head coach')) {
    return "Our head coach is dedicated to leading the team to success.";
  } else if (question.contains('fan club') || question.contains('join fan club')) {
    return "Become a member of our fan club for exclusive benefits and experiences!";
  } else if (question.contains('team colors') || question.contains('jersey color')) {
    return "Our team colors are blue and white.";
  } else if (question.contains('award') || question.contains('trophy')) {
    return "Our team has won multiple awards and trophies over the years.";
  } else if (question.contains('playoffs') || question.contains('postseason')) {
    return "We're aiming for the playoffs this year. Fingers crossed!";
  } else if (question.contains('rival') || question.contains('biggest rival')) {
    return "Our biggest rival is known for intense matchups. It's always a thrilling game!";
  } else if (question.contains('mascot')) {
    return "Our team's mascot is a symbol of strength and team spirit.";
  } else if (question.contains('charity') || question.contains('community outreach')) {
    return "We actively engage in charity and community outreach programs. Learn more on our website.";
  } else if (question.contains('training facility') || question.contains('home ground')) {
    return "Our team's home ground is equipped with state-of-the-art training facilities.";
  } else if (question.contains('captain') || question.contains('team captain')) {
    return "Our team captain is a respected leader on and off the field.";
  } else if (question.contains('injury update') || question.contains('health')) {
    return "For the latest injury updates and player health, check our official announcements.";
  } else if (question.contains('watch game live') || question.contains('live streaming')) {
    return "You can catch our games live on various streaming platforms. Visit our website for details.";
  } else if (question.contains('post-game celebration') || question.contains('celebration')) {
    return "Join us for the post-game celebration after our next victory!";
  } else if (question.contains('merchandise discount') || question.contains('sale')) {
    return "Keep an eye out for special discounts and sales on team merchandise.";
  } else if (question.contains('team slogan') || question.contains('motto')) {
    return "Our team slogan is 'Together We Win!'";
  } else if (question.contains('stadium capacity') || question.contains('seating capacity')) {
    return "Our stadium has a seating capacity of [number].";
  } else if (question.contains('broadcasting network') || question.contains('tv channel')) {
    return "Our games are broadcasted on [network]. Check local listings for details.";
  } else if (question.contains('post-game interview') || question.contains('interviews')) {
    return "Catch post-game interviews with players and coaches on our official YouTube channel.";
  } else if (question.contains('nutrition') || question.contains('diet')) {
    return "Our players follow a strict nutrition plan to stay at peak performance.";
  } else if (question.contains('training camp') || question.contains('pre-season')) {
    return "The team's training camp typically begins in [month]. Check our schedule for details.";
  } else if (question.contains('team song') || question.contains('anthem')) {
    return "Our team anthem is a symbol of pride and unity among our fans.";
  } else if (question.contains('pre-game ritual') || question.contains('superstition')) {
    return "Some players have unique pre-game rituals that they believe bring good luck!";
  } else if (question.contains('retired jersey') || question.contains('legend')) {
    return "We've retired jerseys to honor legendary players who made significant contributions to the team.";
  } else if (question.contains('play of the year')) {
    return "Last year, the play of the year was an incredible [description].";
  } else if (question.contains('fans') || question.contains('supporters')) {
    return "Our fans are the heartbeat of the team. Thank you for your unwavering support!";
  } else if (question.contains('concession stand') || question.contains('food')) {
    return "Enjoy a variety of delicious snacks and meals at our concession stand during games.";
  } else if (question.contains('philosophy on player development')) {
    return "Player development is a key focus for us. We believe in nurturing talent and providing opportunities for growth.";
  } else if (question.contains('sponsor') || question.contains('sponsorship')) {
    return "For sponsorship inquiries, please contact our sponsorship department through our official website.";
  } else if (question.contains('mobile app') || question.contains('app')) {
    return "Yes, you can download our official mobile app for the latest news, scores, and exclusive content.";
  } else if (question.contains('awards ceremony') || question.contains('awards')) {
    return "The team awards ceremony is held at the end of the season. Stay tuned for announcements on the specific date.";
  } else if (question.contains('madarchod') || question.contains('flag') || question.contains('stadium rules')) {
    return "Yes, you can bring a banner or flag to the stadium during games. Please adhere to stadium rules and guidelines.";
  } else {
    return "I'm sorry, I didn't understand that. Please ask something else related to the sports team.";
  }
}
