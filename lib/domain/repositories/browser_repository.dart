import '../entities/browser_tab.dart';
import '../entities/history_item.dart';

/// Browser repository interface
abstract class BrowserRepository {
  /// Get all tabs
  Future<List<BrowserTab>> getTabs();

  /// Save tab
  Future<void> saveTab(BrowserTab tab);

  /// Delete tab
  Future<void> deleteTab(String tabId);

  /// Update tab
  Future<void> updateTab(BrowserTab tab);

  /// Clear all tabs
  Future<void> clearTabs();

  /// Get browsing history
  Future<List<HistoryItem>> getHistory();

  /// Add history item
  Future<void> addHistoryItem(HistoryItem item);

  /// Delete history item
  Future<void> deleteHistoryItem(String itemId);

  /// Clear history
  Future<void> clearHistory();

  /// Search history
  Future<List<HistoryItem>> searchHistory(String query);

  /// Cache page content
  Future<void> cachePageContent(String url, String content);

  /// Get cached page content
  Future<String?> getCachedPageContent(String url);

  /// Clear page cache
  Future<void> clearPageCache();
}
