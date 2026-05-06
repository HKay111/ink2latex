import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/services/storage_service.dart';

void main() {
  late StorageService storage;
  setUp(() => storage = StorageService.inMemory());

  group('StorageService', () {
    test('starts empty', () => expect(storage.folders, isEmpty));
    test('creates folder', () {
      final f = storage.createFolder('Econ');
      expect(f.name, 'Econ');
      expect(storage.folders.length, 1);
    });
    test('nested folders', () {
      final p = storage.createFolder('Econ');
      final c = storage.createFolder('Micro', parentId: p.id);
      expect(c.parentId, p.id);
      expect(storage.getChildFolders(p.id).length, 1);
    });
    test('getChildFolders returns empty for unknown', () {
      expect(storage.getChildFolders('nope'), isEmpty);
    });
    test('creates note', () {
      final f = storage.createFolder('Math');
      final n = storage.createNote('Derivatives', f.id);
      expect(n.title, 'Derivatives');
      expect(storage.getNotes(f.id).length, 1);
    });
    test('getNotes empty for unknown', () {
      expect(storage.getNotes('nope'), isEmpty);
    });
    test('updates note title', () {
      final f = storage.createFolder('Phys');
      final n = storage.createNote('Kinematics', f.id);
      final u = storage.updateNote(n.id, 'Dynamics');
      expect(u!.title, 'Dynamics');
    });
    test('updateNote null for unknown', () {
      expect(storage.updateNote('nope', 'X'), isNull);
    });
    test('deletes note', () {
      final f = storage.createFolder('Chem');
      final n = storage.createNote('Bonds', f.id);
      expect(storage.deleteNote(n.id), true);
      expect(storage.getNotes(f.id), isEmpty);
    });
    test('deleteNote false for unknown', () {
      expect(storage.deleteNote('nope'), false);
    });
  });
}