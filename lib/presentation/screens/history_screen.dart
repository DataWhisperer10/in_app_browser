import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/history_item.dart';
import '../providers/browser_provider.dart';
import '../providers/providers.dart';

/// History screen
class HistoryScreen extends ConsumerWidget {
  final Function(String url)? onItemTap;

  const HistoryScreen({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => _showClearHistoryDialog(context, ref),
            tooltip: 'Clear history',
          ),
        ],
      ),
      body: historyAsync.when(
        data: (history) => history.isEmpty
            ? _buildEmptyState()
            : _buildHistoryList(context, ref, history),
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        error: (error, _) => Center(
          child: Text(
            'Error loading history',
            style: TextStyle(color: AppColors.textSecondaryDark),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'No history yet',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your browsing history will appear here',
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildHistoryList(BuildContext context, WidgetRef ref, List<HistoryItem> history) {
    // Group by date
    final groupedHistory = <String, List<HistoryItem>>{};
    final dateFormat = DateFormat('EEEE, MMMM d');

    for (final item in history) {
      final dateKey = dateFormat.format(item.visitedAt);
      groupedHistory.putIfAbsent(dateKey, () => []).add(item);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: groupedHistory.length,
      itemBuilder: (context, index) {
        final date = groupedHistory.keys.elementAt(index);
        final items = groupedHistory[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                date,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...items.map((item) => _HistoryItemTile(
                  item: item,
                  onTap: () {
                    if (onItemTap != null) {
                      onItemTap!(item.url);
                      Navigator.pop(context);
                    }
                  },
                  onDelete: () async {
                    final repository = ref.read(browserRepositoryProvider);
                    await repository.deleteHistoryItem(item.id);
                    ref.invalidate(historyProvider);
                  },
                )),
          ],
        ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(
              begin: 0.05,
              duration: 300.ms,
            );
      },
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Clear History',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: Text(
          'This will clear all your browsing history. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final repository = ref.read(browserRepositoryProvider);
              await repository.clearHistory();
              ref.invalidate(historyProvider);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class _HistoryItemTile extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _HistoryItemTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: item.favicon != null && item.favicon!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.favicon!,
                    errorBuilder: (_, __, ___) => Icon(
                      _getTypeIcon(item.type),
                      color: AppColors.textSecondaryDark,
                      size: 20,
                    ),
                  ),
                )
              : Icon(
                  _getTypeIcon(item.type),
                  color: AppColors.textSecondaryDark,
                  size: 20,
                ),
        ),
        title: Text(
          item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          item.url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 12,
          ),
        ),
        trailing: Text(
          timeFormat.format(item.visitedAt),
          style: TextStyle(
            color: AppColors.textTertiaryDark,
            fontSize: 12,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getTypeIcon(HistoryItemType type) {
    switch (type) {
      case HistoryItemType.browse:
        return Icons.public;
      case HistoryItemType.summary:
        return Icons.auto_awesome;
      case HistoryItemType.download:
        return Icons.download;
    }
  }
}
