import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../models/folder.dart';

class FolderTree extends StatelessWidget {
  final Function(String folderId)? onFolderSelected;

  const FolderTree({super.key, this.onFolderSelected});

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

class _FolderTile extends StatelessWidget {
  final Folder folder;
  final StorageService storage;
  final int depth;
  final VoidCallback? onTap;

  const _FolderTile({
    required this.folder, required this.storage,
    required this.depth, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final children = storage.getChildFolders(folder.id);
    final notes = storage.getNotes(folder.id);

    return ExpansionTile(
      tilePadding: EdgeInsets.only(left: 16.0 + depth * 16.0),
      title: Row(children: [
        const Icon(Icons.folder, size: 20),
        const SizedBox(width: 8),
        Text(folder.name),
        const Spacer(),
        Text('${notes.length}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ]),
      children: [
        for (final note in notes)
          ListTile(
            contentPadding: EdgeInsets.only(left: 32.0 + depth * 16.0),
            leading: const Icon(Icons.note, size: 18),
            title: Text(note.title, style: const TextStyle(fontSize: 14)),
            dense: true,
            onTap: onTap,
          ),
        for (final child in children)
          _FolderTile(folder: child, storage: storage, depth: depth + 1, onTap: onTap),
      ],
    );
  }
}