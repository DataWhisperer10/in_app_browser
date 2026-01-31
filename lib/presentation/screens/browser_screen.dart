import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_utils.dart';
import '../providers/browser_provider.dart';
import '../providers/ai_provider.dart';
import '../providers/file_provider.dart';
import '../widgets/browser_tab_bar.dart';
import '../widgets/url_bar.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/summary_panel.dart';

/// Main browser screen with WebView
class BrowserScreen extends ConsumerStatefulWidget {
  const BrowserScreen({super.key});

  @override
  ConsumerState<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends ConsumerState<BrowserScreen> {
  InAppWebViewController? _webViewController;
  bool _isSummaryPanelExpanded = false;
  String _currentPageContent = '';

  @override
  Widget build(BuildContext context) {
    final browserState = ref.watch(browserProvider);
    final activeTab = browserState.activeTab;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Tab bar
            const BrowserTabBar(),
            // URL bar
            UrlBar(
              tab: activeTab,
              onBack: _goBack,
              onForward: _goForward,
              onRefresh: _refresh,
              onNavigate: _navigateToUrl,
            ),
            // Loading indicator
            LoadingIndicator(
              isVisible: activeTab?.isLoading ?? false,
              progress: activeTab?.loadingProgress ?? 0.0,
            ),
            // WebView
            Expanded(
              child: Stack(
                children: [
                  _buildWebView(activeTab?.url ?? 'about:blank', activeTab?.id ?? ''),
                  // Summary panel
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SummaryPanel(
                      isExpanded: _isSummaryPanelExpanded,
                      onToggle: () => setState(() {
                        _isSummaryPanelExpanded = !_isSummaryPanelExpanded;
                      }),
                      onSummarize: _summarizePage,
                      pageContent: _currentPageContent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating summarize button
      floatingActionButton: !_isSummaryPanelExpanded
          ? FloatingActionButton(
              onPressed: () {
                setState(() => _isSummaryPanelExpanded = true);
                _summarizePage();
              },
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.auto_awesome,
                color: AppColors.backgroundDark,
              ),
            )
          : null,
    );
  }

  Widget _buildWebView(String url, String tabId) {
    // For web platform, use a different approach
    if (kIsWeb) {
      return _buildWebFallback(url);
    }

    return InAppWebView(
      key: ValueKey(tabId),
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        supportZoom: true,
        builtInZoomControls: true,
        displayZoomControls: false,
        useWideViewPort: true,
        loadWithOverviewMode: true,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: (controller, url) {
        ref.read(browserProvider.notifier).updateLoadingState(
              tabId: tabId,
              isLoading: true,
              progress: 0.0,
            );
      },
      onProgressChanged: (controller, progress) {
        ref.read(browserProvider.notifier).updateLoadingState(
              tabId: tabId,
              isLoading: progress < 100,
              progress: progress / 100,
            );
      },
      onLoadStop: (controller, url) async {
        ref.read(browserProvider.notifier).updateLoadingState(
              tabId: tabId,
              isLoading: false,
              progress: 1.0,
            );

        // Update navigation state
        final canGoBack = await controller.canGoBack();
        final canGoForward = await controller.canGoForward();
        ref.read(browserProvider.notifier).updateLoadingState(
              tabId: tabId,
              isLoading: false,
              canGoBack: canGoBack,
              canGoForward: canGoForward,
            );

        // Get page title
        final title = await controller.getTitle();
        if (title != null) {
          ref.read(browserProvider.notifier).updateTabInfo(
                tabId: tabId,
                title: title,
                url: url?.toString(),
                favicon: UrlUtils.getFaviconUrl(url?.toString() ?? ''),
              );
        }

        // Extract page content for summarization
        _extractPageContent(controller);
      },
      onReceivedError: (controller, request, error) {
        ref.read(browserProvider.notifier).updateLoadingState(
              tabId: tabId,
              isLoading: false,
            );
      },
      onDownloadStartRequest: (controller, request) async {
        // Handle file downloads
        if (UrlUtils.isDownloadableDocument(request.url.toString())) {
          ref.read(fileProvider.notifier).downloadFile(request.url.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloading ${request.suggestedFilename ?? "file"}...')),
          );
        }
      },
    );
  }

  Widget _buildWebFallback(String url) {
    // Simple web fallback - show URL and message
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.web,
            size: 64,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'Web browser view',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              url,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textTertiaryDark,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Full WebView functionality available on mobile platforms',
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _extractPageContent(InAppWebViewController controller) async {
    try {
      final result = await controller.evaluateJavascript(source: '''
        (function() {
          var content = document.body.innerText || document.body.textContent;
          return content.substring(0, 50000);
        })();
      ''');
      
      if (result != null) {
        setState(() {
          _currentPageContent = result.toString();
        });
      }
    } catch (e) {
      // Ignore extraction errors
    }
  }

  void _goBack() {
    _webViewController?.goBack();
  }

  void _goForward() {
    _webViewController?.goForward();
  }

  void _refresh() {
    final activeTab = ref.read(browserProvider).activeTab;
    if (activeTab?.isLoading == true) {
      _webViewController?.stopLoading();
    } else {
      _webViewController?.reload();
    }
  }

  void _navigateToUrl(String url) {
    final normalizedUrl = UrlUtils.normalizeUrl(url);
    _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(normalizedUrl)),
    );
    ref.read(browserProvider.notifier).navigateToUrl(normalizedUrl);
  }

  Future<void> _summarizePage() async {
    if (_currentPageContent.isEmpty) {
      // Try to extract content first
      if (_webViewController != null) {
        await _extractPageContent(_webViewController!);
      }
    }

    if (_currentPageContent.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to extract page content')),
      );
      return;
    }

    final activeTab = ref.read(browserProvider).activeTab;
    if (activeTab == null) return;

    ref.read(aiProvider.notifier).summarizeText(
          text: _currentPageContent,
          sourceUrl: activeTab.url,
        );
  }
}
