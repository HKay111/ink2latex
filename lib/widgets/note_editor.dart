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
  final List<LatexBlock> _blocks = [];
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

  void _onStrokeComplete(List<List<Offset>> strokes) async {
    final block = await _pipeline.recognize(strokes);
    setState(() => _blocks.add(block));
  }

  void _goToPage(int index) {
    if (index >= 0 && index < _note.pages.length) {
      // Save current page state before leaving
      final canvas = _canvasKey.currentState;
      if (canvas != null) {
        final strokes = canvas.getStrokes();
        final updated = _note.pages[_currentPageIndex].copyWith(
          inkData: strokes,
          blocks: List.from(_blocks),
        );
        _note = _note.updatePage(_currentPageIndex, updated);
        context.read<StorageService>().updateNotePages(_note.id, _note.pages);
      }

      setState(() {
        _currentPageIndex = index;
        _blocks.clear();
        _blocks.addAll(_note.pages[index].blocks);
      });
      canvas?.loadStrokes(_note.pages[index].inkData.cast());
    }
  }

  void _addPage() {
    // Save current page first
    final canvas = _canvasKey.currentState;
    if (canvas != null) {
      final strokes = canvas.getStrokes();
      _note.pages[_currentPageIndex] = _note.pages[_currentPageIndex].copyWith(
        inkData: strokes,
        blocks: List.from(_blocks),
      );
    }

    final updated = _note.addPage();
    setState(() {
      _note = updated;
      _currentPageIndex = updated.pages.length - 1;
      _blocks.clear();
    });
    context.read<StorageService>().updateNotePages(updated.id, updated.pages);
  }

  @override
  void dispose() {
    _pipeline.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    if (isWide) {
      return Row(children: [
        Expanded(flex: 2, child: _canvasColumn()),
        const VerticalDivider(width: 1),
        Expanded(flex: 1, child: _previewPane()),
      ]);
    }

    // Phone: IndexedStack keeps BOTH children alive — canvas never unmounts
    return Scaffold(
      body: IndexedStack(
        index: _phoneTabIndex,
        children: [
          _canvasColumn(),
          _previewPane(),
        ],
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

  Widget _canvasColumn() {
    return Column(children: [
      NoteToolbar(
        onUndo: () => _canvasKey.currentState?.undo(),
        onClear: () => _canvasKey.currentState?.clear(),
        onConvert: () async {
          final state = _canvasKey.currentState;
          if (state == null) return;
          final allBlocks = await state.recognizeAll(_pipeline);
          setState(() => _blocks.addAll(allBlocks));
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

  Widget _previewPane() {
    return PreviewPane(blocks: _blocks);
  }
}