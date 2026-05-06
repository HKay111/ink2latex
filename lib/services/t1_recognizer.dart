import 'dart:ui';
import '../models/latex_block.dart';

class RecognitionResult {
  final String text;
  final double confidence;
  final BlockType type;

  RecognitionResult({
    required this.text, required this.confidence,
    this.type = BlockType.text,
  });
}

abstract class Recognizer {
  Future<RecognitionResult> recognize(List<List<Offset>> strokes);
}

class T1Recognizer implements Recognizer {
  static const double threshold = 0.7;

  @override
  Future<RecognitionResult> recognize(List<List<Offset>> strokes) async {
    // Real: calls google_mlkit_digital_ink_recognition
    // Stub: returns low confidence so T2 is always tried during dev
    return RecognitionResult(text: '', confidence: 0.0);
  }
}