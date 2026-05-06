import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = StorageService();
  runApp(
    ChangeNotifierProvider<StorageService>.value(
      value: storage,
      child: const Ink2LatexApp(),
    ),
  );
  storage.init(); // Load from disk after widget tree is built
}