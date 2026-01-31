import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_utils.dart';
import '../../domain/entities/browser_tab.dart';
import '../providers/browser_provider.dart';

/// URL bar widget with search and navigation
class UrlBar extends ConsumerStatefulWidget {
  final BrowserTab? tab;
  final VoidCallback? onBack;
  final VoidCallback? onForward;
  final VoidCallback? onRefresh;
  final Function(String) onNavigate;

  const UrlBar({
    super.key,
    this.tab,
    this.onBack,
    this.onForward,
    this.onRefresh,
    required this.onNavigate,
  });

  @override
  ConsumerState<UrlBar> createState() => _UrlBarState();
}

class _UrlBarState extends ConsumerState<UrlBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.tab?.url ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant UrlBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEditing && widget.tab?.url != oldWidget.tab?.url) {
      _controller.text = widget.tab?.url ?? '';
    }
  }

  void _onFocusChange() {
    setState(() {
      _isEditing = _focusNode.hasFocus;
      if (_isEditing) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    });
  }

  void _onSubmitted(String value) {
    final url = UrlUtils.normalizeUrl(value);
    widget.onNavigate(url);
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = widget.tab;
    final isSecure = tab != null && UrlUtils.isSecure(tab.url);

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderDark,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Navigation buttons
          _NavButton(
            icon: Icons.arrow_back_ios_rounded,
            enabled: tab?.canGoBack ?? false,
            onTap: widget.onBack,
          ),
          _NavButton(
            icon: Icons.arrow_forward_ios_rounded,
            enabled: tab?.canGoForward ?? false,
            onTap: widget.onForward,
          ),
          _NavButton(
            icon: tab?.isLoading == true ? Icons.close : Icons.refresh,
            enabled: true,
            onTap: widget.onRefresh,
          ),
          const SizedBox(width: 8),
          // URL Input
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.urlBarBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isEditing
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : AppColors.borderDark,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  // Security indicator
                  Icon(
                    isSecure ? Icons.lock : Icons.lock_open,
                    size: 16,
                    color: isSecure ? AppColors.success : AppColors.textTertiaryDark,
                  ),
                  const SizedBox(width: 8),
                  // URL input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimaryDark,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search or enter URL',
                        hintStyle: TextStyle(
                          color: AppColors.textTertiaryDark,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.go,
                      onSubmitted: _onSubmitted,
                    ),
                  ),
                  if (_isEditing)
                    IconButton(
                      onPressed: () {
                        _controller.clear();
                      },
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                        color: AppColors.textTertiaryDark,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Menu button
          _NavButton(
            icon: Icons.more_vert,
            enabled: true,
            onTap: () => _showMenu(context),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BrowserMenu(
        onDownload: () {
          Navigator.pop(context);
          // Check if current URL is downloadable
          final tab = widget.tab;
          if (tab != null && UrlUtils.isDownloadableDocument(tab.url)) {
            ref.read(browserProvider.notifier);
            // Trigger download
          }
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: enabled ? onTap : null,
      icon: Icon(
        icon,
        size: 20,
        color: enabled
            ? AppColors.textSecondaryDark
            : AppColors.textTertiaryDark.withValues(alpha: 0.5),
      ),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 36,
      ),
    );
  }
}

class _BrowserMenu extends StatelessWidget {
  final VoidCallback? onDownload;

  const _BrowserMenu({this.onDownload});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            _MenuItem(
              icon: Icons.download,
              label: 'Download Page',
              onTap: onDownload,
            ),
            _MenuItem(
              icon: Icons.bookmark_border,
              label: 'Add Bookmark',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.share,
              label: 'Share',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.find_in_page,
              label: 'Find in Page',
              onTap: () => Navigator.pop(context),
            ),
            _MenuItem(
              icon: Icons.desktop_windows,
              label: 'Desktop Site',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondaryDark),
      title: Text(
        label,
        style: TextStyle(color: AppColors.textPrimaryDark),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
