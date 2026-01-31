import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/file_utils.dart';
import '../../domain/entities/downloaded_file.dart';
import '../providers/file_provider.dart';
import '../providers/ai_provider.dart';

/// Files screen for managing downloaded documents
class FilesScreen extends ConsumerWidget {
  const FilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileState = ref.watch(fileProvider);
    final storageUsage = ref.watch(storageUsageProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text('Files'),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _pickFile(context, ref),
            tooltip: 'Pick file',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            color: AppColors.cardDark,
            onSelected: (value) {
              if (value == 'clear') {
                _showClearConfirmation(context, ref);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: AppColors.error),
                    const SizedBox(width: 12),
                    Text('Clear all downloads'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Storage info
          _buildStorageInfo(storageUsage),
          // Files list
          Expanded(
            child: fileState.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  )
                : fileState.files.isEmpty
                    ? _buildEmptyState()
                    : _buildFilesList(fileState.files, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageInfo(AsyncValue<int> storageUsage) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(color: AppColors.borderDark),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.storage,
            color: AppColors.textSecondaryDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Storage Used',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                  ),
                ),
                storageUsage.when(
                  data: (size) => Text(
                    FileUtils.formatFileSize(size),
                    style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  loading: () => Text(
                    'Calculating...',
                    style: TextStyle(
                      color: AppColors.textTertiaryDark,
                      fontSize: 16,
                    ),
                  ),
                  error: (_, __) => Text(
                    'Unknown',
                    style: TextStyle(
                      color: AppColors.textTertiaryDark,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: AppColors.textTertiaryDark,
          ),
          const SizedBox(height: 16),
          Text(
            'No files yet',
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Download documents or pick files to summarize',
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildFilesList(List<DownloadedFile> files, WidgetRef ref) {
    // Sort by date (newest first)
    final sortedFiles = [...files]..sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedFiles.length,
      itemBuilder: (context, index) {
        return _FileItem(
          file: sortedFiles[index],
          onTap: () => _openFile(context, ref, sortedFiles[index]),
          onSummarize: () => _summarizeFile(context, ref, sortedFiles[index]),
          onDelete: () => _deleteFile(context, ref, sortedFiles[index]),
        ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(
              begin: 0.1,
              duration: 300.ms,
            );
      },
    );
  }

  Future<void> _pickFile(BuildContext context, WidgetRef ref) async {
    final path = await ref.read(fileProvider.notifier).pickFile();
    if (path != null && context.mounted) {
      _summarizeFile(context, ref, DownloadedFile(
        id: 'local',
        name: path.split('/').last,
        path: path,
        extension: '.${path.split('.').last}',
        size: 0,
        sourceUrl: 'file://$path',
        downloadedAt: DateTime.now(),
      ));
    }
  }

  Future<void> _openFile(BuildContext context, WidgetRef ref, DownloadedFile file) async {
    try {
      await ref.read(fileProvider.notifier).openFile(file.path);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open file')),
        );
      }
    }
  }

  Future<void> _summarizeFile(BuildContext context, WidgetRef ref, DownloadedFile file) async {
    // Extract text from file
    final text = await ref.read(fileProvider.notifier).extractText(file.path);
    if (text.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to extract text from file')),
        );
      }
      return;
    }

    // Summarize
    final summary = await ref.read(aiProvider.notifier).summarizeText(
          text: text,
          sourceUrl: file.sourceUrl,
          sourceFilePath: file.path,
        );

    if (summary != null && context.mounted) {
      _showSummaryDialog(context, ref, file.name, summary.summarizedText);
    }
  }

  void _showSummaryDialog(BuildContext context, WidgetRef ref, String fileName, String summary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Summary: $fileName',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: SingleChildScrollView(
          child: Text(
            summary,
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to full summary view
            },
            child: Text('View Full'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFile(BuildContext context, WidgetRef ref, DownloadedFile file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Delete File',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: Text(
          'Are you sure you want to delete "${file.name}"?',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(fileProvider.notifier).deleteFile(file.id);
    }
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: Text(
          'Clear All Downloads',
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        content: Text(
          'This will delete all downloaded files. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(fileProvider.notifier).clearAllDownloads();
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

class _FileItem extends StatelessWidget {
  final DownloadedFile file;
  final VoidCallback onTap;
  final VoidCallback onSummarize;
  final VoidCallback onDelete;

  const _FileItem({
    required this.file,
    required this.onTap,
    required this.onSummarize,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final icon = _getFileIcon(file.extension);
    final color = _getFileColor(file.extension);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // File icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // File info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          FileUtils.formatFileSize(file.size),
                          style: TextStyle(
                            color: AppColors.textTertiaryDark,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(color: AppColors.textTertiaryDark),
                        ),
                        Text(
                          dateFormat.format(file.downloadedAt),
                          style: TextStyle(
                            color: AppColors.textTertiaryDark,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (file.status == DownloadStatus.downloading) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: file.progress,
                        backgroundColor: AppColors.borderDark,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ],
                  ],
                ),
              ),
              // Actions
              IconButton(
                icon: Icon(Icons.auto_awesome, color: AppColors.primary),
                onPressed: onSummarize,
                tooltip: 'Summarize',
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, color: AppColors.textTertiaryDark),
                onPressed: onDelete,
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case '.pdf':
        return Icons.picture_as_pdf;
      case '.doc':
      case '.docx':
        return Icons.description;
      case '.xls':
      case '.xlsx':
        return Icons.table_chart;
      case '.ppt':
      case '.pptx':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColor(String extension) {
    switch (extension.toLowerCase()) {
      case '.pdf':
        return AppColors.error;
      case '.doc':
      case '.docx':
        return AppColors.info;
      case '.xls':
      case '.xlsx':
        return AppColors.success;
      case '.ppt':
      case '.pptx':
        return AppColors.warning;
      default:
        return AppColors.textSecondaryDark;
    }
  }
}
