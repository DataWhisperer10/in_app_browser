import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/summary.dart';
import '../providers/ai_provider.dart';

/// Collapsible AI summary panel widget
class SummaryPanel extends ConsumerStatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onSummarize;
  final String? pageContent;

  const SummaryPanel({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.onSummarize,
    this.pageContent,
  });

  @override
  ConsumerState<SummaryPanel> createState() => _SummaryPanelState();
}

class _SummaryPanelState extends ConsumerState<SummaryPanel> {
  bool _showTranslation = false;

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiProvider);
    final summary = aiState.currentSummary;
    final translation = aiState.currentTranslation;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: widget.isExpanded ? 320 : 56,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle and header
          _buildHeader(aiState),
          // Content
          if (widget.isExpanded)
            Expanded(
              child: _buildContent(summary, translation, aiState),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(AIState aiState) {
    return GestureDetector(
      onTap: widget.onToggle,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // AI icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 18,
                color: AppColors.backgroundDark,
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Summary',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  if (aiState.currentSummary != null)
                    Text(
                      '${aiState.currentSummary!.reductionPercentage.toStringAsFixed(0)}% reduction',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            ),
            // Summarize button
            if (!widget.isExpanded && !aiState.isSummarizing)
              TextButton.icon(
                onPressed: widget.onSummarize,
                icon: Icon(Icons.summarize, size: 18),
                label: Text('Summarize'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            if (aiState.isSummarizing)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            // Expand/collapse icon
            Icon(
              widget.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              color: AppColors.textSecondaryDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(Summary? summary, Translation? translation, AIState aiState) {
    if (aiState.isSummarizing) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Analyzing content...',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 200.ms);
    }

    if (summary == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.summarize,
              size: 48,
              color: AppColors.textTertiaryDark,
            ),
            const SizedBox(height: 16),
            Text(
              'Tap to summarize this page',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: widget.onSummarize,
              icon: Icon(Icons.auto_awesome),
              label: Text('Generate Summary'),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 200.ms);
    }

    return Column(
      children: [
        // Stats bar
        _buildStatsBar(summary),
        // Language selector and toggle
        _buildLanguageSelector(aiState),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showTranslation && translation != null) ...[
                  _buildTranslationContent(translation),
                ] else ...[
                  _buildSummaryContent(summary),
                ],
              ],
            ),
          ),
        ),
        // Actions
        _buildActions(summary, translation),
      ],
    ).animate().fadeIn(duration: 200.ms);
  }

  Widget _buildStatsBar(Summary summary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        border: Border(
          bottom: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Original',
            value: '${summary.originalWordCount}',
            unit: 'words',
          ),
          Container(
            width: 1,
            height: 24,
            color: AppColors.borderDark,
          ),
          _StatItem(
            label: 'Summary',
            value: '${summary.summarizedWordCount}',
            unit: 'words',
          ),
          Container(
            width: 1,
            height: 24,
            color: AppColors.borderDark,
          ),
          _StatItem(
            label: 'Reduced',
            value: '${summary.reductionPercentage.toStringAsFixed(0)}%',
            unit: '',
            valueColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(AIState aiState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Translation toggle
          if (aiState.currentSummary != null) ...[
            ChoiceChip(
              label: Text('Summary'),
              selected: !_showTranslation,
              onSelected: (_) => setState(() => _showTranslation = false),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: Text('Translation'),
              selected: _showTranslation,
              onSelected: (_) => setState(() => _showTranslation = true),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
            ),
          ],
          const Spacer(),
          // Language dropdown
          if (_showTranslation)
            DropdownButton<String>(
              value: aiState.selectedLanguage,
              dropdownColor: AppColors.cardDark,
              underline: const SizedBox(),
              items: AppConstants.supportedLanguages.entries
                  .where((e) => e.key != 'en')
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(
                          e.value,
                          style: TextStyle(color: AppColors.textPrimaryDark),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(aiProvider.notifier).setSelectedLanguage(value);
                  // Translate with new language
                  if (aiState.currentSummary != null) {
                    ref.read(aiProvider.notifier).translateSummary(
                          text: aiState.currentSummary!.summarizedText,
                          targetLanguage: value,
                        );
                  }
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryContent(Summary summary) {
    return Text(
      summary.summarizedText,
      style: TextStyle(
        fontSize: 15,
        height: 1.6,
        color: AppColors.textPrimaryDark,
      ),
    );
  }

  Widget _buildTranslationContent(Translation translation) {
    final aiState = ref.watch(aiProvider);
    
    if (aiState.isTranslating) {
      return Center(
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              'Translating...',
              style: TextStyle(color: AppColors.textSecondaryDark),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            translation.languageName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          translation.translatedText,
          style: TextStyle(
            fontSize: 15,
            height: 1.6,
            color: AppColors.textPrimaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(Summary summary, Translation? translation) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.copy,
            label: 'Copy',
            onTap: () {
              final text = _showTranslation && translation != null
                  ? translation.translatedText
                  : summary.summarizedText;
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied to clipboard')),
              );
            },
          ),
          _ActionButton(
            icon: Icons.share,
            label: 'Share',
            onTap: () {
              final text = _showTranslation && translation != null
                  ? translation.translatedText
                  : summary.summarizedText;
              Share.share(text);
            },
          ),
          _ActionButton(
            icon: Icons.translate,
            label: 'Translate',
            onTap: () {
              setState(() => _showTranslation = true);
              if (translation == null) {
                ref.read(aiProvider.notifier).translateSummary(
                      text: summary.summarizedText,
                    );
              }
            },
          ),
          _ActionButton(
            icon: Icons.refresh,
            label: 'Regenerate',
            onTap: widget.onSummarize,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color? valueColor;

  const _StatItem({
    required this.label,
    required this.value,
    required this.unit,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.textTertiaryDark,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimaryDark,
              ),
            ),
            if (unit.isNotEmpty)
              Text(
                ' $unit',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiaryDark,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: AppColors.textSecondaryDark,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textTertiaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
