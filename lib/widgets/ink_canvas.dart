import 'package:flutter/material.dart';
import '../models/latex_block.dart';
import '../services/recognition_pipeline.dart';

class InkCanvas extends StatefulWidget {
  final Function(List<List<Offset>> strokes)? onStrokeComplete;
  final Color strokeColor;
  final double strokeWidth;

  const InkCanvas({
    super.key, this.onStrokeComplete,
    this.strokeColor = Colors.white, this.strokeWidth = 2.5,
  });

  @override
  State<InkCanvas> createState() => InkCanvasState();
}

class InkCanvasState extends State<InkCanvas> {
  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];

  void _onPointerDown(PointerDownEvent e) {
    _currentStroke = [e.localPosition];
  }

  void _onPointerMove(PointerMoveEvent e) {
    setState(() => _currentStroke.add(e.localPosition));
  }

  void _onPointerUp(PointerUpEvent e) {
    _currentStroke.add(e.localPosition);
    _strokes.add(List.from(_currentStroke));
    widget.onStrokeComplete?.call([List.from(_currentStroke)]);
    _currentStroke = [];
  }

  void undo() {
    if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
  }

  void clear() => setState(() { _strokes.clear(); _currentStroke = []; });

  Future<List<LatexBlock>> recognizeAll(RecognitionPipeline pipeline) async {
    final blocks = <LatexBlock>[];
    for (final stroke in _strokes) {
      final block = await pipeline.recognize([stroke]);
      blocks.add(block);
    }
    return blocks;
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      child: CustomPaint(
        painter: _InkPainter(
          strokes: _strokes, currentStroke: _currentStroke,
          color: widget.strokeColor, width: widget.strokeWidth,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _InkPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color color;
  final double width;

  _InkPainter({
    required this.strokes, required this.currentStroke,
    required this.color, required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      _drawStroke(canvas, stroke, paint);
    }
    if (currentStroke.isNotEmpty) _drawStroke(canvas, currentStroke, paint);
  }

  void _drawStroke(Canvas canvas, List<Offset> pts, Paint paint) {
    if (pts.length == 1) {
      canvas.drawCircle(pts[0], width / 2, paint..style = PaintingStyle.fill);
      paint.style = PaintingStyle.stroke;
      return;
    }
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 1; i < pts.length; i++) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _InkPainter old) => true;
}
