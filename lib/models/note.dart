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

  Note updatePage(int index, PageModel page) {
    final newPages = List<PageModel>.from(pages);
    newPages[index] = page;
    return Note(
      id: id, title: title, folderId: folderId,
      pages: newPages,
      createdAt: createdAt, updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'folderId': folderId,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'pages': pages.map((p) => p.toJson()).toList(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'] as String,
    title: json['title'] as String,
    folderId: json['folderId'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
    pages: (json['pages'] as List)
        .map((p) => PageModel.fromJson(p as Map<String, dynamic>))
        .toList(),
  );
}