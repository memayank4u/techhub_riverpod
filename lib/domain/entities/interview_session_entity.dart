import 'package:equatable/equatable.dart';

class InterviewSessionEntity extends Equatable {
  final String id;
  final String topic;
  final String level;
  final String question;
  final String userAnswer;
  final int score;
  final String evaluationFeedback;
  final int timestamp;

  const InterviewSessionEntity({
    required this.id,
    required this.topic,
    required this.level,
    required this.question,
    required this.userAnswer,
    required this.score,
    required this.evaluationFeedback,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        topic,
        level,
        question,
        userAnswer,
        score,
        evaluationFeedback,
        timestamp,
      ];
}
