import 'package:translator/translator.dart';

class TranslateController {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateText(String text, String targetLang) async {
    try {
      final translation = await _translator.translate(text, to: targetLang);
      return translation.text;
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}