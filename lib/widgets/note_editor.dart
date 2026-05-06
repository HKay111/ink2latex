import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../models/latex_block.dart';
import '../services/storage_service.dart';
import '../services/recognition_pipeline.dart';
import '../services/t3_recognizer.dart';
import '../config.dart';
import 'ink_canvas.dart';
import 'toolbar.dart';
import 'page_navigator.dart';
import 'preview_pane.dart';

class NoteEditor extends StatefulWidget {
  final String? noteId;
  final String folderId;

  const NoteEditor({super.key, this.noteId, required this.folderId});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late Note _note;
  int _currentPageIndex = 0;
  final _pipeline = RecognitionPipeline(
    t3: AppConfig.isMathpixEnabled
        ? T3Recognizer(apiKey: AppConfig.mathpixApiKey)
        : null,
  );
  final _blocksNotifier = ValueNotifier<List<LatexBlock>>([]);
  final GlobalKey<InkCanvasState> _canvasKey = GlobalKey();
  int _phoneTabIndex = 0;

  @override
  void initState() {
    super.initState();
    final storage = context.read<StorageService>();
    if (widget.noteId != null) {
      final notes = storage.getNotes(widget.folderId);
      _note = notes.firstWhere((n) => n.id == widget.noteId);
    } else {
      _note = storage.createNote('Untitled Note', widget.folderId);
    }
  }

  @override
  void dispose() {
    _blocksNotifier.dispose();
    super.dispose();
  }

  void _onStrokeComplete(List<List<Offset>> strokes) async {
    final block = await _pipeline.recognize(strokes);
    // Use ValueNotifier so ONLY the preview rebuilds, not the canvas
    _blocksNotifier.value = [..._blocksNotifier.value, block];
  }

  void _goToPage(int index) {
    if (index >= 0 && index < _note.pages.length) {
      setState(() {
        _currentPageIndex = index;
        _blocksNotifier.value = [];
      });
      _canvasKey.currentState?.clear();
    }
  }

  void _addPage() {
    final updated = _note.addPage();
    setState(() {
      _note = updated;
      _currentPageIndex = updated.pages.length - 1;
      _blocksNotifier.value = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    if (isWide) {
      return Row(children: [
        Expanded(flex: 2, child: _buildCanvasColumn()),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 1,
          child: ValueListenableBuilder<List<LatexBlock>>(
            valueListenable: _blocksNotifier,
            builder: (context, blocks, child) => PreviewPane(blocks: blocks),
          ),
        ),
      ]);
    }

    // Phone: use bottom nav
    return Scaffold(
      body: _phoneTabIndex == 0
          ? _buildCanvasColumn()
          : ValueListenableBuilder<List<LatexBlock>>(
              valueListenable: _blocksNotifier,
              builder: (context, blocks, child) => PreviewPane(blocks: blocks),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Canvas'),
          BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'Preview'),
        ],
        currentIndex: _phoneTabIndex,
        onTap: (i) => setState(() => _phoneTabIndex = i),
      ),
    );
  }

  Widget _buildCanvasColumn() {
    return Column(children: [
      NoteToolbar(
        onUndo: () => _canvasKey.currentState?.undo(),
        onClear: () => _canvasKey.currentState?.clear(),
        onConvert: () async {
          // Batch convert all strokes on the canvas
          final canvasState = _canvasKey.currentState;
          if (canvasState == null) return;
          final blocks = await canvasState.recognizeAll(_pipeline);
          _blocksNotifier.value = [..._blocksNotifier.value, ...blocks];
        },
      ),
      Expanded(
        child: InkCanvas(
          key: _canvasKey,
          onStrokeComplete: _onStrokeComplete,
        ),
      ),
      PageNavigator(
        currentPage: _currentPageIndex,
        totalPages: _note.pages.length,
        onPrev: () => _goToPage(_currentPageIndex - 1),
        onNext: () => _goToPage(_currentPageIndex + 1),
        onAdd: _addPage,
      ),
    ]);
  }
}
