import 'package:flutter_test/flutter_test.dart';
import 'package:ink2latex/app.dart';
import 'package:provider/provider.dart';
import 'package:ink2latex/services/storage_service.dart';

void main() {
  testWidgets('app renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<StorageService>(
        create: (_) => StorageService(),
        child: const Ink2LatexApp(),
      ),
    );
    expect(find.text('Ink2LaTeX'), findsOneWidget);
  });
}