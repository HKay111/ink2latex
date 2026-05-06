import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/folder.dart';
import '../models/note.dart';

class StorageService extends ChangeNotifier {
  final List<Folder> _folders = [];
  final List<Note> _notes = [];
  bool _loaded = false;

  StorageService() {
    // Load is deferred to init() — called after runApp() so notifyListeners
    // doesn't fire during widget tree construction.
  }

  StorageService.inMemory() {
    _loaded = true;
  }

  /// Load persisted data from disk. Call after runApp().
  Future<void> init() async {
    await _loadFromDisk();
    if (_loaded) notifyListeners();
  }

  List<Folder> get folders => List.unmodifiable(_folders);

  // ---- Folder CRUD ----

  Folder createFolder(String name, {String? parentId}) {
    final f = Folder(name: name, parentId: parentId);
    _folders.add(f);
    _saveToDisk();
    notifyListeners();
    return f;
  }

  List<Folder> getChildFolders(String parentId) {
    return _folders.where((f) => f.parentId == parentId).toList();
  }

  // ---- Note CRUD ----

  List<Note> getNotes(String folderId) {
    return _notes.where((n) => n.folderId == folderId).toList();
  }

  Note createNote(String title, String folderId) {
    final n = Note(title: title, folderId: folderId);
    _notes.add(n);
    _saveToDisk();
    notifyListeners();
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
    _saveToDisk();
    notifyListeners();
    return updated;
  }

  bool deleteNote(String noteId) {
    final i = _notes.indexWhere((n) => n.id == noteId);
    if (i == -1) return false;
    _notes.removeAt(i);
    _saveToDisk();
    notifyListeners();
    return true;
  }

  // ---- Persistence ----

  Future<String> get _dataPath async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/ink2latex_data.json';
  }

  Future<void> _saveToDisk() async {
    if (!_loaded) return;
    try {
      final path = await _dataPath;
      final data = {
        'folders': _folders.map((f) => {
          'id': f.id,
          'name': f.name,
          'parentId': f.parentId,
        }).toList(),
        'notes': _notes.map((n) => {
          'id': n.id,
          'title': n.title,
          'folderId': n.folderId,
        }).toList(),
      };
      await File(path).writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  Future<void> _loadFromDisk() async {
    try {
      final path = await _dataPath;
      final file = File(path);
      if (!await file.exists()) {
        _loaded = true;
        return;
      }
      final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

      for (final f in (data['folders'] as List? ?? [])) {
        _folders.add(Folder(
          id: f['id'] as String,
          name: f['name'] as String,
          parentId: f['parentId'] as String?,
        ));
      }

      for (final n in (data['notes'] as List? ?? [])) {
        _notes.add(Note(
          id: n['id'] as String,
          title: n['title'] as String,
          folderId: n['folderId'] as String,
        ));
      }

      _loaded = true;
      notifyListeners();
    } catch (_) {
      _loaded = true;
    }
  }
}
