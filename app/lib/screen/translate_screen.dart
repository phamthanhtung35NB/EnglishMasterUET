import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../controller/translate_controller.dart';

class TranslateScreen extends StatefulWidget {
  @override
  _TranslateScreenState createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TranslateController _controller = TranslateController();
  final TextEditingController _textController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();

  String _translatedText = '';
  String _targetLang = 'en';
  bool _isTranslating = false;
  bool _isSpeaking = false;

  final List<Map<String, String>> _languageOptions = [
    {'code': 'en', 'name': 'Tiếng Anh', 'ttsCode': 'en-US'},
    {'code': 'vi', 'name': 'Tiếng Việt', 'ttsCode': 'vi-VN'},
    {'code': 'fr', 'name': 'Tiếng Pháp', 'ttsCode': 'fr-FR'},
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage(_languageOptions[0]['ttsCode']!);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);

    _flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isSpeaking = false;
      });
      _showErrorDialog('Lỗi phát âm: $msg');
    });
  }

  void _speak() async {
    if (_translatedText.isNotEmpty) {
      // Tìm mã ngôn ngữ TTS phù hợp
      var selectedLang = _languageOptions.firstWhere(
          (lang) => lang['code'] == _targetLang,
          orElse: () => _languageOptions[0]);

      await _flutterTts.setLanguage(selectedLang['ttsCode']!);

      var result = await _flutterTts.speak(_translatedText);
      if (result == 1) {
        setState(() {
          _isSpeaking = true;
        });
      }
    }
  }

  void _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Thông báo'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Đóng'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _translate() async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      setState(() {
        _isTranslating = true;
      });

      try {
        final translated = await _controller.translateText(text, _targetLang);
        setState(() {
          _translatedText = translated;
          _isTranslating = false;
        });
      } catch (e) {
        setState(() {
          _translatedText = 'Lỗi dịch thuật. Vui lòng thử lại.';
          _isTranslating = false;
        });
      }
    }
  }

  void _clearText() {
    _textController.clear();
    setState(() {
      _translatedText = '';
    });
  }

  void _copyTranslatedText() {
    if (_translatedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _translatedText));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã sao chép kết quả dịch')),
      );
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Khung nhập văn bản (giữ nguyên như trước)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ],
              ),
              child: TextField(
                controller: _textController,
                cursorColor: Colors.black,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Nhập văn bản để dịch...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                  suffixIcon: _textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: _clearText,
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),

            const SizedBox(height: 16),

            // Các nút lựa chọn ngôn ngữ (giữ nguyên như trước)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _languageOptions.map((lang) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(lang['name']!),
                      selected: _targetLang == lang['code'],
                      onSelected: (bool selected) {
                        setState(() {
                          _targetLang = lang['code']!;
                        });
                        _translate();
                      },
                      selectedColor: Colors.blue[100],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Nút dịch (giữ nguyên như trước)
            ElevatedButton(
              onPressed: _textController.text.isNotEmpty && !_isTranslating
                  ? _translate
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade200,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: _isTranslating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Dịch',
                      style: TextStyle(
                          fontSize: 16,
                          color: _textController.text.isNotEmpty
                              ? Colors.black
                              : Colors.grey, // Màu chữ khi có văn bản
                          fontWeight: FontWeight.bold),
                    ),
            ),

            const SizedBox(height: 16),

            // Kết quả dịch thuật
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Kết quả dịch',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Row(
                        children: [
                          // Nút sao chép
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: _copyTranslatedText,
                            tooltip: 'Sao chép',
                          ),
                          // Nút phát âm
                          IconButton(
                            icon: _isSpeaking
                                ? const Icon(Icons.stop, color: Colors.red)
                                : const Icon(Icons.volume_up),
                            onPressed: _isSpeaking ? _stopSpeaking : _speak,
                            tooltip: _isSpeaking ? 'Dừng' : 'Phát âm',
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _translatedText.isEmpty
                        ? 'Kết quả dịch sẽ hiển thị ở đây'
                        : _translatedText,
                    style: TextStyle(
                      color:
                          _translatedText.isEmpty ? Colors.grey : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
