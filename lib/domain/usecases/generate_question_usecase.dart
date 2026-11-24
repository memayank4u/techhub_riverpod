import '../repositories/interview_repository.dart';
import '../../core/common/resource.dart';

class GenerateQuestionUseCase {
  final InterviewRepository repository;
  GenerateQuestionUseCase(this.repository);

  Stream<Resource<String>> call(String topic, String level) {
    return repository.generateQuestion(topic, level);
  }
}
