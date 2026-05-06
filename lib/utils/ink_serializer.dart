import 'dart:ui';

class InkSerializer {
  static Map<String, dynamic> strokeToJson(List<Offset> points) {
    return {'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList()};
  }

  static List<Offset> strokeFromJson(Map<String, dynamic> json) {
    return (json['points'] as List).map((p) =>
      Offset((p['x'] as num).toDouble(), (p['y'] as num).toDouble())
    ).toList();
  }

  static List<Map<String, dynamic>> strokesToJson(List<List<Offset>> strokes) {
    return strokes.map(strokeToJson).toList();
  }

  static List<List<Offset>> strokesFromJson(List<dynamic> jsonList) {
    return jsonList.map((s) => strokeFromJson(s as Map<String, dynamic>)).toList();
  }
}
