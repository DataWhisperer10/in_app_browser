import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../providers/settings_provider.dart';
import '../providers/file_provider.dart';
import '../providers/ai_provider.dart';

/// Settings screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Appearance section
          _buildSectionHeader('Appearance'),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: 'Dark Mode',
            subtitle: 'Use dark theme',
            value: settings.isDarkMode,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleDarkMode(),
          ),

          // Browser section
          _buildSectionHeader('Browser'),
          _buildSwitchTile(
            icon: Icons.javascript,
            title: 'Enable JavaScript',
            subtitle: 'Allow websites to run JavaScript',
            value: settings.enableJavascript,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleJavascript(),
          ),
          _buildSwitchTile(
            icon: Icons.block,
            title: 'Block Pop-ups',
            subtitle: 'Prevent pop-up windows',
            value: settings.blockPopups,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleBlockPopups(),
          ),
          _buildListTile(
            icon: Icons.search,
            title: 'Search Engine',
            subtitle: 'Google',
            onTap: () => _showSearchEngineDialog(context, ref),
          ),

          // AI & Summary section
          _buildSectionHeader('AI & Summary'),
          _buildListTile(
            icon: Icons.text_fields,
            title: 'Summary Length',
            subtitle: '${settings.summaryLength} words',
            onTap: () => _showSummaryLengthDialog(context, ref, settings.summaryLength),
          ),
          _buildListTile(
            icon: Icons.translate,
            title: 'Default Language',
            subtitle: AppConstants.supportedLanguages[settings.defaultLanguage] ?? 'English',
            onTap: () => _showLanguageDialog(context, ref, settings.defaultLanguage),
          ),
          _buildSwitchTile(
            icon: Icons.auto_awesome,
            title: 'Auto Summarize',
            subtitle: 'Automatically summarize pages',
            value: settings.autoSummarize,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleAutoSummarize(),
          ),

          // Privacy section
          _buildSectionHeader('Privacy & Data'),
          _buildSwitchTile(
            icon: Icons.history,
            title: 'Save History',
            subtitle: 'Keep browsing history',
            value: settings.saveHistory,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleSaveHistory(),
          ),
          _buildSwitchTile(
            icon: Icons.offline_bolt,
            title: 'Offline Mode',
            subtitle: 'Cache pages for offline access',
            value: settings.enableOfflineMode,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleOfflineMode(),
          ),
          _buildActionTile(
            icon: Icons.delete_sweep,
            title: 'Clear Browsing Data',
            subtitle: 'History, cache, and downloads',
            onTap: () => _showClearDataDialog(context, ref),
            isDestructive: true,
          ),

          // About section
          _buildSectionHeader('About'),
          _buildListTile(
            icon: Icons.info_outline,
            title: 'Version',
            subtitle: AppConstants.appVersion,
            onTap: null,
          ),
          _buildListTile(
            icon: Icons.code,
            title: 'Architecture',
            subtitle: 'Clean Architecture with Riverpod',
            onTap: null,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.textSecondaryDark, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textTertiaryDark,
          fontSize: 13,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.textSecondaryDark, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textTertiaryDark,
          fontSize: 13,
        ),
      ),
      trailing: onTap != null
          ? Icon(Icons.chevron_right, color: AppColors.textTertiaryDark)
          : null,
      onTap: onTap,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withValues(alpha: 0.1)
              : AppColors.cardDark,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.textSecondaryDark,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? AppColors.error : AppColors.textPrimaryDark,
          fontSize: 15,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: AppColors.textTertiaryDark,
          fontSize: 13,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showSearchEngineDialog(BuildContext context, WidgetRef ref) {
    final engines = {
      'https://www.google.com/search?q=': 'Google',
      'https://www.bing.com/search?q=': 'Bing',
      'https://duckduckgo.com/?q=': 'DuckDuckGo',
      'https://search.yahoo.com/search?p=': 'Yahoo',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Search Engine',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: engines.entries.map((entry) {
              final isSelected = entry.key == ref.read(settingsProvider).defaultSearchEngine;
              return ListTile(
                title: Text(
                  entry.value,
                  style: TextStyle(color: AppColors.textPrimaryDark),
                ),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : AppColors.textTertiaryDark,
                ),
                onTap: () {
                  ref.read(settingsProvider.notifier).setSearchEngine(entry.key);
                  Navigator.pop(context);
                },
              );
          }).toList(),
        ),
      ),
    );
  }

  void _showSummaryLengthDialog(BuildContext context, WidgetRef ref, int currentLength) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Summary Length',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${currentLength.round()} words',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Slider(
                  value: currentLength.toDouble(),
                  min: AppConstants.minSummaryLength.toDouble(),
                  max: AppConstants.maxSummaryLength.toDouble(),
                  divisions: 9,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      currentLength = value.round();
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).setSummaryLength(currentLength);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String currentLanguage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Default Language',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.supportedLanguages.length,
            itemBuilder: (context, index) {
              final entry = AppConstants.supportedLanguages.entries.elementAt(index);
              final isSelected = entry.key == currentLanguage;
              return ListTile(
                title: Text(
                  entry.value,
                  style: TextStyle(color: AppColors.textPrimaryDark),
                ),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : AppColors.textTertiaryDark,
                ),
                onTap: () {
                  ref.read(settingsProvider.notifier).setDefaultLanguage(entry.key);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Clear Browsing Data',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: Text(
          'This will clear your browsing history, page cache, downloaded files, and saved summaries. This action cannot be undone.',
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
              // Clear all data
              ref.read(fileProvider.notifier).clearAllDownloads();
              ref.read(aiProvider.notifier).clearAllSummaries();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Browsing data cleared')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
