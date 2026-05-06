import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/models/note.dart';

void main() {
  group('Note', () {
    test('creates note with required fields', () {
      final n = Note(title: 'Chapter 3', folderId: 'f1');
      expect(n.title, 'Chapter 3');
      expect(n.folderId, 'f1');
      expect(n.pages.length, 1);
      expect(n.createdAt, isNotNull);
      expect(n.updatedAt, isNotNull);
    });
    test('adds pages to note', () {
      final n = Note(title: 'N', folderId: 'f1');
      final updated = n.addPage();
      expect(updated.pages.length, 2);
    });
  });
}