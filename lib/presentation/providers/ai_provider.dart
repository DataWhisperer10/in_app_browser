import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/summary.dart';
import 'providers.dart';

/// AI state
class AIState {
  final Summary? currentSummary;
  final Translation? currentTranslation;
  final List<Summary> summaryHistory;
  final bool isSummarizing;
  final bool isTranslating;
  final String? error;
  final String selectedLanguage;

  const AIState({
    this.currentSummary,
    this.currentTranslation,
    this.summaryHistory = const [],
    this.isSummarizing = false,
    this.isTranslating = false,
    this.error,
    this.selectedLanguage = 'hi',
  });

  AIState copyWith({
    Summary? currentSummary,
    Translation? currentTranslation,
    List<Summary>? summaryHistory,
    bool? isSummarizing,
    bool? isTranslating,
    String? error,
    String? selectedLanguage,
  }) {
    return AIState(
      currentSummary: currentSummary ?? this.currentSummary,
      currentTranslation: currentTranslation ?? this.currentTranslation,
      summaryHistory: summaryHistory ?? this.summaryHistory,
      isSummarizing: isSummarizing ?? this.isSummarizing,
      isTranslating: isTranslating ?? this.isTranslating,
      error: error,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

/// AI state notifier
class AINotifier extends StateNotifier<AIState> {
  final Ref _ref;

  AINotifier(this._ref) : super(const AIState()) {
    _loadSummaryHistory();
  }

  Future<void> _loadSummaryHistory() async {
    try {
      final repository = _ref.read(aiRepositoryProvider);
      final summaries = await repository.getAllSummaries();
      state = state.copyWith(summaryHistory: summaries);
    } catch (e) {
      // Ignore errors during initialization
    }
  }

  Future<Summary?> summarizeText({
    required String text,
    required String sourceUrl,
    String? sourceFilePath,
    int? maxLength,
  }) async {
    try {
      state = state.copyWith(isSummarizing: true, error: null);
      
      final repository = _ref.read(aiRepositoryProvider);
      final summary = await repository.summarizeText(
        text: text,
        sourceUrl: sourceUrl,
        sourceFilePath: sourceFilePath,
        maxLength: maxLength ?? 150,
      );

      final updatedHistory = [summary, ...state.summaryHistory];
      state = state.copyWith(
        currentSummary: summary,
        summaryHistory: updatedHistory,
        isSummarizing: false,
      );

      return summary;
    } catch (e) {
      state = state.copyWith(isSummarizing: false, error: e.toString());
      return null;
    }
  }

  Future<Translation?> translateSummary({
    required String text,
    String? targetLanguage,
  }) async {
    try {
      state = state.copyWith(isTranslating: true, error: null);
      
      final repository = _ref.read(aiRepositoryProvider);
      final translation = await repository.translateText(
        text: text,
        targetLanguage: targetLanguage ?? state.selectedLanguage,
      );

      // Update current summary with translation
      if (state.currentSummary != null) {
        final updatedTranslations = [
          ...state.currentSummary!.translations,
          translation,
        ];
        final updatedSummary = state.currentSummary!.copyWith(
          translations: updatedTranslations,
        );

        // Cache the updated summary
        await repository.cacheSummary(updatedSummary);

        state = state.copyWith(
          currentSummary: updatedSummary,
          currentTranslation: translation,
          isTranslating: false,
        );
      } else {
        state = state.copyWith(
          currentTranslation: translation,
          isTranslating: false,
        );
      }

      return translation;
    } catch (e) {
      state = state.copyWith(isTranslating: false, error: e.toString());
      return null;
    }
  }

  void setSelectedLanguage(String languageCode) {
    state = state.copyWith(selectedLanguage: languageCode);
  }

  Future<void> deleteSummary(String summaryId) async {
    try {
      final repository = _ref.read(aiRepositoryProvider);
      await repository.deleteSummary(summaryId);
      
      final updatedHistory = state.summaryHistory
          .where((s) => s.id != summaryId)
          .toList();
      
      state = state.copyWith(
        summaryHistory: updatedHistory,
        currentSummary: state.currentSummary?.id == summaryId
            ? null
            : state.currentSummary,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setSummary(Summary summary) {
    state = state.copyWith(currentSummary: summary);
  }

  void clearCurrentSummary() {
    state = state.copyWith(
      currentSummary: null,
      currentTranslation: null,
    );
  }

  Future<void> clearAllSummaries() async {
    try {
      final repository = _ref.read(aiRepositoryProvider);
      await repository.clearSummaryCache();
      state = state.copyWith(
        summaryHistory: [],
        currentSummary: null,
        currentTranslation: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  List<Map<String, String>> getSupportedLanguages() {
    final repository = _ref.read(aiRepositoryProvider);
    return repository.getSupportedLanguages();
  }
}

/// AI provider
final aiProvider = StateNotifierProvider<AINotifier, AIState>((ref) {
  return AINotifier(ref);
});

/// Supported languages provider
final supportedLanguagesProvider = Provider<List<Map<String, String>>>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return repository.getSupportedLanguages();
});
