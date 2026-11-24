import '../../core/common/resource.dart';
import '../../domain/entities/interview_session_entity.dart';
import '../../domain/repositories/interview_repository.dart';
import '../datasources/interview_local_datasource.dart';
import '../datasources/interview_remote_datasource.dart';
import '../models/interview_session_model.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewRemoteDataSource remoteDataSource;
  final InterviewLocalDataSource localDataSource;

  InterviewRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Resource<String>> generateQuestion(String topic, String level) async* {
    yield const ResourceLoading();
    try {
      final question = await remoteDataSource.generateQuestion(topic, level);
      yield ResourceSuccess(question);
    } catch (e) {
      yield ResourceError('Failed to generate question: $e');
    }
  }

  @override
  Stream<Resource<String>> evaluateAnswer(String question, String answer) async* {
    yield const ResourceLoading();
    try {
      await for (final streamText in remoteDataSource.evaluateAnswer(question, answer)) {
        yield ResourceSuccess(streamText);
      }
    } catch (e) {
      yield ResourceError('Evaluation error: $e');
    }
  }

  @override
  Future<void> saveSession(InterviewSessionEntity session) async {
    final model = InterviewSessionModel(
      id: session.id,
      topic: session.topic,
      level: session.level,
      question: session.question,
      userAnswer: session.userAnswer,
      score: session.score,
      evaluationFeedback: session.evaluationFeedback,
      timestamp: session.timestamp,
    );
    await localDataSource.saveSession(model);
  }

  @override
  List<InterviewSessionEntity> getSavedSessions() {
    return localDataSource.getSavedSessions();
  }
}
