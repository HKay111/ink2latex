import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Provider<StorageService>(
      create: (_) => StorageService(),
      child: const Ink2LatexApp(),
    ),
  );
}