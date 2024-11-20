import 'package:flutter/material.dart';

class progressScreen extends StatelessWidget {
  const progressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài tập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chương trình học',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressCard('Phần 1 Nối từ', 100, true),
            _buildProgressCard('Phần 2 Nghe ', 100, true),
            _buildProgressCard('Phần 3 Kho truyện', 92, false),
            _buildProgressCard('Phần 4 Phát âm', 92, false),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Trở về màn hình trước
              },
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị từng mục tiến độ
  Widget _buildProgressCard(String title, int progress, bool completed) {
    return Card(
      child: ListTile(
        leading: Icon(
          completed ? Icons.check_circle : Icons.access_time,
          color: completed ? Colors.green : Colors.orange,
        ),
        title: Text(title),
        subtitle: LinearProgressIndicator(
          value: progress / 100,
          color: completed ? Colors.green : Colors.orange,
          backgroundColor: Colors.grey[300],
        ),
        trailing: Text('$progress%'),
      ),
    );
  }
}
