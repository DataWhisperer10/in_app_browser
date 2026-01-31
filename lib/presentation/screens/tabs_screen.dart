import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/url_utils.dart';
import '../../domain/entities/browser_tab.dart';
import '../providers/browser_provider.dart';

/// Tabs overview screen
class TabsScreen extends ConsumerWidget {
  final Function(int) onTabSelected;

  const TabsScreen({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserState = ref.watch(browserProvider);
    final tabs = browserState.tabs;
    final activeIndex = browserState.activeTabIndex;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('${tabs.length} Tabs'),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              ref.read(browserProvider.notifier).addTab();
              Navigator.pop(context);
            },
            tooltip: 'New tab',
          ),
        ],
      ),
      body: tabs.isEmpty
          ? _buildEmptyState(ref)
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return _TabCard(
                  tab: tabs[index],
                  isActive: index == activeIndex,
                  onTap: () {
                    ref.read(browserProvider.notifier).switchTab(index);
                    onTabSelected(0); // Navigate to browser
                    Navigator.pop(context);
                  },
                  onClose: () {
                    ref.read(browserProvider.notifier).closeTab(tabs[index].id);
                  },
                ).animate(delay: Duration(milliseconds: 50 * index))
                    .fadeIn()
                    .scale(begin: const Offset(0.9, 0.9), duration: 300.ms);
              },
            ),
    );
  }

  Widget _buildEmptyState(WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.tab,
            size: 80,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'No tabs open',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(browserProvider.notifier).addTab();
            },
            icon: Icon(Icons.add),
            label: Text('New Tab'),
          ),
        ],
      ),
    );
  }
}

class _TabCard extends StatelessWidget {
  final BrowserTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _TabCard({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? AppColors.primary : AppColors.borderDark,
          width: isActive ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Preview area
            Expanded(
              child: Container(
                color: AppColors.cardDark,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Favicon
                      if (tab.favicon != null && tab.favicon!.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            tab.favicon!,
                            width: 48,
                            height: 48,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.public,
                              size: 48,
                              color: AppColors.textTertiaryDark,
                            ),
                          ),
                        )
                      else
                        Icon(
                          Icons.public,
                          size: 48,
                          color: AppColors.textTertiaryDark,
                        ),
                      const SizedBox(height: 12),
                      // Domain
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          UrlUtils.extractDomain(tab.url) ?? tab.url,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textTertiaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Title and close button
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border(
                  top: BorderSide(color: AppColors.borderDark),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tab.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.borderDark,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
