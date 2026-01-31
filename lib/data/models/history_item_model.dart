import 'package:hive/hive.dart';
import '../../domain/entities/history_item.dart';

part 'history_item_model.g.dart';

@HiveType(typeId: 4)
class HistoryItemModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? favicon;

  @HiveField(4)
  final DateTime visitedAt;

  @HiveField(5)
  final int type;

  HistoryItemModel({
    required this.id,
    required this.url,
    required this.title,
    this.favicon,
    required this.visitedAt,
    required this.type,
  });

  factory HistoryItemModel.fromEntity(HistoryItem item) {
    return HistoryItemModel(
      id: item.id,
      url: item.url,
      title: item.title,
      favicon: item.favicon,
      visitedAt: item.visitedAt,
      type: item.type.index,
    );
  }

  HistoryItem toEntity() {
    return HistoryItem(
      id: id,
      url: url,
      title: title,
      favicon: favicon,
      visitedAt: visitedAt,
      type: HistoryItemType.values[type],
    );
  }
}
