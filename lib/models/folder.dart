class Folder {
  final String id;
  final String name;
  final String? parentId;

  Folder({
    String? id,
    required this.name,
    this.parentId,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();
}