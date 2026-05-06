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
  bool _initFailed = false;

  Future<void> _ensureInitialized() async {
    if (_initialized || _initFailed) return;

    try {
      // Download the EN language model if not already on device
      final modelManager = DigitalInkRecognizerModelManager();
      final downloaded = await modelManager.isModelDownloaded(_languageCode);
      if (!downloaded) {
        await modelManager.downloadModel(_languageCode);
      }

      _recognizer = DigitalInkRecognizer(languageCode: _languageCode);
      _initialized = true;
    } on MissingPluginException {
      _initFailed = true;
    } catch (e) {
      _initFailed = true;
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
    } catch (_) {}

    return RecognitionResult(text: '', confidence: 0.0);
  }

  void dispose() {
    _recognizer?.close();
    _recognizer = null;
    _initialized = false;
    _initFailed = false;
  }
}
