import 'package:flutter/material.dart';

class StoryCollectionScreen extends StatefulWidget {
  final int storyId;
  const StoryCollectionScreen({super.key, required this.storyId});

  @override
  _StoryCollectionScreenState createState() => _StoryCollectionScreenState();
}

class _StoryCollectionScreenState extends State<StoryCollectionScreen> {
  final _controllers = <String, TextEditingController>{};
  int _correctAnswers = 0;
  String _feedback = '';

  final List<Map<String, dynamic>> _storyExercises = [
    {
      'story': 'Once upon a time, there was a ____ (animal) living in the ____ (place).',
      'answers': ['dog', 'forest'],
      'placeholders': ['____ (animal)', '____ (place)'],
    },
    {
      'story': 'The ____ (time) was cold and the ____ (animal) was searching for food.',
      'answers': ['winter', 'fox'],
      'placeholders': ['____ (time)', '____ (animal)'],
    },
    {
      'story': 'She walked through the ____ (place) and saw a ____ (object) on the ground.',
      'answers': ['forest', 'rock'],
      'placeholders': ['____ (place)', '____ (object)'],
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _storyExercises[widget.storyId]['placeholders'].length; i++) {
      _controllers[_storyExercises[widget.storyId]['placeholders'][i]] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _checkAnswers() {
    final answers = _storyExercises[widget.storyId]['answers'] as List<String>;
    int correctCount = 0;
    String feedbackText = '';

    _controllers.forEach((placeholder, controller) {
      final userInput = controller.text.trim().toLowerCase();
      final answer = answers[_controllers.keys.toList().indexOf(placeholder)].toLowerCase();

      if (userInput == answer) {
        correctCount++;
      }
    });

    if (correctCount == answers.length) {
      feedbackText = 'Chúc mừng bạn! Câu trả lời đúng!';
    } else {
      feedbackText = 'Có $correctCount/ ${answers.length} câu trả lời đúng. Hãy thử lại!';
    }

    setState(() {
      _correctAnswers = correctCount;
      _feedback = feedbackText;
    });
  }

  void _retryExercise() {
    _controllers.forEach((_, controller) {
      controller.clear();
    });
    setState(() {
      _correctAnswers = 0;
      _feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final story = _storyExercises[widget.storyId];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bài tập đục lỗ - Truyện ${widget.storyId + 1}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bài tập đục lỗ cho Truyện ${widget.storyId + 1}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStoryText(story),
            const SizedBox(height: 16),
            _buildHoleFillingTextFields(story),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkAnswers,
              child: const Text('Kiểm tra'),
            ),
            const SizedBox(height: 16),
            Text(
              _feedback,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _feedback.contains('Chúc mừng') ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            if (_correctAnswers == story['answers'].length)
              ElevatedButton(
                onPressed: _retryExercise,
                child: const Text('Chơi lại'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryText(Map<String, dynamic> story) {
    String storyText = story['story'];
    for (var placeholder in story['placeholders']) {
      storyText = storyText.replaceFirst(placeholder, '____');
    }
    return Text(
      storyText,
      style: const TextStyle(fontSize: 18),
    );
  }

  Widget _buildHoleFillingTextFields(Map<String, dynamic> story) {
    return Column(
      children: story['placeholders'].map<Widget>((placeholder) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _controllers[placeholder],
            decoration: InputDecoration(
              labelText: 'Điền vào: $placeholder',
              border: OutlineInputBorder(),
            ),
          ),
        );
      }).toList(),
    );
  }
}
