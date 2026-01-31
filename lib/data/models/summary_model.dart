import 'package:hive/hive.dart';
import '../../domain/entities/summary.dart';

part 'summary_model.g.dart';

@HiveType(typeId: 2)
class SummaryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String sourceUrl;

  @HiveField(2)
  final String? sourceFilePath;

  @HiveField(3)
  final String originalText;

  @HiveField(4)
  final String summarizedText;

  @HiveField(5)
  final int originalWordCount;

  @HiveField(6)
  final int summarizedWordCount;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final int type;

  @HiveField(9)
  final List<TranslationModel> translations;

  SummaryModel({
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

  factory SummaryModel.fromEntity(Summary summary) {
    return SummaryModel(
      id: summary.id,
      sourceUrl: summary.sourceUrl,
      sourceFilePath: summary.sourceFilePath,
      originalText: summary.originalText,
      summarizedText: summary.summarizedText,
      originalWordCount: summary.originalWordCount,
      summarizedWordCount: summary.summarizedWordCount,
      createdAt: summary.createdAt,
      type: summary.type.index,
      translations: summary.translations
          .map((t) => TranslationModel.fromEntity(t))
          .toList(),
    );
  }

  Summary toEntity() {
    return Summary(
      id: id,
      sourceUrl: sourceUrl,
      sourceFilePath: sourceFilePath,
      originalText: originalText,
      summarizedText: summarizedText,
      originalWordCount: originalWordCount,
      summarizedWordCount: summarizedWordCount,
      createdAt: createdAt,
      type: SummaryType.values[type],
      translations: translations.map((t) => t.toEntity()).toList(),
    );
  }
}

@HiveType(typeId: 3)
class TranslationModel extends HiveObject {
  @HiveField(0)
  final String languageCode;

  @HiveField(1)
  final String languageName;

  @HiveField(2)
  final String translatedText;

  @HiveField(3)
  final DateTime createdAt;

  TranslationModel({
    required this.languageCode,
    required this.languageName,
    required this.translatedText,
    required this.createdAt,
  });

  factory TranslationModel.fromEntity(Translation translation) {
    return TranslationModel(
      languageCode: translation.languageCode,
      languageName: translation.languageName,
      translatedText: translation.translatedText,
      createdAt: translation.createdAt,
    );
  }

  Translation toEntity() {
    return Translation(
      languageCode: languageCode,
      languageName: languageName,
      translatedText: translatedText,
      createdAt: createdAt,
    );
  }
}
