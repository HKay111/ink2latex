import 'package:flutter/material.dart';

class PageNavigator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onAdd;

  const PageNavigator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onPrev, this.onNext, this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: currentPage > 0 ? onPrev : null),
        Text('${currentPage + 1} / $totalPages'),
        IconButton(icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages - 1 ? onNext : null),
        const SizedBox(width: 16),
        IconButton(icon: const Icon(Icons.add), tooltip: 'Add page', onPressed: onAdd),
      ]),
    );
  }
}