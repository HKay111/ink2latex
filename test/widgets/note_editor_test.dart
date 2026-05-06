import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ink2latex/widgets/note_editor.dart';
import 'package:ink2latex/services/storage_service.dart';

void main() {
  testWidgets('NoteEditor renders toolbar and canvas', (WidgetTester tester) async {
    final storage = StorageService.inMemory();
    final folder = storage.createFolder('Test');

    await tester.pumpWidget(
      MaterialApp(
        home: Provider<StorageService>.value(
          value: storage,
          child: NoteEditor(folderId: folder.id),
        ),
      ),
    );

    expect(find.byType(NoteEditor), findsOneWidget);
    expect(find.byIcon(Icons.undo), findsOneWidget);
  });
}