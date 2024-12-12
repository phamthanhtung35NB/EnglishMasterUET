import 'dart:async';

import 'package:flutter/foundation.dart';
import 'learned_word.dart'; // Đảm bảo import class LearnedWord
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class UserProgress extends ChangeNotifier {

  String _userName = "Học viên English Master"; // Giá trị mặc định


  // Thêm thuộc tính để theo dõi số bài tập đã hoàn thành
  int _completedExercises = 0;

  // Getter để lấy số bài tập đã hoàn thành
  int get completedExercises => _completedExercises;

  // Phương thức để tăng số bài tập đã hoàn thành
  void incrementCompletedExercises() {
    _completedExercises++;
    _saveProgress();
    notifyListeners();
  }


  // Thêm getter và setter
  String get userName => _userName;

  void setUserName(String name) {
    _userName = name;
    _saveProgress();
    notifyListeners();
  }

  DateTime? _appStartTime;


  Map<String, Set<String>> _learnedTopics = {};
  List<LearnedWord> _allLearnedWords = [];
  List<LearnedWord> _favoriteWords = [];
  DateTime? _lastLoginTime; // Thêm thuộc tính này
  int _loginStreak = 1; // Thêm thuộc tính này để theo dõi streak

  // New properties for study time tracking
  DateTime? _studyStartTime;
  Duration _totalStudyTime = Duration.zero;
  Timer? _studyTimer;

  UserProgress() {
    // Load saved progress when the class is initialized
    _loadSavedProgress();
  }


  // Start tracking study time when user logs in
  void startStudyTime() {
    if (_studyStartTime == null) {
      _studyStartTime = DateTime.now();

      // Start a periodic timer to update total study time
      _studyTimer = Timer.periodic(Duration(minutes: 1), (timer) {
        _updateTotalStudyTime();
      });
    }
  }

  // Stop tracking study time when user logs out or app is closed
  void stopStudyTime() {
    if (_studyStartTime != null) {
      _updateTotalStudyTime();
      _studyTimer?.cancel();
      _studyStartTime = null;
      _saveProgress();
    }
  }

  // Update total study time
  void _updateTotalStudyTime() {
    if (_studyStartTime != null) {
      _totalStudyTime += DateTime.now().difference(_studyStartTime!);
      _studyStartTime = DateTime.now(); // Reset start time to current time
      notifyListeners();
    }
  }

  // Get formatted total study time
  String getFormattedStudyTime() {
    int totalMinutes = _totalStudyTime.inMinutes;
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  //--------------------
  // Thêm các thuộc tính mới cho mục tiêu học tập
  int _monthlyWordGoal = 50; // Mục tiêu mặc định
  int _currentMonthLearnedWords = 0;

  // Getter và setter cho mục tiêu học từ vựng
  int get monthlyWordGoal => _monthlyWordGoal;
  int get currentMonthLearnedWords => _currentMonthLearnedWords;

  // Phương thức đặt mục tiêu hàng tháng
  void setMonthlyWordGoal(int goal) {
    _monthlyWordGoal = goal;
    _saveProgress();
    notifyListeners();
  }

  // Phương thức kiểm tra và cập nhật số từ học trong tháng
  void updateMonthlyLearnedWords(LearnedWord word) {
    // Chỉ tăng nếu từ được học trong tháng hiện tại
    if (word.learnedDate.month == DateTime.now().month &&
        word.learnedDate.year == DateTime.now().year) {
      _currentMonthLearnedWords++;
      _saveProgress();
      notifyListeners();
    }
  }

  // Phương thức tính phần trăm hoàn thành mục tiêu
  double getMonthlyGoalCompletionPercentage() {
    return _monthlyWordGoal > 0
        ? (_currentMonthLearnedWords / _monthlyWordGoal * 100).clamp(0, 100)
        : 0.0;
  }



  // Tải tiến trình từ SharedPreferences
  Future<void> _loadSavedProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Tải số bài tập đã hoàn thành
    _completedExercises = prefs.getInt('completed_exercises') ?? 0;

    // Load study time
    final savedStudyTimeJson = prefs.getString('total_study_time');
    if (savedStudyTimeJson != null) {
      _totalStudyTime = Duration(minutes: int.parse(savedStudyTimeJson));
    }


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

    // Existing load methods remain the same...
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

    // Load mục tiêu và từ đã học trong tháng
    _monthlyWordGoal = prefs.getInt('monthly_word_goal') ?? 50;
    _currentMonthLearnedWords = prefs.getInt('current_month_learned_words') ?? 0;

    // Kiểm tra và reset nếu đã sang tháng mới
    final lastUpdatedMonth = prefs.getInt('last_updated_month') ?? DateTime.now().month;
    if (lastUpdatedMonth != DateTime.now().month) {
      _currentMonthLearnedWords = 0;
      await prefs.setInt('last_updated_month', DateTime.now().month);
    }


    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    // Save study time
    await prefs.setString('total_study_time', _totalStudyTime.inMinutes.toString());

    // Existing save methods remain the same...
    await prefs.setString('learned_topics', json.encode(
        _learnedTopics.map((key, value) => MapEntry(key, value.toList()))
    ));

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

    // Lưu số bài tập đã hoàn thành
    await prefs.setInt('completed_exercises', _completedExercises);


    // Lưu mục tiêu và từ đã học trong tháng
    await prefs.setInt('monthly_word_goal', _monthlyWordGoal);
    await prefs.setInt('current_month_learned_words', _currentMonthLearnedWords);
    await prefs.setInt('last_updated_month', DateTime.now().month);
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

      updateMonthlyLearnedWords(word);
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