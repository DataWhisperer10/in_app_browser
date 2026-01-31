import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../models/browser_tab_model.dart';
import '../models/downloaded_file_model.dart';
import '../models/summary_model.dart';
import '../models/history_item_model.dart';
import '../models/app_settings_model.dart';

/// Local storage datasource using Hive
class LocalStorageDatasource {
  static LocalStorageDatasource? _instance;
  static LocalStorageDatasource get instance {
    _instance ??= LocalStorageDatasource._();
    return _instance!;
  }

  LocalStorageDatasource._();

  late Box<BrowserTabModel> _tabsBox;
  late Box<DownloadedFileModel> _downloadsBox;
  late Box<SummaryModel> _summariesBox;
  late Box<HistoryItemModel> _historyBox;
  late Box<AppSettingsModel> _settingsBox;
  late Box<String> _cacheBox;

  bool _isInitialized = false;

  /// Initialize Hive and open all boxes
  Future<void> initialize() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(BrowserTabModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DownloadedFileModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SummaryModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(TranslationModelAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(HistoryItemModelAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(AppSettingsModelAdapter());
    }

    // Open boxes
    _tabsBox = await Hive.openBox<BrowserTabModel>(AppConstants.tabsBoxKey);
    _downloadsBox = await Hive.openBox<DownloadedFileModel>(AppConstants.downloadsBoxKey);
    _summariesBox = await Hive.openBox<SummaryModel>(AppConstants.summariesBoxKey);
    _historyBox = await Hive.openBox<HistoryItemModel>(AppConstants.historyBoxKey);
    _settingsBox = await Hive.openBox<AppSettingsModel>(AppConstants.settingsBoxKey);
    _cacheBox = await Hive.openBox<String>(AppConstants.cacheBoxKey);

    _isInitialized = true;
  }

  // ============== TABS ==============
  
  List<BrowserTabModel> getTabs() {
    return _tabsBox.values.toList();
  }

  Future<void> saveTab(BrowserTabModel tab) async {
    await _tabsBox.put(tab.id, tab);
  }

  Future<void> deleteTab(String tabId) async {
    await _tabsBox.delete(tabId);
  }

  Future<void> clearTabs() async {
    await _tabsBox.clear();
  }

  // ============== DOWNLOADS ==============
  
  List<DownloadedFileModel> getDownloads() {
    return _downloadsBox.values.toList();
  }

  Future<void> saveDownload(DownloadedFileModel file) async {
    await _downloadsBox.put(file.id, file);
  }

  Future<void> deleteDownload(String fileId) async {
    await _downloadsBox.delete(fileId);
  }

  DownloadedFileModel? getDownloadById(String fileId) {
    return _downloadsBox.get(fileId);
  }

  Future<void> clearDownloads() async {
    await _downloadsBox.clear();
  }

  // ============== SUMMARIES ==============
  
  List<SummaryModel> getSummaries() {
    return _summariesBox.values.toList();
  }

  Future<void> saveSummary(SummaryModel summary) async {
    await _summariesBox.put(summary.id, summary);
  }

  SummaryModel? getSummaryByUrl(String url) {
    try {
      return _summariesBox.values.firstWhere((s) => s.sourceUrl == url);
    } catch (e) {
      return null;
    }
  }

  SummaryModel? getSummaryById(String id) {
    return _summariesBox.get(id);
  }

  Future<void> deleteSummary(String summaryId) async {
    await _summariesBox.delete(summaryId);
  }

  Future<void> clearSummaries() async {
    await _summariesBox.clear();
  }

  // ============== HISTORY ==============
  
  List<HistoryItemModel> getHistory() {
    final items = _historyBox.values.toList();
    items.sort((a, b) => b.visitedAt.compareTo(a.visitedAt));
    return items;
  }

  Future<void> addHistoryItem(HistoryItemModel item) async {
    await _historyBox.put(item.id, item);
  }

  Future<void> deleteHistoryItem(String itemId) async {
    await _historyBox.delete(itemId);
  }

  Future<void> clearHistory() async {
    await _historyBox.clear();
  }

  List<HistoryItemModel> searchHistory(String query) {
    final lowerQuery = query.toLowerCase();
    return _historyBox.values
        .where((item) =>
            item.title.toLowerCase().contains(lowerQuery) ||
            item.url.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // ============== SETTINGS ==============
  
  AppSettingsModel getSettings() {
    return _settingsBox.get('settings') ?? AppSettingsModel();
  }

  Future<void> saveSettings(AppSettingsModel settings) async {
    await _settingsBox.put('settings', settings);
  }

  // ============== CACHE ==============
  
  String? getCachedContent(String url) {
    return _cacheBox.get(url);
  }

  Future<void> cacheContent(String url, String content) async {
    await _cacheBox.put(url, content);
  }

  Future<void> deleteCachedContent(String url) async {
    await _cacheBox.delete(url);
  }

  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  /// Close all boxes
  Future<void> close() async {
    await _tabsBox.close();
    await _downloadsBox.close();
    await _summariesBox.close();
    await _historyBox.close();
    await _settingsBox.close();
    await _cacheBox.close();
    _isInitialized = false;
  }
}
