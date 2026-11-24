import '../entities/interview_session_entity.dart';
import '../repositories/interview_repository.dart';

class SaveInterviewSessionUseCase {
  final InterviewRepository repository;
  SaveInterviewSessionUseCase(this.repository);

  Future<void> call(InterviewSessionEntity session) {
    return repository.saveSession(session);
  }
}
