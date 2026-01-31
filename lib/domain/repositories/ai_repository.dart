import '../entities/summary.dart';

/// AI repository interface
abstract class AIRepository {
  /// Generate summary from text
  Future<Summary> summarizeText({
    required String text,
    required String sourceUrl,
    String? sourceFilePath,
    int maxLength,
  });

  /// Translate text
  Future<Translation> translateText({
    required String text,
    required String targetLanguage,
  });

  /// Detect language
  Future<String> detectLanguage(String text);

  /// Get cached summary
  Future<Summary?> getCachedSummary(String sourceUrl);

  /// Save summary to cache
  Future<void> cacheSummary(Summary summary);

  /// Get all summaries
  Future<List<Summary>> getAllSummaries();

  /// Delete summary
  Future<void> deleteSummary(String summaryId);

  /// Clear summary cache
  Future<void> clearSummaryCache();

  /// Get supported languages
  List<Map<String, String>> getSupportedLanguages();
}
