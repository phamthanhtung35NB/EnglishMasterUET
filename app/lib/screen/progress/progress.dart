import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/user_progress.dart';

import 'topic_learned.dart';
import 'favorite_word_screen.dart';
import 'learned_words_screen.dart';

class ProgressScreen extends StatelessWidget {
  // Mock data - trong thực tế sẽ lấy từ state management (Provider/Bloc...)
  final Map<String, dynamic> stats = {
    'exercisesCompleted': '1', // Số bài tập đã làm
    'wordsLearned': 245,
    'topicsCompleted': 8,
    'streak': 7,
    'favoriteWords': 32,
    'totalStudyTime': '45h 30m',
    'dailyGoal': '85%',
  };

  // Thêm hàm format duration
  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '$hours h ${minutes.toString().padLeft(2, '0')} m';
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = context.watch<UserProgress>();
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(context),

              // Stats Grid
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  // Từ vựng đã học
                  _buildStatCard(
                    context,
                    icon: FontAwesomeIcons.book,
                    iconColor: Colors.blue,
                    title: 'Từ vựng đã học',
                    value: '${userProgress.getTotalLearnedWords()}',
                    subtitle: 'từ vựng',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LearnedWordsScreen()), // Use the new screen
                      );
                    },
                  ),

                  // Chủ đề đã học
                  _buildStatCard(
                    context,
                    icon: FontAwesomeIcons.layerGroup,
                    iconColor: Colors.green,
                    title: 'Chủ đề đã học',
                    value: '${userProgress.getTotalLearnedTopics()}',
                    subtitle: 'chủ đề',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompletedTopicsScreen()),
                      );
                    },
                  ),

                  // Streak
                  _buildStatCard(
                    context,
                    icon: FontAwesomeIcons.trophy,
                    iconColor: Colors.amber,
                    title: 'Chuỗi ngày học',
                    value: '${userProgress.loginStreak}',
                    subtitle: 'ngày',
                  ),

                  // Card từ vựng yêu thích
                  _buildStatCard(
                    context,
                    icon: FontAwesomeIcons.heart,
                    iconColor: Colors.red,
                    title: 'Từ vựng yêu thích',
                    value: '${userProgress.getFavoriteWordsCount()}',
                    subtitle: 'từ vựng',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteWordsScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Study Time Card
              _buildWideCard(
                context,
                icon: FontAwesomeIcons.clock,
                iconColor: Colors.purple,
                title: 'Tổng thời gian học',
                value:
                    '${userProgress.totalStudyTime.inHours}h ${(userProgress.totalStudyTime.inMinutes % 60)}m',
                subtitle: 'giờ học',
              ),

              const SizedBox(height: 16),

              // Daily Goal Card
              _buildWideCard(
                context,
                icon: FontAwesomeIcons.bullseye,
                iconColor: Colors.indigo,
                title: 'Mục tiêu hôm nay',
                value: stats['dailyGoal'],
                subtitle: 'hoàn thành',
              ),
              const SizedBox(height: 16),

              // Bài tập đã làm
              _buildWideCard(
                context,
                icon: FontAwesomeIcons.checkCircle,
                iconColor: Colors.teal,
                title: 'Bài tập đã hoàn thành',
                value: stats['exercisesCompleted'] ?? '0',
                // Thêm giá trị mặc định
                subtitle: 'bài tập',
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // Widget header với thông tin người dùng
  Widget _buildUserHeader(BuildContext context) {
    final userProgress = Provider.of<UserProgress>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.blue.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Xin chào!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                userProgress.userName, // Sử dụng tên người dùng từ UserProgress
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        // Wrap với InkWell để thêm hiệu ứng nhấn
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  FaIcon(
                    icon,
                    size: 20,
                    color: iconColor,
                  ),
                ],
              ),
              Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                ),
              ],
            ),
            Spacer(),
            FaIcon(
              icon,
              size: 24,
              color: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
