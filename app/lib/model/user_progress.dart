import 'dart:async';

import 'package:flutter/foundation.dart';
import 'learned_word.dart'; // Đảm bảo import class LearnedWord
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class UserProgress extends ChangeNotifier {
  Map<String, Set<String>> _learnedTopics = {};
  List<LearnedWord> _allLearnedWords = [];
  List<LearnedWord> _favoriteWords = [];

  DateTime? _loginTime;
  Duration _totalStudyTime = Duration.zero;
  Timer? _studyTimer;

  DateTime? get loginTime => _loginTime;
  Duration get totalStudyTime => _totalStudyTime;

  void startStudyTracking() {
    _loginTime = DateTime.now();
    // Bắt đầu timer cập nhật thời gian học mỗi giây
    _studyTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _totalStudyTime = DateTime.now().difference(_loginTime!);
      notifyListeners();
    });
  }

  void stopStudyTracking() {
    _studyTimer?.cancel();
  }

  // Phương thức để format thời gian học thành chuỗi dễ đọc
  String formatStudyTime() {
    int hours = _totalStudyTime.inHours;
    int minutes = _totalStudyTime.inMinutes.remainder(60);
    int seconds = _totalStudyTime.inSeconds.remainder(60);
    return '${hours}h ${minutes}m';
  }

  // Thêm phương thức reset khi logout
  void resetStudyTime() {
    _loginTime = null;
    _totalStudyTime = Duration.zero;
    _studyTimer?.cancel();
    notifyListeners();
  }

  UserProgress() {
    // Load saved progress when the class is initialized
    _loadSavedProgress();
  }



  // Tải tiến trình từ SharedPreferences
  Future<void> _loadSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Load learned topics
    final topicsJson = prefs.getString('learned_topics');
    if (topicsJson != null) {
      final Map<String, dynamic> decodedTopics = json.decode(topicsJson);
      _learnedTopics = decodedTopics.map(
              (key, value) => MapEntry(key, Set<String>.from(value))
      );
    }

    // Load learned words
    final wordsJson = prefs.getString('learned_words');
    if (wordsJson != null) {
      final List<dynamic> decodedWords = json.decode(wordsJson);
      _allLearnedWords = decodedWords.map((wordJson) =>
          LearnedWord(
              word: wordJson['word'],
              meaning: wordJson['meaning'],
              topic: wordJson['topic'],
              learnedDate: DateTime.parse(wordJson['learnedDate']),
              isFavorite: wordJson['isFavorite']
          )
      ).toList();

      // Rebuild favorite words list
      _favoriteWords = _allLearnedWords.where((word) => word.isFavorite).toList();
    }

    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Save learned topics
    await prefs.setString('learned_topics', json.encode(
        _learnedTopics.map((key, value) => MapEntry(key, value.toList()))
    ));

    // Save learned words
    await prefs.setString('learned_words', json.encode(
        _allLearnedWords.map((word) => {
          'word': word.word,
          'meaning': word.meaning,
          'topic': word.topic,
          'learnedDate': word.learnedDate.toIso8601String(),
          'isFavorite': word.isFavorite
        }).toList()
    ));
  }


  // Getter cho các thuộc tính riêng tư
  Map<String, Set<String>> get learnedTopics => _learnedTopics;
  List<LearnedWord> get allLearnedWords => _allLearnedWords;
  List<LearnedWord> get favoriteWords => _favoriteWords;

  void addLearnedWord(LearnedWord word) {
    // Kiểm tra xem từ này đã được học chưa
    bool alreadyLearned = _allLearnedWords.any(
            (learnedWord) =>
        learnedWord.word == word.word &&
            learnedWord.topic == word.topic
    );

    if (!alreadyLearned) {
      _allLearnedWords.add(word);

      _learnedTopics.putIfAbsent(word.topic, () => {});
      _learnedTopics[word.topic]!.add(word.word);

      // Lưu tiến trình sau khi thêm từ mới
      _saveProgress();
      notifyListeners();
    }
  }

  void toggleWordFavorite(LearnedWord word) {
    word.toggleFavorite();

    if (word.isFavorite && !_favoriteWords.contains(word)) {
      _favoriteWords.add(word);
    } else {
      _favoriteWords.removeWhere((w) => w.word == word.word);
    }

    // Lưu tiến trình sau khi thay đổi trạng thái yêu thích
    _saveProgress();
    notifyListeners();
  }


  // Các phương thức thống kê
  int getTotalLearnedWords() => _allLearnedWords.length;
  int getTotalLearnedTopics() => _learnedTopics.keys.length;
  int getFavoriteWordsCount() => _favoriteWords.length;


}
