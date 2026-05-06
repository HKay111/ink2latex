import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/services/t1_recognizer.dart';

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
}