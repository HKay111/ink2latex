import 'package:flutter/services.dart';
import '../models/latex_block.dart';
import 't1_recognizer.dart';

class T2Recognizer implements Recognizer {
  static const double threshold = 0.5;
  static const _channel = MethodChannel('com.ink2latex/gemma');

  @override
  Future<RecognitionResult> recognize(List<List<Offset>> strokes) async {
    if (strokes.isEmpty) return RecognitionResult(text: '', confidence: 0.0);
    try {
      final data = strokes.where((s) => s.isNotEmpty)
          .map((s) => s.map((p) => {'x': p.dx, 'y': p.dy}).toList()).toList();
      final result = await _channel.invokeMethod('recognize', {'strokes': data});
      if (result is Map) {
        return RecognitionResult(
          text: result['text'] as String? ?? '',
          confidence: (result['confidence'] as num?)?.toDouble() ?? 0.0,
          type: _parseType(result['type'] as String?),
        );
      }
    } on MissingPluginException { /* no Gemma available */ }
    return RecognitionResult(text: '', confidence: 0.0);
  }

  BlockType _parseType(String? type) {
    switch (type) {
      case 'math': return BlockType.math;
      case 'diagram': return BlockType.diagram;
      default: return BlockType.text;
    }
  }
}
