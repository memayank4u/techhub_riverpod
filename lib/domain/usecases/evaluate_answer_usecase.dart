import '../repositories/interview_repository.dart';
import '../../core/common/resource.dart';

class EvaluateAnswerUseCase {
  final InterviewRepository repository;
  EvaluateAnswerUseCase(this.repository);

  Stream<Resource<String>> call(String question, String answer) {
    return repository.evaluateAnswer(question, answer);
  }
}
