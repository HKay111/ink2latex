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

  Map<String, dynamic> toJson() => {
    'id': id,
    'latexCode': latexCode,
    'plainText': plainText,
    'tier': tier,
    'confidence': confidence,
    'type': type.name,
  };

  factory LatexBlock.fromJson(Map<String, dynamic> json) => LatexBlock(
    id: json['id'] as String,
    latexCode: json['latexCode'] as String,
    plainText: json['plainText'] as String,
    tier: json['tier'] as int,
    confidence: (json['confidence'] as num).toDouble(),
    type: BlockType.values.byName(json['type'] as String),
  );
}