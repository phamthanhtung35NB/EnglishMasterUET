import 'package:flutter/foundation.dart';
import 'learned_word.dart'; // Đảm bảo import class LearnedWord
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class UserProgress extends ChangeNotifier {

  String _userName = "Học viên English Master"; // Giá trị mặc định

  // Thêm getter và setter
  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    _saveProgress();
    notifyListeners();
  }

  DateTime? _appStartTime;
  Duration _totalStudyTime = Duration.zero;

  Map<String, Set<String>> _learnedTopics = {};
  List<LearnedWord> _allLearnedWords = [];
  List<LearnedWord> _favoriteWords = [];
  DateTime? _lastLoginTime; // Thêm thuộc tính này
  int _loginStreak = 0; // Thêm thuộc tính này để theo dõi streak

  UserProgress() {
    // Load saved progress when the class is initialized
    _loadSavedProgress();
  }



  // Phương thức để format thời gian học thành chuỗi dễ đọc
  String formatStudyTime() {
    int hours = _totalStudyTime.inHours;
    int minutes = _totalStudyTime.inMinutes.remainder(60);
    int seconds = _totalStudyTime.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  // Tải tiến trình từ SharedPreferences
  Future<void> _loadSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();


    // Tải thông tin đăng nhập cuối cùng
    final lastLoginTimeString = prefs.getString('last_login_time');
    if (lastLoginTimeString != null) {
      _lastLoginTime = DateTime.parse(lastLoginTimeString);
    }

    // Tải login streak
    _loginStreak = prefs.getInt('login_streak') ?? 0;

    // Load tên người dùng
    _userName = prefs.getString('user_name') ?? "Học viên English Master";

    // Tải tổng thời gian học
    final savedStudyTimeInSeconds = prefs.getInt('total_study_time') ?? 0;
    _totalStudyTime = Duration(seconds: savedStudyTimeInSeconds);

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

    // Lưu thời gian đăng nhập cuối cùng
    if (_lastLoginTime != null) {
      await prefs.setString('last_login_time', _lastLoginTime!.toIso8601String());
    }

    // Lưu login streak
    await prefs.setInt('login_streak', _loginStreak);

    // Lưu tên người dùng
    await prefs.setString('user_name', _userName);

    // Lưu tổng thời gian học
    await prefs.setInt('total_study_time', _totalStudyTime.inSeconds);

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

  // Phương thức cập nhật thời gian đăng nhập
  void updateLoginTime() {
    final now = DateTime.now();

    if (_lastLoginTime != null) {
      // Tính khoảng thời gian từ lần đăng nhập cuối
      final timeDifference = now.difference(_lastLoginTime!);

      // Kiểm tra nếu đăng nhập lại sau 24 giờ
      if (timeDifference.inHours >= 24) {
        _loginStreak++;
      }
    }

    _lastLoginTime = now;
    _saveProgress();
    notifyListeners();
  }
  // Getter để lấy thời gian còn lại đến lần đăng nhập tiếp theo
  Duration? get timeUntilNextLogin {
    if (_lastLoginTime == null) return null;

    final nextLoginTime = _lastLoginTime!.add(Duration(hours: 24));
    final remaining = nextLoginTime.difference(DateTime.now());

    return remaining.isNegative ? null : remaining;
  }

  // Getter để lấy login streak
  int get loginStreak => _loginStreak;

  // Getter cho tổng thời gian học
  Duration get totalStudyTime => _totalStudyTime;

  // Phương thức để thêm thời gian học
  void addStudyTime(Duration duration) {
    _totalStudyTime += duration;
    _saveProgress();
    notifyListeners();
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