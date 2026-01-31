/// Summary entity
class Summary {
  final String id;
  final String sourceUrl;
  final String? sourceFilePath;
  final String originalText;
  final String summarizedText;
  final int originalWordCount;
  final int summarizedWordCount;
  final DateTime createdAt;
  final SummaryType type;
  final List<Translation> translations;

  const Summary({
    required this.id,
    required this.sourceUrl,
    this.sourceFilePath,
    required this.originalText,
    required this.summarizedText,
    required this.originalWordCount,
    required this.summarizedWordCount,
    required this.createdAt,
    required this.type,
    this.translations = const [],
  });

  double get reductionPercentage {
    if (originalWordCount == 0) return 0;
    return ((originalWordCount - summarizedWordCount) / originalWordCount) * 100;
  }

  Summary copyWith({
    String? id,
    String? sourceUrl,
    String? sourceFilePath,
    String? originalText,
    String? summarizedText,
    int? originalWordCount,
    int? summarizedWordCount,
    DateTime? createdAt,
    SummaryType? type,
    List<Translation>? translations,
  }) {
    return Summary(
      id: id ?? this.id,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceFilePath: sourceFilePath ?? this.sourceFilePath,
      originalText: originalText ?? this.originalText,
      summarizedText: summarizedText ?? this.summarizedText,
      originalWordCount: originalWordCount ?? this.originalWordCount,
      summarizedWordCount: summarizedWordCount ?? this.summarizedWordCount,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      translations: translations ?? this.translations,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Summary && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Translation entity
class Translation {
  final String languageCode;
  final String languageName;
  final String translatedText;
  final DateTime createdAt;

  const Translation({
    required this.languageCode,
    required this.languageName,
    required this.translatedText,
    required this.createdAt,
  });

  Translation copyWith({
    String? languageCode,
    String? languageName,
    String? translatedText,
    DateTime? createdAt,
  }) {
    return Translation(
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
      translatedText: translatedText ?? this.translatedText,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum SummaryType {
  webpage,
  document,
}
