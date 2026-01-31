/// Browser history item entity
class HistoryItem {
  final String id;
  final String url;
  final String title;
  final String? favicon;
  final DateTime visitedAt;
  final HistoryItemType type;

  const HistoryItem({
    required this.id,
    required this.url,
    required this.title,
    this.favicon,
    required this.visitedAt,
    required this.type,
  });

  HistoryItem copyWith({
    String? id,
    String? url,
    String? title,
    String? favicon,
    DateTime? visitedAt,
    HistoryItemType? type,
  }) {
    return HistoryItem(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      favicon: favicon ?? this.favicon,
      visitedAt: visitedAt ?? this.visitedAt,
      type: type ?? this.type,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum HistoryItemType {
  browse,
  summary,
  download,
}
