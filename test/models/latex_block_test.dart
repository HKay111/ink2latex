import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/models/latex_block.dart';

void main() {
  group('LatexBlock', () {
    test('creates block with required fields', () {
      final b = LatexBlock(
        latexCode: '\\frac{dy}{dx} = 2x',
        plainText: 'dy/dx = 2x',
        tier: 1, confidence: 0.95,
      );
      expect(b.latexCode, contains('frac'));
      expect(b.tier, 1);
      expect(b.type, BlockType.math);
    });
    test('infers text type for plain strings', () {
      final b = LatexBlock(
        latexCode: 'hello world', plainText: 'hello world',
        tier: 1, confidence: 0.9,
      );
      expect(b.type, BlockType.text);
    });
    test('allows explicit diagram type', () {
      final b = LatexBlock(
        latexCode: '...', plainText: '...',
        tier: 2, confidence: 0.7, type: BlockType.diagram,
      );
      expect(b.type, BlockType.diagram);
    });
  });
}