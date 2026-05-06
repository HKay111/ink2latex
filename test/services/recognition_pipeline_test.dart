import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/services/t1_recognizer.dart';
import 'package:ink2latex/services/recognition_pipeline.dart';
import 'package:ink2latex/models/latex_block.dart';

class FakeRecognizer implements Recognizer {
  final RecognitionResult result;
  int callCount = 0;
  FakeRecognizer(this.result);

  @override
  Future<RecognitionResult> recognize(List<List<Offset>> strokes) async {
    callCount++;
    return result;
  }
}

void main() {
  group('T1Recognizer', () {
    test('threshold is 0.7', () => expect(T1Recognizer.threshold, 0.7));
    test('recognize returns RecognitionResult', () async {
      final r = T1Recognizer();
      final result = await r.recognize([]);
      expect(result, isA<RecognitionResult>());
      expect(result.confidence, 0.0);
    });
  });

  group('RecognitionPipeline', () {
    final strokes = [[const Offset(10, 20), const Offset(30, 40)]];

    test('uses T1 when confident', () async {
      final t1 = FakeRecognizer(RecognitionResult(text: 'hello', confidence: 0.9));
      final t2 = FakeRecognizer(RecognitionResult(text: 'no', confidence: 0.0));
      final p = RecognitionPipeline(t1: t1, t2: t2);
      final block = await p.recognize(strokes);
      expect(block.latexCode, 'hello');
      expect(block.tier, 1);
      expect(t2.callCount, 0);
    });

    test('escalates to T2 when T1 low', () async {
      final t1 = FakeRecognizer(RecognitionResult(text: '?', confidence: 0.3));
      final t2 = FakeRecognizer(RecognitionResult(text: '\\frac{a}{b}', confidence: 0.8));
      final p = RecognitionPipeline(t1: t1, t2: t2);
      final block = await p.recognize(strokes);
      expect(block.tier, 2);
      expect(t1.callCount, 1);
      expect(t2.callCount, 1);
    });

    test('escalates to T3 when both low', () async {
      final t1 = FakeRecognizer(RecognitionResult(text: '?', confidence: 0.2));
      final t2 = FakeRecognizer(RecognitionResult(text: '?', confidence: 0.3));
      final t3 = FakeRecognizer(RecognitionResult(text: '\\int x dx', confidence: 0.9));
      final p = RecognitionPipeline(t1: t1, t2: t2, t3: t3);
      final block = await p.recognize(strokes);
      expect(block.tier, 3);
      expect(t1.callCount, 1);
      expect(t2.callCount, 1);
      expect(t3.callCount, 1);
    });

    test('empty strokes returns empty block', () async {
      final t1 = FakeRecognizer(RecognitionResult(text: 'x', confidence: 1.0));
      final p = RecognitionPipeline(t1: t1);
      final block = await p.recognize([]);
      expect(block.latexCode, '');
      expect(block.confidence, 0.0);
    });
  });
}