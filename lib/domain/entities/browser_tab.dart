/// Browser tab entity
class BrowserTab {
  final String id;
  final String url;
  final String title;
  final String? favicon;
  final bool isLoading;
  final double loadingProgress;
  final bool canGoBack;
  final bool canGoForward;
  final DateTime createdAt;
  final DateTime lastVisited;
  final String? cachedContent;
  final bool isIncognito;

  const BrowserTab({
    required this.id,
    required this.url,
    this.title = 'New Tab',
    this.favicon,
    this.isLoading = false,
    this.loadingProgress = 0.0,
    this.canGoBack = false,
    this.canGoForward = false,
    required this.createdAt,
    required this.lastVisited,
    this.cachedContent,
    this.isIncognito = false,
  });

  BrowserTab copyWith({
    String? id,
    String? url,
    String? title,
    String? favicon,
    bool? isLoading,
    double? loadingProgress,
    bool? canGoBack,
    bool? canGoForward,
    DateTime? createdAt,
    DateTime? lastVisited,
    String? cachedContent,
    bool? isIncognito,
  }) {
    return BrowserTab(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      favicon: favicon ?? this.favicon,
      isLoading: isLoading ?? this.isLoading,
      loadingProgress: loadingProgress ?? this.loadingProgress,
      canGoBack: canGoBack ?? this.canGoBack,
      canGoForward: canGoForward ?? this.canGoForward,
      createdAt: createdAt ?? this.createdAt,
      lastVisited: lastVisited ?? this.lastVisited,
      cachedContent: cachedContent ?? this.cachedContent,
      isIncognito: isIncognito ?? this.isIncognito,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrowserTab &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
