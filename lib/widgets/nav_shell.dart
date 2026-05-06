import 'package:flutter/material.dart';
import 'folder_tree.dart';
import 'note_editor.dart';

class NavShell extends StatefulWidget {
  const NavShell({super.key});

  @override
  State<NavShell> createState() => _NavShellState();
}

class _NavShellState extends State<NavShell> {
  String? _selectedFolderId;
  String? _selectedNoteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ink2LaTeX'), actions: [
        if (_selectedFolderId != null)
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: 'New Note',
            onPressed: () => setState(() => _selectedNoteId = null),
          ),
      ]),
      drawer: Drawer(child: FolderTree(onFolderSelected: (id) {
        setState(() { _selectedFolderId = id; _selectedNoteId = null; });
        Navigator.pop(context);
      })),
      body: _selectedFolderId != null
          ? NoteEditor(noteId: _selectedNoteId, folderId: _selectedFolderId!)
          : const Center(child: Text('Create or select a folder to start')),
    );
  }
}