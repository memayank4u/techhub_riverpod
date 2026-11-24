import '../../domain/entities/interview_session_entity.dart';

class InterviewSessionModel extends InterviewSessionEntity {
  const InterviewSessionModel({
    required super.id,
    required super.topic,
    required super.level,
    required super.question,
    required super.userAnswer,
    required super.score,
    required super.evaluationFeedback,
    required super.timestamp,
  });

  factory InterviewSessionModel.fromJson(Map<String, dynamic> json) {
    return InterviewSessionModel(
      id: json['id'] ?? '',
      topic: json['topic'] ?? '',
      level: json['level'] ?? '',
      question: json['question'] ?? '',
      userAnswer: json['userAnswer'] ?? '',
      score: (json['score'] as num?)?.toInt() ?? 8,
      evaluationFeedback: json['evaluationFeedback'] ?? '',
      timestamp: (json['timestamp'] as num?)?.toInt() ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'topic': topic,
      'level': level,
      'question': question,
      'userAnswer': userAnswer,
      'score': score,
      'evaluationFeedback': evaluationFeedback,
      'timestamp': timestamp,
    };
  }
}
