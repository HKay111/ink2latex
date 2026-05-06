import 'package:flutter/material.dart';

class NoteToolbar extends StatelessWidget {
  final VoidCallback? onUndo;
  final VoidCallback? onClear;
  final VoidCallback? onConvert;

  const NoteToolbar({super.key, this.onUndo, this.onClear, this.onConvert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(children: [
        IconButton(icon: const Icon(Icons.undo), tooltip: 'Undo', onPressed: onUndo),
        IconButton(icon: const Icon(Icons.brush), tooltip: 'Pen', onPressed: () {}),
        IconButton(icon: const Icon(Icons.cleaning_services), tooltip: 'Eraser', onPressed: () {}),
        const Spacer(),
        IconButton(icon: const Icon(Icons.auto_fix_high), tooltip: 'Convert All', onPressed: onConvert),
        IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'Clear Page', onPressed: onClear),
      ]),
    );
  }
}