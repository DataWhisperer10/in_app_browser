import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/summary.dart';
import '../../domain/repositories/ai_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/summary_model.dart';

/// AI repository implementation with mock summarization and translation
class AIRepositoryImpl implements AIRepository {
  final LocalStorageDatasource _datasource;
  final Dio _dio;
  final Uuid _uuid = const Uuid();

  AIRepositoryImpl(this._datasource, this._dio);

  @override
  Future<Summary> summarizeText({
    required String text,
    required String sourceUrl,
    String? sourceFilePath,
    int maxLength = 150,
  }) async {
    // Check cache first
    final cached = await getCachedSummary(sourceUrl);
    if (cached != null) {
      return cached;
    }

    // Mock AI summarization - in production, replace with actual API call
    final summarizedText = _mockSummarize(text, maxLength);

    final summary = Summary(
      id: _uuid.v4(),
      sourceUrl: sourceUrl,
      sourceFilePath: sourceFilePath,
      originalText: text,
      summarizedText: summarizedText,
      originalWordCount: text.wordCount,
      summarizedWordCount: summarizedText.wordCount,
      createdAt: DateTime.now(),
      type: sourceFilePath != null ? SummaryType.document : SummaryType.webpage,
    );

    // Cache the summary
    await cacheSummary(summary);

    return summary;
  }

  /// Mock summarization algorithm
  /// In production, replace with actual AI API call
  String _mockSummarize(String text, int maxWords) {
    // Clean and split text into sentences
    final cleanText = text.stripHtml.trim();
    final sentences = cleanText.split(RegExp(r'[.!?]+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.wordCount > 3)
        .toList();

    if (sentences.isEmpty) {
      return cleanText.truncate(500);
    }

    // Score sentences by importance (simplified TF-IDF-like approach)
    final wordFrequency = <String, int>{};
    for (final sentence in sentences) {
      for (final word in sentence.toLowerCase().split(RegExp(r'\s+'))) {
        if (word.length > 3) {
          wordFrequency[word] = (wordFrequency[word] ?? 0) + 1;
        }
      }
    }

    // Score each sentence
    final scoredSentences = sentences.map((sentence) {
      final words = sentence.toLowerCase().split(RegExp(r'\s+'));
      final score = words
          .where((w) => w.length > 3)
          .fold<double>(0, (sum, word) => sum + (wordFrequency[word] ?? 0));
      return MapEntry(sentence, score / (words.length + 1));
    }).toList();

    // Sort by score and take top sentences
    scoredSentences.sort((a, b) => b.value.compareTo(a.value));

    final summary = StringBuffer();
    int wordCount = 0;

    for (final entry in scoredSentences) {
      final sentenceWordCount = entry.key.wordCount;
      if (wordCount + sentenceWordCount > maxWords && wordCount > 0) {
        break;
      }
      summary.write(entry.key);
      summary.write('. ');
      wordCount += sentenceWordCount;
    }

    return summary.toString().trim();
  }

  @override
  Future<Translation> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    // Mock translation - in production, use LibreTranslate or Google Translate API
    String translatedText;
    String languageName = AppConstants.supportedLanguages[targetLanguage] ?? targetLanguage;

    try {
      // Try to use LibreTranslate API
      final response = await _dio.post(
        'https://libretranslate.com/translate',
        data: jsonEncode({
          'q': text,
          'source': 'en',
          'target': targetLanguage,
          'format': 'text',
        }),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data['translatedText'] != null) {
        translatedText = response.data['translatedText'];
      } else {
        translatedText = _mockTranslate(text, targetLanguage);
      }
    } catch (e) {
      // Fallback to mock translation
      translatedText = _mockTranslate(text, targetLanguage);
    }

    return Translation(
      languageCode: targetLanguage,
      languageName: languageName,
      translatedText: translatedText,
      createdAt: DateTime.now(),
    );
  }

  /// Mock translation for offline/demo mode
  String _mockTranslate(String text, String targetLanguage) {
    // Simple mock - add language indicator
    final langName = AppConstants.supportedLanguages[targetLanguage] ?? targetLanguage;
    return '[$langName Translation]\n\n$text\n\n[Note: This is a demo translation. Connect to a translation API for actual translations.]';
  }

  @override
  Future<String> detectLanguage(String text) async {
    // Simple language detection mock
    // In production, use an actual API
    return 'en';
  }

  @override
  Future<Summary?> getCachedSummary(String sourceUrl) async {
    final model = _datasource.getSummaryByUrl(sourceUrl);
    return model?.toEntity();
  }

  @override
  Future<void> cacheSummary(Summary summary) async {
    await _datasource.saveSummary(SummaryModel.fromEntity(summary));
  }

  @override
  Future<List<Summary>> getAllSummaries() async {
    final models = _datasource.getSummaries();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> deleteSummary(String summaryId) async {
    await _datasource.deleteSummary(summaryId);
  }

  @override
  Future<void> clearSummaryCache() async {
    await _datasource.clearSummaries();
  }

  @override
  List<Map<String, String>> getSupportedLanguages() {
    return AppConstants.supportedLanguages.entries
        .map((e) => {'code': e.key, 'name': e.value})
        .toList();
  }
}
