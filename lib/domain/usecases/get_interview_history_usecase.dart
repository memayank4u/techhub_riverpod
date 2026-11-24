import '../entities/interview_session_entity.dart';
import '../repositories/interview_repository.dart';

class GetInterviewHistoryUseCase {
  final InterviewRepository repository;
  GetInterviewHistoryUseCase(this.repository);

  List<InterviewSessionEntity> call() {
    return repository.getSavedSessions();
  }
}
