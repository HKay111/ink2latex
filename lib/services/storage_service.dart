import '../models/folder.dart';
import '../models/note.dart';

class StorageService {
  final List<Folder> _folders = [];
  final List<Note> _notes = [];

  StorageService();
  StorageService.inMemory();

  List<Folder> get folders => List.unmodifiable(_folders);

  Folder createFolder(String name, {String? parentId}) {
    final f = Folder(name: name, parentId: parentId);
    _folders.add(f);
    return f;
  }

  List<Folder> getChildFolders(String parentId) {
    return _folders.where((f) => f.parentId == parentId).toList();
  }

  List<Note> getNotes(String folderId) {
    return _notes.where((n) => n.folderId == folderId).toList();
  }

  Note createNote(String title, String folderId) {
    final n = Note(title: title, folderId: folderId);
    _notes.add(n);
    return n;
  }

  Note? updateNote(String noteId, String newTitle) {
    final i = _notes.indexWhere((n) => n.id == noteId);
    if (i == -1) return null;
    final old = _notes[i];
    final updated = Note(
      id: old.id, title: newTitle, folderId: old.folderId,
      pages: old.pages, createdAt: old.createdAt, updatedAt: DateTime.now(),
    );
    _notes[i] = updated;
    return updated;
  }

  bool deleteNote(String noteId) {
    final i = _notes.indexWhere((n) => n.id == noteId);
    if (i == -1) return false;
    _notes.removeAt(i);
    return true;
  }
}