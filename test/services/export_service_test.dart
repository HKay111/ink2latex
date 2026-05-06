import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/services/export_service.dart';
import 'package:ink2latex/models/latex_block.dart';

void main() {
  group('ExportService', () {
    test('combines blocks into LaTeX document', () {
      final blocks = [
        LatexBlock(latexCode: 'E = mc^2', plainText: '', tier: 2, confidence: 0.9),
        LatexBlock(latexCode: '\\frac{dy}{dx}', plainText: '', tier: 1, confidence: 0.95),
      ];
      final output = ExportService.toLatex(blocks);
      expect(output, contains('E = mc^2'));
      expect(output, contains('\\frac{dy}{dx}'));
      expect(output, contains('\\documentclass'));
      expect(output, contains('\\begin{document}'));
    });

    test('empty blocks produce valid skeleton', () {
      final output = ExportService.toLatex([]);
      expect(output, contains('\\documentclass'));
      expect(output, contains('\\end{document}'));
    });
  });
}
