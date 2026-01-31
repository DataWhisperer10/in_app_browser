import 'package:hive/hive.dart';
import '../../domain/entities/downloaded_file.dart';

part 'downloaded_file_model.g.dart';

@HiveType(typeId: 1)
class DownloadedFileModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path;

  @HiveField(3)
  final String extension;

  @HiveField(4)
  final int size;

  @HiveField(5)
  final String sourceUrl;

  @HiveField(6)
  final DateTime downloadedAt;

  @HiveField(7)
  final int status;

  @HiveField(8)
  final double progress;

  @HiveField(9)
  final String? error;

  DownloadedFileModel({
    required this.id,
    required this.name,
    required this.path,
    required this.extension,
    required this.size,
    required this.sourceUrl,
    required this.downloadedAt,
    required this.status,
    this.progress = 1.0,
    this.error,
  });

  factory DownloadedFileModel.fromEntity(DownloadedFile file) {
    return DownloadedFileModel(
      id: file.id,
      name: file.name,
      path: file.path,
      extension: file.extension,
      size: file.size,
      sourceUrl: file.sourceUrl,
      downloadedAt: file.downloadedAt,
      status: file.status.index,
      progress: file.progress,
      error: file.error,
    );
  }

  DownloadedFile toEntity() {
    return DownloadedFile(
      id: id,
      name: name,
      path: path,
      extension: extension,
      size: size,
      sourceUrl: sourceUrl,
      downloadedAt: downloadedAt,
      status: DownloadStatus.values[status],
      progress: progress,
      error: error,
    );
  }
}
