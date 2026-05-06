import 'dart:ui';
import 'latex_block.dart';
import '../utils/ink_serializer.dart';

class PageModel {
  final String id;
  final List<dynamic> inkData;
  final List<LatexBlock> blocks;

  PageModel({
    String? id,
    List<dynamic>? inkData,
    List<LatexBlock>? blocks,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        inkData = inkData ?? [],
        blocks = blocks ?? [];

  PageModel copyWith({List<dynamic>? inkData, List<LatexBlock>? blocks}) {
    return PageModel(
      id: id,
      inkData: inkData ?? this.inkData,
      blocks: blocks ?? this.blocks,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'inkData': inkData is List<List<Offset>>
        ? InkSerializer.strokesToJson(inkData as List<List<Offset>>)
        : [],
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
    id: json['id'] as String,
    inkData: (json['inkData'] as List).isEmpty
        ? []
        : InkSerializer.strokesFromJson(json['inkData'] as List),
    blocks: (json['blocks'] as List)
        .map((b) => LatexBlock.fromJson(b as Map<String, dynamic>))
        .toList(),
  );
}