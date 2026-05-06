import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import '../models/latex_block.dart';
import 't1_recognizer.dart';

class T3Recognizer implements Recognizer {
  final String apiKey;
  final http.Client client;

  T3Recognizer({required this.apiKey, http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<RecognitionResult> recognize(List<List<Offset>> strokes) async {
    if (apiKey.isEmpty || strokes.isEmpty) {
      return RecognitionResult(text: '', confidence: 0.0);
    }
    try {
      final uri = Uri.parse('https://api.mathpix.com/v3/text');
      final response = await client.post(uri, headers: {
        'app_id': apiKey.split(':').first,
        'app_key': apiKey.split(':').last,
        'Content-Type': 'application/json',
      }, body: jsonEncode({
        'src': 'ink',
        'strokes': {
          'strokes': strokes.map((s) => {
            'x': s.map((p) => p.dx).toList(),
            'y': s.map((p) => p.dy).toList(),
          }).toList(),
        },
      }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return RecognitionResult(
          text: (data['latex_styled'] as String?) ?? (data['text'] as String?) ?? '',
          confidence: (data['confidence'] as num?)?.toDouble() ?? 0.0,
          type: BlockType.math,
        );
      }
    } catch (_) {}
    return RecognitionResult(text: '', confidence: 0.0);
  }

  void dispose() => client.close();
}
