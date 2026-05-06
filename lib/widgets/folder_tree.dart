import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/folder.dart';

class FolderTree extends StatelessWidget {
  final Function(String folderId)? onFolderSelected;
  final Function(String folderId, String noteId)? onNoteSelected;

  const FolderTree({super.key, this.onFolderSelected, this.onNoteSelected});

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final roots = storage.folders.where((f) => f.parentId == null).toList();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Text('Notebooks', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.create_new_folder, size: 20),
              onPressed: () => _createFolder(context),
            ),
          ]),
        ),
        for (final folder in roots) _FolderTile(
          folder: folder,
          storage: storage,
          depth: 0,
          onTap: () => onFolderSelected?.call(folder.id),
          onNoteTap: (noteId) => onNoteSelected?.call(folder.id, noteId),
        ),
      ],
    );
  }

  void _createFolder(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Folder'),
        content: TextField(controller: controller, autofocus: true,
          decoration: const InputDecoration(hintText: 'Course name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            final name = controller.text.trim();
            if (name.isNotEmpty) {
              context.read<StorageService>().createFolder(name);
            }
            Navigator.pop(context);
          }, child: const Text('Create')),
        ],
      ),
    );
  }
}

class _FolderTile extends StatefulWidget {
  final Folder folder;
  final StorageService storage;
  final int depth;
  final VoidCallback? onTap;
  final Function(String noteId)? onNoteTap;

  const _FolderTile({
    required this.folder, required this.storage,
    required this.depth, this.onTap, this.onNoteTap,
  });

  @override
  State<_FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<_FolderTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final children = widget.storage.getChildFolders(widget.folder.id);
    final notes = widget.storage.getNotes(widget.folder.id);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + widget.depth * 16.0),
          leading: const Icon(Icons.folder, size: 20),
          title: Text(widget.folder.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${notes.length}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () => setState(() => _expanded = !_expanded),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          onTap: widget.onTap,
        ),
        if (_expanded) ...[
          Padding(
            padding: EdgeInsets.only(left: 32.0 + widget.depth * 16.0),
            child: ListTile(
              leading: const Icon(Icons.note_add, size: 18),
              title: const Text('New Note',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              dense: true,
              onTap: widget.onTap,
            ),
          ),
          for (final note in notes)
            ListTile(
              contentPadding: EdgeInsets.only(left: 32.0 + widget.depth * 16.0),
              leading: const Icon(Icons.note, size: 18),
              title: Text(note.title, style: const TextStyle(fontSize: 14)),
              dense: true,
              onTap: () => widget.onNoteTap?.call(note.id),
            ),
          for (final child in children)
            _FolderTile(
              folder: child,
              storage: widget.storage,
              depth: widget.depth + 1,
              onTap: widget.onTap,
              onNoteTap: widget.onNoteTap,
            ),
        ],
      ],
    );
  }
}