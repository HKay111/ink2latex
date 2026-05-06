import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/models/folder.dart';

void main() {
  group('Folder', () {
    test('creates folder with required fields', () {
      final f = Folder(name: 'Microeconomics');
      expect(f.name, 'Microeconomics');
      expect(f.parentId, isNull);
      expect(f.id, isNotNull);
    });
    test('creates nested folder with parentId', () {
      final parent = Folder(name: 'Econ');
      final child = Folder(name: 'Micro', parentId: parent.id);
      expect(child.parentId, parent.id);
    });
    test('two folders have different ids', () {
      expect(Folder(name: 'A').id, isNot(Folder(name: 'B').id));
    });
  });
}