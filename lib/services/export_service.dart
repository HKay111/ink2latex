import 'package:flutter/services.dart';
import '../models/latex_block.dart';

class ExportService {
  static String toLatex(List<LatexBlock> blocks) {
    final buffer = StringBuffer();
    buffer.writeln('\\documentclass{article}');
    buffer.writeln('\\usepackage{amsmath}');
    buffer.writeln('\\begin{document}');
    buffer.writeln();
    for (final block in blocks) {
      if (block.type == BlockType.math) {
        buffer.writeln('\\[${block.latexCode}\\]');
      } else {
        buffer.writeln(block.latexCode);
      }
      buffer.writeln();
    }
    buffer.writeln('\\end{document}');
    return buffer.toString();
  }

  static Future<void> copyToClipboard(List<LatexBlock> blocks) async {
    final text = blocks.map((b) => b.latexCode).join('\n\n');
    await Clipboard.setData(ClipboardData(text: text));
  }
}
