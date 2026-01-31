import '../../domain/entities/browser_tab.dart';
import '../../domain/entities/history_item.dart';
import '../../domain/repositories/browser_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/browser_tab_model.dart';
import '../models/history_item_model.dart';

/// Browser repository implementation
class BrowserRepositoryImpl implements BrowserRepository {
  final LocalStorageDatasource _datasource;

  BrowserRepositoryImpl(this._datasource);

  @override
  Future<List<BrowserTab>> getTabs() async {
    final models = _datasource.getTabs();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveTab(BrowserTab tab) async {
    await _datasource.saveTab(BrowserTabModel.fromEntity(tab));
  }

  @override
  Future<void> deleteTab(String tabId) async {
    await _datasource.deleteTab(tabId);
  }

  @override
  Future<void> updateTab(BrowserTab tab) async {
    await _datasource.saveTab(BrowserTabModel.fromEntity(tab));
  }

  @override
  Future<void> clearTabs() async {
    await _datasource.clearTabs();
  }

  @override
  Future<List<HistoryItem>> getHistory() async {
    final models = _datasource.getHistory();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addHistoryItem(HistoryItem item) async {
    await _datasource.addHistoryItem(HistoryItemModel.fromEntity(item));
  }

  @override
  Future<void> deleteHistoryItem(String itemId) async {
    await _datasource.deleteHistoryItem(itemId);
  }

  @override
  Future<void> clearHistory() async {
    await _datasource.clearHistory();
  }

  @override
  Future<List<HistoryItem>> searchHistory(String query) async {
    final models = _datasource.searchHistory(query);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> cachePageContent(String url, String content) async {
    await _datasource.cacheContent(url, content);
  }

  @override
  Future<String?> getCachedPageContent(String url) async {
    return _datasource.getCachedContent(url);
  }

  @override
  Future<void> clearPageCache() async {
    await _datasource.clearCache();
  }
}
