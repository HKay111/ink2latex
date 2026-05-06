import 'page_model.dart';

class Note {
  final String id;
  final String title;
  final String folderId;
  final List<PageModel> pages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    String? id,
    required this.title,
    required this.folderId,
    List<PageModel>? pages,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        pages = pages ?? [PageModel()],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Note addPage() {
    return Note(
      id: id, title: title, folderId: folderId,
      pages: [...pages, PageModel()],
      createdAt: createdAt, updatedAt: DateTime.now(),
    );
  }
}