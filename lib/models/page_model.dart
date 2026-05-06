import 'latex_block.dart';

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
}