import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImprovedFillInTheBlankScreen extends StatefulWidget {
  const ImprovedFillInTheBlankScreen({Key? key}) : super(key: key);

  @override
  _ImprovedFillInTheBlankScreenState createState() => _ImprovedFillInTheBlankScreenState();
}

class _ImprovedFillInTheBlankScreenState extends State<ImprovedFillInTheBlankScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  // Mở rộng danh sách từ để tăng tính linh hoạt
  final Map<int, List<String>> correctAnswers = {
    0: ["study", "read", "learn", "practice"],
    1: ["english", "language", "grammar", "skills"]
  };

  String _feedbackMessage = "Hãy điền từ phù hợp vào chỗ trống";
  Color _feedbackColor = Colors.grey;
  bool _isCorrect = false;
  bool _showHint = false;
  int _attempts = 0;

  void _checkAnswers() {
    String answer1 = _controller1.text.trim().toLowerCase();
    String answer2 = _controller2.text.trim().toLowerCase();

    setState(() {
      _attempts++;

      bool isFirstCorrect = correctAnswers[0]!.contains(answer1);
      bool isSecondCorrect = correctAnswers[1]!.contains(answer2);

      if (isFirstCorrect && isSecondCorrect) {
        _feedbackMessage = "🌟 Tuyệt vời! Bạn đã trả lời đúng!";
        _feedbackColor = Colors.green.shade700;
        _isCorrect = true;
        _showHint = false;
      } else {
        if (_attempts >= 2) {
          _showHint = true;
          _feedbackMessage = "⚠️ Chưa đúng. Hãy thử lại!";
        } else {
          _feedbackMessage = "⚠️ Câu trả lời chưa chính xác. Bạn còn ${3 - _attempts} lượt!";
        }
        _feedbackColor = Colors.red.shade700;
        _isCorrect = false;
      }
    });
  }

  void _resetAnswer() {
    setState(() {
      _controller1.clear();
      _controller2.clear();
      _feedbackMessage = "Hãy điền từ phù hợp vào chỗ trống";
      _isCorrect = false;
      _showHint = false;
      _attempts = 0;
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        title: Text(
          "Điền Từ Tiếng Anh",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Điền Từ Thích Hợp",
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: "Tôi thích "),
                          TextSpan(
                            text: "_____ ",
                            style: TextStyle(
                              color: Colors.deepPurple.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: "và học "),
                          TextSpan(
                            text: "_____ ",
                            style: TextStyle(
                              color: Colors.deepPurple.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(text: "mỗi ngày."),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller1,
                          decoration: InputDecoration(
                            hintText: "Từ thứ nhất",
                            fillColor: Colors.purple.shade50,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _controller2,
                          decoration: InputDecoration(
                            hintText: "Từ thứ hai",
                            fillColor: Colors.purple.shade50,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _checkAnswers,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Kiểm Tra",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (_isCorrect)
                        ElevatedButton(
                          onPressed: _resetAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Làm Lại",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      _feedbackMessage,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        color: _feedbackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_showHint)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "💡 Gợi ý: Hãy nghĩ về các từ liên quan đến việc học và ngôn ngữ!",
                          style: GoogleFonts.openSans(
                            color: Colors.brown.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}