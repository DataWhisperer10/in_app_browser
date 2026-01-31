import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/browser_tab.dart';
import '../providers/browser_provider.dart';

/// Browser tab bar widget with animated tabs
class BrowserTabBar extends ConsumerWidget {
  const BrowserTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final browserState = ref.watch(browserProvider);
    final tabs = browserState.tabs;
    final activeIndex = browserState.activeTabIndex;

    return Container(
      height: 44,
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
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                return _TabItem(
                  tab: tabs[index],
                  isActive: index == activeIndex,
                  onTap: () => ref.read(browserProvider.notifier).switchTab(index),
                  onClose: () => ref.read(browserProvider.notifier).closeTab(tabs[index].id),
                );
              },
            ),
          ),
          _AddTabButton(
            onTap: () => ref.read(browserProvider.notifier).addTab(),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final BrowserTab tab;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onClose;

  const _TabItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 160,
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.cardDark : AppColors.tabInactive,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary.withValues(alpha: 0.5) : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Favicon or loading indicator
            if (tab.isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            else if (tab.favicon != null && tab.favicon!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  tab.favicon!,
                  width: 14,
                  height: 14,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.public,
                    size: 14,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              )
            else
              Icon(
                Icons.public,
                size: 14,
                color: AppColors.textSecondaryDark,
              ),
            const SizedBox(width: 8),
            // Title
            Expanded(
              child: Text(
                tab.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive
                      ? AppColors.textPrimaryDark
                      : AppColors.textSecondaryDark,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            // Close button
            GestureDetector(
              onTap: onClose,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: AppColors.textTertiaryDark,
                ),
              ),
            ),
          ],
        ),
      ).animate(
        target: isActive ? 1 : 0,
      ).scale(
        begin: const Offset(0.98, 0.98),
        end: const Offset(1, 1),
        duration: 150.ms,
      ),
    );
  }
}

class _AddTabButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddTabButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          Icons.add,
          size: 20,
          color: AppColors.textSecondaryDark,
        ),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.cardDark,
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
