import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/common/resource.dart';
import '../../domain/entities/interview_session_entity.dart';
import '../../domain/usecases/evaluate_answer_usecase.dart';
import '../../domain/usecases/generate_question_usecase.dart';
import '../../domain/usecases/get_interview_history_usecase.dart';
import '../../domain/usecases/save_interview_session_usecase.dart';
import '../../core/di/providers.dart';
import 'interview_state.dart';

class InterviewNotifier extends StateNotifier<InterviewState> {
  final GenerateQuestionUseCase _generateQuestionUseCase;
  final EvaluateAnswerUseCase _evaluateAnswerUseCase;
  final GetInterviewHistoryUseCase _getHistoryUseCase;
  final SaveInterviewSessionUseCase _saveSessionUseCase;
  StreamSubscription? _sub;

  InterviewNotifier({
    required GenerateQuestionUseCase generateQuestionUseCase,
    required EvaluateAnswerUseCase evaluateAnswerUseCase,
    required GetInterviewHistoryUseCase getHistoryUseCase,
    required SaveInterviewSessionUseCase saveSessionUseCase,
  })  : _generateQuestionUseCase = generateQuestionUseCase,
        _evaluateAnswerUseCase = evaluateAnswerUseCase,
        _getHistoryUseCase = getHistoryUseCase,
        _saveSessionUseCase = saveSessionUseCase,
        super(const InterviewState());

  void selectTopic(String topic) => state = state.copyWith(selectedTopic: topic);
  void selectLevel(String level) => state = state.copyWith(selectedLevel: level);
  void updateAnswer(String answer) => state = state.copyWith(userAnswer: answer);

  void reset() => state = state.copyWith(
        currentQuestion: '',
        userAnswer: '',
        streamingEvaluation: '',
        step: InterviewStep.setup,
      );

  void backToSetup() => state = state.copyWith(step: InterviewStep.setup);

  void viewHistory() {
    final history = _getHistoryUseCase();
    state = state.copyWith(step: InterviewStep.history, historySessions: history);
  }

  void requestQuestion() {
    state = state.copyWith(isGeneratingQuestion: true, errorMessage: null);

    _sub?.cancel();
    _sub = _generateQuestionUseCase(state.selectedTopic, state.selectedLevel).listen(
      (resource) {
        if (resource is ResourceSuccess) {
          state = state.copyWith(
            isGeneratingQuestion: false,
            currentQuestion: resource.data ?? '',
            userAnswer: '',
            streamingEvaluation: '',
            step: InterviewStep.questionActive,
          );
        } else if (resource is ResourceError) {
          state = state.copyWith(
            isGeneratingQuestion: false,
            errorMessage: resource.message,
          );
        }
      },
    );
  }

  void submitAnswer() {
    if (state.userAnswer.trim().isEmpty) return;

    state = state.copyWith(
      step: InterviewStep.evaluating,
      isEvaluatingAnswer: true,
      streamingEvaluation: '',
    );

    String finalEvaluation = '';

    _sub?.cancel();
    _sub = _evaluateAnswerUseCase(state.currentQuestion, state.userAnswer).listen(
      (resource) {
        if (resource is ResourceSuccess) {
          finalEvaluation = resource.data ?? '';
          state = state.copyWith(
            isEvaluatingAnswer: false,
            streamingEvaluation: finalEvaluation,
            step: InterviewStep.evaluationResult,
          );
        }
      },
      onDone: () async {
        if (finalEvaluation.isNotEmpty) {
          final score = _extractScore(finalEvaluation);
          final session = InterviewSessionEntity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            topic: state.selectedTopic,
            level: state.selectedLevel,
            question: state.currentQuestion,
            userAnswer: state.userAnswer,
            score: score,
            evaluationFeedback: finalEvaluation,
            timestamp: DateTime.now().millisecondsSinceEpoch,
          );
          await _saveSessionUseCase(session);
        }
      },
    );
  }

  int _extractScore(String text) {
    final match = RegExp(r'(\d+)/10').firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '8') ?? 8;
    }
    return 8;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final interviewNotifierProvider =
    StateNotifierProvider<InterviewNotifier, InterviewState>((ref) {
  return InterviewNotifier(
    generateQuestionUseCase: ref.watch(generateQuestionUseCaseProvider),
    evaluateAnswerUseCase: ref.watch(evaluateAnswerUseCaseProvider),
    getHistoryUseCase: ref.watch(getInterviewHistoryUseCaseProvider),
    saveSessionUseCase: ref.watch(saveInterviewSessionUseCaseProvider),
  );
});
