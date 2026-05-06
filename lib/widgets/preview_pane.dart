import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../models/latex_block.dart';
import '../services/export_service.dart';

class PreviewPane extends StatelessWidget {
  final List<LatexBlock> blocks;

  const PreviewPane({super.key, required this.blocks});

  @override
  Widget build(BuildContext context) {
    if (blocks.isEmpty) {
      return const Center(child: Text('Write something to see the preview'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Recognition', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy LaTeX',
              onPressed: () => ExportService.copyToClipboard(blocks),
            ),
            IconButton(
              icon: const Icon(Icons.code),
              tooltip: 'View LaTeX source',
              onPressed: () => _showSource(context),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        _tierBadge(block.tier),
                        const SizedBox(width: 8),
                        Text('${(block.confidence * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 11)),
                      ]),
                      const SizedBox(height: 8),
                      if (block.type == BlockType.math)
                        Math.tex(block.latexCode, mathStyle: MathStyle.display)
                      else
                        Text(block.latexCode),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _tierBadge(int tier) {
    final colors = [Colors.green, Colors.orange, Colors.red];
    final labels = ['T1', 'T2', 'T3'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors[tier - 1], borderRadius: BorderRadius.circular(4),
      ),
      child: Text(labels[tier - 1], style: const TextStyle(fontSize: 10)),
    );
  }

  void _showSource(BuildContext context) {
    final code = blocks.map((b) => b.latexCode).join('\n\n');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('LaTeX Source'),
        content: SingleChildScrollView(child: SelectableText(code)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }
}
