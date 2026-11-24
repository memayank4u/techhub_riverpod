import 'package:equatable/equatable.dart';
import '../../../domain/entities/interview_session_entity.dart';

enum InterviewStep { setup, questionActive, evaluating, evaluationResult, history }

class InterviewState extends Equatable {
  final String selectedTopic;
  final String selectedLevel;
  final String currentQuestion;
  final String userAnswer;
  final bool isGeneratingQuestion;
  final bool isEvaluatingAnswer;
  final String streamingEvaluation;
  final InterviewStep step;
  final List<InterviewSessionEntity> historySessions;
  final String? errorMessage;

  const InterviewState({
    this.selectedTopic = 'Android & Jetpack',
    this.selectedLevel = 'Senior / Lead (5+ yrs)',
    this.currentQuestion = '',
    this.userAnswer = '',
    this.isGeneratingQuestion = false,
    this.isEvaluatingAnswer = false,
    this.streamingEvaluation = '',
    this.step = InterviewStep.setup,
    this.historySessions = const [],
    this.errorMessage,
  });

  InterviewState copyWith({
    String? selectedTopic,
    String? selectedLevel,
    String? currentQuestion,
    String? userAnswer,
    bool? isGeneratingQuestion,
    bool? isEvaluatingAnswer,
    String? streamingEvaluation,
    InterviewStep? step,
    List<InterviewSessionEntity>? historySessions,
    String? errorMessage,
  }) {
    return InterviewState(
      selectedTopic: selectedTopic ?? this.selectedTopic,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      userAnswer: userAnswer ?? this.userAnswer,
      isGeneratingQuestion: isGeneratingQuestion ?? this.isGeneratingQuestion,
      isEvaluatingAnswer: isEvaluatingAnswer ?? this.isEvaluatingAnswer,
      streamingEvaluation: streamingEvaluation ?? this.streamingEvaluation,
      step: step ?? this.step,
      historySessions: historySessions ?? this.historySessions,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedTopic,
        selectedLevel,
        currentQuestion,
        userAnswer,
        isGeneratingQuestion,
        isEvaluatingAnswer,
        streamingEvaluation,
        step,
        historySessions,
        errorMessage,
      ];
}
