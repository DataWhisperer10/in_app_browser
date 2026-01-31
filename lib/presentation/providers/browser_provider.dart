import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/browser_tab.dart';
import '../../domain/entities/history_item.dart';
import 'providers.dart';

/// Browser state
class BrowserState {
  final List<BrowserTab> tabs;
  final int activeTabIndex;
  final bool isLoading;
  final String? error;

  const BrowserState({
    this.tabs = const [],
    this.activeTabIndex = 0,
    this.isLoading = false,
    this.error,
  });

  BrowserTab? get activeTab {
    if (tabs.isEmpty || activeTabIndex >= tabs.length) return null;
    return tabs[activeTabIndex];
  }

  BrowserState copyWith({
    List<BrowserTab>? tabs,
    int? activeTabIndex,
    bool? isLoading,
    String? error,
  }) {
    return BrowserState(
      tabs: tabs ?? this.tabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Browser state notifier
class BrowserNotifier extends StateNotifier<BrowserState> {
  final Ref _ref;
  final Uuid _uuid = const Uuid();

  BrowserNotifier(this._ref) : super(const BrowserState()) {
    _loadTabs();
  }

  Future<void> _loadTabs() async {
    try {
      state = state.copyWith(isLoading: true);
      final repository = _ref.read(browserRepositoryProvider);
      final tabs = await repository.getTabs();

      if (tabs.isEmpty) {
        // Create initial tab
        final initialTab = _createNewTab();
        await repository.saveTab(initialTab);
        state = state.copyWith(
          tabs: [initialTab],
          activeTabIndex: 0,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          tabs: tabs,
          activeTabIndex: 0,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  BrowserTab _createNewTab([String? url]) {
    final now = DateTime.now();
    return BrowserTab(
      id: _uuid.v4(),
      url: url ?? AppConstants.defaultHomePage,
      title: 'New Tab',
      createdAt: now,
      lastVisited: now,
    );
  }

  Future<void> addTab([String? url]) async {
    if (state.tabs.length >= AppConstants.maxTabs) {
      state = state.copyWith(error: 'Maximum tabs limit reached');
      return;
    }

    final newTab = _createNewTab(url);
    final newTabs = [...state.tabs, newTab];
    
    final repository = _ref.read(browserRepositoryProvider);
    await repository.saveTab(newTab);

    state = state.copyWith(
      tabs: newTabs,
      activeTabIndex: newTabs.length - 1,
    );
  }

  Future<void> closeTab(String tabId) async {
    if (state.tabs.length <= AppConstants.minTabs) {
      state = state.copyWith(error: 'Cannot close the last tab');
      return;
    }

    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;

    final newTabs = state.tabs.where((t) => t.id != tabId).toList();
    int newActiveIndex = state.activeTabIndex;

    if (tabIndex <= state.activeTabIndex) {
      newActiveIndex = (state.activeTabIndex - 1).clamp(0, newTabs.length - 1);
    }

    final repository = _ref.read(browserRepositoryProvider);
    await repository.deleteTab(tabId);

    state = state.copyWith(
      tabs: newTabs,
      activeTabIndex: newActiveIndex,
    );
  }

  void switchTab(int index) {
    if (index >= 0 && index < state.tabs.length) {
      state = state.copyWith(activeTabIndex: index);
    }
  }

  Future<void> updateTab(BrowserTab updatedTab) async {
    final tabIndex = state.tabs.indexWhere((t) => t.id == updatedTab.id);
    if (tabIndex == -1) return;

    final newTabs = [...state.tabs];
    newTabs[tabIndex] = updatedTab;

    final repository = _ref.read(browserRepositoryProvider);
    await repository.updateTab(updatedTab);

    state = state.copyWith(tabs: newTabs);
  }

  Future<void> navigateToUrl(String url) async {
    final activeTab = state.activeTab;
    if (activeTab == null) return;

    final updatedTab = activeTab.copyWith(
      url: url,
      isLoading: true,
      lastVisited: DateTime.now(),
    );

    await updateTab(updatedTab);

    // Add to history
    final repository = _ref.read(browserRepositoryProvider);
    final historyItem = HistoryItem(
      id: _uuid.v4(),
      url: url,
      title: activeTab.title,
      favicon: activeTab.favicon,
      visitedAt: DateTime.now(),
      type: HistoryItemType.browse,
    );
    await repository.addHistoryItem(historyItem);
  }

  Future<void> updateLoadingState({
    required String tabId,
    required bool isLoading,
    double? progress,
    bool? canGoBack,
    bool? canGoForward,
  }) async {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;

    final tab = state.tabs[tabIndex];
    final updatedTab = tab.copyWith(
      isLoading: isLoading,
      loadingProgress: progress ?? tab.loadingProgress,
      canGoBack: canGoBack ?? tab.canGoBack,
      canGoForward: canGoForward ?? tab.canGoForward,
    );

    final newTabs = [...state.tabs];
    newTabs[tabIndex] = updatedTab;

    state = state.copyWith(tabs: newTabs);
  }

  Future<void> updateTabInfo({
    required String tabId,
    String? title,
    String? favicon,
    String? url,
  }) async {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;

    final tab = state.tabs[tabIndex];
    final updatedTab = tab.copyWith(
      title: title ?? tab.title,
      favicon: favicon ?? tab.favicon,
      url: url ?? tab.url,
      lastVisited: DateTime.now(),
    );

    await updateTab(updatedTab);
  }

  Future<void> cachePageContent(String url, String content) async {
    final repository = _ref.read(browserRepositoryProvider);
    await repository.cachePageContent(url, content);
  }

  Future<String?> getCachedContent(String url) async {
    final repository = _ref.read(browserRepositoryProvider);
    return repository.getCachedPageContent(url);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Browser provider
final browserProvider = StateNotifierProvider<BrowserNotifier, BrowserState>((ref) {
  return BrowserNotifier(ref);
});

/// Active tab provider
final activeTabProvider = Provider<BrowserTab?>((ref) {
  final browserState = ref.watch(browserProvider);
  return browserState.activeTab;
});

/// History provider
final historyProvider = FutureProvider<List<HistoryItem>>((ref) async {
  final repository = ref.watch(browserRepositoryProvider);
  return repository.getHistory();
});
