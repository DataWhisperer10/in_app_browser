import 'package:hive/hive.dart';
import '../../domain/entities/browser_tab.dart';

part 'browser_tab_model.g.dart';

@HiveType(typeId: 0)
class BrowserTabModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String? favicon;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime lastVisited;

  @HiveField(6)
  final String? cachedContent;

  @HiveField(7)
  final bool isIncognito;

  BrowserTabModel({
    required this.id,
    required this.url,
    required this.title,
    this.favicon,
    required this.createdAt,
    required this.lastVisited,
    this.cachedContent,
    this.isIncognito = false,
  });

  factory BrowserTabModel.fromEntity(BrowserTab tab) {
    return BrowserTabModel(
      id: tab.id,
      url: tab.url,
      title: tab.title,
      favicon: tab.favicon,
      createdAt: tab.createdAt,
      lastVisited: tab.lastVisited,
      cachedContent: tab.cachedContent,
      isIncognito: tab.isIncognito,
    );
  }

  BrowserTab toEntity() {
    return BrowserTab(
      id: id,
      url: url,
      title: title,
      favicon: favicon,
      createdAt: createdAt,
      lastVisited: lastVisited,
      cachedContent: cachedContent,
      isIncognito: isIncognito,
    );
  }
}
