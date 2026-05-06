import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/utils/ink_serializer.dart';
import 'dart:ui';

void main() {
  group('InkSerializer', () {
    test('serializes single stroke to JSON', () {
      final pts = [const Offset(10, 20), const Offset(30, 40)];
      final json = InkSerializer.strokeToJson(pts);
      final s = json['points'] as List;
      expect(s.length, 2);
      expect(s[0]['x'], 10.0);
    });
    test('round-trips stroke through JSON', () {
      final orig = [const Offset(50, 60), const Offset(70, 80)];
      final json = InkSerializer.strokeToJson(orig);
      final restored = InkSerializer.strokeFromJson(json);
      expect(restored.length, 2);
      expect(restored[0].dx, 50.0);
    });
    test('serializes multiple strokes', () {
      final strokes = [
        [const Offset(0, 0), const Offset(10, 10)],
        [const Offset(20, 20)],
      ];
      final json = InkSerializer.strokesToJson(strokes);
      expect(json.length, 2);
      final restored = InkSerializer.strokesFromJson(json);
      expect(restored.length, 2);
      expect(restored[1].length, 1);
    });
    test('empty input returns empty', () {
      expect(InkSerializer.strokesToJson([]), isEmpty);
      expect(InkSerializer.strokesFromJson([]), isEmpty);
    });
  });
}
