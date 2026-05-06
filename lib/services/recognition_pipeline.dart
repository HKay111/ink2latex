import 'dart:ui';
import '../models/latex_block.dart';
import 't1_recognizer.dart';
import 't2_recognizer.dart';
import 't3_recognizer.dart';

class RecognitionPipeline {
  final Recognizer t1;
  final Recognizer t2;
  final Recognizer? t3;

  RecognitionPipeline({Recognizer? t1, Recognizer? t2, this.t3})
      : t1 = t1 ?? T1Recognizer(),
        t2 = t2 ?? T2Recognizer();

  Future<LatexBlock> recognize(List<List<Offset>> strokes) async {
    if (strokes.isEmpty || strokes.every((s) => s.isEmpty)) {
      return LatexBlock(latexCode: '', plainText: '', tier: 1, confidence: 0.0);
    }

    final r1 = await t1.recognize(strokes);
    if (r1.confidence >= T1Recognizer.threshold) {
      return LatexBlock(
        latexCode: r1.text,
        plainText: r1.text,
        tier: 1,
        confidence: r1.confidence,
        type: r1.type,
      );
    }

    final r2 = await t2.recognize(strokes);
    if (r2.confidence >= T2Recognizer.threshold) {
      return LatexBlock(
        latexCode: r2.text,
        plainText: r2.text,
        tier: 2,
        confidence: r2.confidence,
        type: r2.type,
      );
    }

    if (t3 != null) {
      final r3 = await t3!.recognize(strokes);
      if (r3.confidence > 0.0) {
        return LatexBlock(
          latexCode: r3.text,
          plainText: r3.text,
          tier: 3,
          confidence: r3.confidence,
          type: r3.type,
        );
      }
    }

    // All tiers failed — return a placeholder so the user knows something happened
    final bestText = r2.text.isNotEmpty ? r2.text : r1.text;
    return LatexBlock(
      latexCode: bestText.isNotEmpty ? bestText : '[unrecognized]',
      plainText: bestText.isNotEmpty ? bestText : '[unrecognized]',
      tier: bestText.isNotEmpty ? 2 : 1,
      confidence: r2.confidence > 0 ? r2.confidence : 0.0,
      type: BlockType.text,
    );
  }

  void dispose() {
    if (t1 is T1Recognizer) (t1 as T1Recognizer).dispose();
    if (t3 is T3Recognizer) (t3 as T3Recognizer).dispose();
  }
}