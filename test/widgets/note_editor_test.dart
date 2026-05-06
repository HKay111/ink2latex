import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ink2latex/widgets/note_editor.dart';
import 'package:ink2latex/services/storage_service.dart';

void main() {
  Provider.debugCheckInvalidValueType = null; // StorageService extends ChangeNotifier

  testWidgets('NoteEditor renders toolbar and canvas', (WidgetTester tester) async {
    final storage = StorageService.inMemory();
    final folder = storage.createFolder('Test');
    final note = storage.createNote('Test Note', folder.id);

    await tester.pumpWidget(
      MaterialApp(
        home: Provider<StorageService>.value(
          value: storage,
          child: NoteEditor(noteId: note.id, folderId: folder.id),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(NoteEditor), findsOneWidget);
    expect(find.byIcon(Icons.undo), findsOneWidget);
  });
}
