import 'package:flutter/services.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import '../models/latex_block.dart';

class RecognitionResult {
  final String text;
  final double confidence;
  final BlockType type;

  RecognitionResult({
    required this.text,
    required this.confidence,
    this.type = BlockType.text,
  });
}

abstract class Recognizer {
  Future<RecognitionResult> recognize(List<List<Offset>> strokes);
}

class T1Recognizer implements Recognizer {
  static const double threshold = 0.7;
  static const String _languageCode = 'en-US';

  DigitalInkRecognizer? _recognizer;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    try {
      _recognizer = DigitalInkRecognizer(languageCode: _languageCode);
      _initialized = true;
    } on MissingPluginException {
      // ML Kit not available on this platform (tests, web, desktop)
    } catch (_) {
      // Recognizer creation failed
    }
  }

  @override
  Future<RecognitionResult> recognize(List<List<Offset>> strokes) async {
    await _ensureInitialized();

    if (_recognizer == null || strokes.isEmpty) {
      return RecognitionResult(text: '', confidence: 0.0);
    }

    try {
      final ink = Ink();
      for (final stroke in strokes) {
        if (stroke.isEmpty) continue;
        final mlStroke = Stroke();
        final startTime = DateTime.now().millisecondsSinceEpoch;
        mlStroke.points = stroke.asMap().entries.map((entry) {
          return StrokePoint(
            x: entry.value.dx,
            y: entry.value.dy,
            t: startTime + entry.key,
          );
        }).toList();
        ink.strokes.add(mlStroke);
      }

      final candidates = await _recognizer!.recognize(ink);
      if (candidates.isNotEmpty) {
        final top = candidates.first;
        return RecognitionResult(
          text: top.text,
          confidence: top.score,
        );
      }
    } on MissingPluginException {
      // Not running on a real device — return fallback text
      return RecognitionResult(
        text: _fallbackText(strokes),
        confidence: 0.3,
      );
    } catch (_) {
      // Recognition failed — return fallback text
      return RecognitionResult(
        text: _fallbackText(strokes),
        confidence: 0.3,
      );
    }

    return RecognitionResult(text: _fallbackText(strokes), confidence: 0.3);
  }

  /// Generates a basic text representation from stroke positions.
  /// Fallback when ML Kit is unavailable. Enough to verify the pipeline works.
  String _fallbackText(List<List<Offset>> strokes) {
    if (strokes.isEmpty) return '';
    final totalPoints = strokes.fold<int>(0, (sum, s) => sum + s.length);
    final firstStroke = strokes.first;
    if (firstStroke.isEmpty) return '';
    final avgX = firstStroke.map((p) => p.dx).reduce((a, b) => a + b) / firstStroke.length;
    final avgY = firstStroke.map((p) => p.dy).reduce((a, b) => a + b) / firstStroke.length;
    if (totalPoints < 5) return '.';
    if (totalPoints < 15) return 'stroke';
    return 'handwriting (${totalPoints}pts, x:${avgX.toStringAsFixed(0)}, y:${avgY.toStringAsFixed(0)})';
  }

  void dispose() {
    _recognizer?.close();
    _recognizer = null;
    _initialized = false;
  }
}
