enum BlockType { text, math, diagram }

class LatexBlock {
  final String id;
  final String latexCode;
  final String plainText;
  final int tier;
  final double confidence;
  final BlockType type;

  LatexBlock({
    String? id,
    required this.latexCode,
    required this.plainText,
    required this.tier,
    required this.confidence,
    BlockType? type,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        type = type ?? _inferType(latexCode);

  static BlockType _inferType(String latex) {
    if (latex.contains('\\') || latex.contains('^') || latex.contains('_')) {
      return BlockType.math;
    }
    return BlockType.text;
  }
}