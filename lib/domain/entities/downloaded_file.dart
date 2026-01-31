/// Downloaded file entity
class DownloadedFile {
  final String id;
  final String name;
  final String path;
  final String extension;
  final int size;
  final String sourceUrl;
  final DateTime downloadedAt;
  final DownloadStatus status;
  final double progress;
  final String? error;

  const DownloadedFile({
    required this.id,
    required this.name,
    required this.path,
    required this.extension,
    required this.size,
    required this.sourceUrl,
    required this.downloadedAt,
    this.status = DownloadStatus.completed,
    this.progress = 1.0,
    this.error,
  });

  DownloadedFile copyWith({
    String? id,
    String? name,
    String? path,
    String? extension,
    int? size,
    String? sourceUrl,
    DateTime? downloadedAt,
    DownloadStatus? status,
    double? progress,
    String? error,
  }) {
    return DownloadedFile(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      extension: extension ?? this.extension,
      size: size ?? this.size,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedFile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum DownloadStatus {
  pending,
  downloading,
  completed,
  failed,
  cancelled,
}
