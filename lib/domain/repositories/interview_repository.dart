import '../entities/interview_session_entity.dart';
import '../../core/common/resource.dart';

abstract class InterviewRepository {
  Stream<Resource<String>> generateQuestion(String topic, String level);
  Stream<Resource<String>> evaluateAnswer(String question, String answer);
  Future<void> saveSession(InterviewSessionEntity session);
  List<InterviewSessionEntity> getSavedSessions();
}
