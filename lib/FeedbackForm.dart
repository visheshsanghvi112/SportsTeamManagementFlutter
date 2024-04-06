import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeedbackForm extends StatefulWidget {
  final void Function(String feedback, int? rating, String feedbackType) onSubmit;

  const FeedbackForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _textEditingController = TextEditingController();
  int _rating = 1;
  String _selectedFeedbackType = 'General';
  final CollectionReference _feedbackCollection = FirebaseFirestore.instance.collection('feedback');
  late Stream<QuerySnapshot> _feedbackStream;
  String _feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    _feedbackStream = _feedbackCollection.orderBy('timestamp', descending: true).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Form'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _textEditingController,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Enter your feedback',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('Rating: '),
                DropdownButton<int>(
                  value: _rating,
                  onChanged: (value) {
                    setState(() {
                      _rating = value!;
                    });
                  },
                  items: List.generate(5, (index) => index + 1)
                      .map((value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  ))
                      .toList(),
                ),
                SizedBox(width: 20),
                Text('Feedback Type: '),
                DropdownButton<String>(
                  value: _selectedFeedbackType,
                  onChanged: (value) {
                    setState(() {
                      _selectedFeedbackType = value!;
                    });
                  },
                  items: ['General', 'Bug', 'Feature Request']
                      .map((value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ))
                      .toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: _submitFeedback,
              child: const Text('Submit'),
            ),
          ),
          SizedBox(height: 20),
          _feedbackMessage.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _feedbackMessage,
              style: TextStyle(
                color: _feedbackMessage.contains('Success') ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Container(),
          SizedBox(height: 10),
          Expanded(
            child: _buildFeedbackList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _feedbackStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final feedbackDocs = snapshot.data!.docs;
          return AnimationLimiter(
            child: ListView.builder(
              itemCount: feedbackDocs.length,
              itemBuilder: (context, index) {
                final feedback = feedbackDocs[index]['feedback'];
                final timestamp = feedbackDocs[index]['timestamp'] as Timestamp;
                final date = DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);

                // Check if data() is not null and the "rating" field exists in the document
                final Map<String, dynamic>? docData = feedbackDocs[index].data() as Map<String, dynamic>?;

                final rating = docData != null && docData.containsKey('rating')
                    ? docData['rating'] as int
                    : null;

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: ListTile(
                        title: Text(feedback),
                        subtitle: Text(
                          rating != null
                              ? 'Rating: $rating, Submitted on: ${DateFormat('MMM dd, yyyy').format(date)}'
                              : 'Submitted on: ${DateFormat('MMM dd, yyyy').format(date)}',
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  void _submitFeedback() {
    final feedback = _textEditingController.text.trim();
    if (feedback.isNotEmpty) {
      _saveFeedback(feedback);
    } else {
      _showMessage('Please enter your feedback', false);
    }
  }

  Future<void> _saveFeedback(String feedback) async {
    try {
      await _feedbackCollection.add({
        'feedback': feedback,
        'rating': _rating,
        'feedbackType': _selectedFeedbackType,
        'timestamp': Timestamp.now(),
      });
      _textEditingController.clear(); // Clear the text field after submission
      _showMessage('Feedback submitted successfully', true);
    } catch (e) {
      print('Error submitting feedback: $e');
      _showMessage('Failed to submit feedback. Please try again.', false);
    }
  }

  void _showMessage(String message, bool isSuccess) {
    setState(() {
      _feedbackMessage = message;
      if (isSuccess) {
        _textEditingController.clear();
      }
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
