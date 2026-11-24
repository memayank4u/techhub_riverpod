import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';
import '../database/hive_service.dart';
import '../../data/datasources/crypto_remote_datasource.dart';
import '../../data/datasources/crypto_local_datasource.dart';
import '../../data/repositories/crypto_repository_impl.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/search_coins_usecase.dart';
import '../../data/datasources/article_remote_datasource.dart';
import '../../data/datasources/article_local_datasource.dart';
import '../../data/repositories/article_repository_impl.dart';
import '../../domain/repositories/article_repository.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/get_bookmarks_usecase.dart';
import '../../domain/usecases/toggle_bookmark_usecase.dart';
import '../../data/datasources/interview_remote_datasource.dart';
import '../../data/datasources/interview_local_datasource.dart';
import '../../data/repositories/interview_repository_impl.dart';
import '../../domain/repositories/interview_repository.dart';
import '../../domain/usecases/generate_question_usecase.dart';
import '../../domain/usecases/evaluate_answer_usecase.dart';
import '../../domain/usecases/get_interview_history_usecase.dart';
import '../../domain/usecases/save_interview_session_usecase.dart';

// Storage Provider
final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

// Network Client Provider (Dio with Interceptors & Timeouts)
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

// Remote Data Sources
final cryptoRemoteDataSourceProvider = Provider<CryptoRemoteDataSource>((ref) {
  return CryptoRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final cryptoLocalDataSourceProvider = Provider<CryptoLocalDataSource>((ref) {
  return CryptoLocalDataSourceImpl();
});

// Crypto Repository & UseCases
final cryptoRepositoryProvider = Provider<CryptoRepository>((ref) {
  return CryptoRepositoryImpl(
    remoteDataSource: ref.watch(cryptoRemoteDataSourceProvider),
    localDataSource: ref.watch(cryptoLocalDataSourceProvider),
  );
});

final getCoinsUseCaseProvider = Provider<GetCoinsUseCase>((ref) {
  return GetCoinsUseCase(ref.watch(cryptoRepositoryProvider));
});

final searchCoinsUseCaseProvider = Provider<SearchCoinsUseCase>((ref) {
  return SearchCoinsUseCase(ref.watch(cryptoRepositoryProvider));
});

// Article Providers
final articleRemoteDataSourceProvider = Provider<ArticleRemoteDataSource>((ref) {
  return ArticleRemoteDataSourceImpl(ref.watch(dioClientProvider));
});

final articleLocalDataSourceProvider = Provider<ArticleLocalDataSource>((ref) {
  return ArticleLocalDataSourceImpl();
});

final articleRepositoryProvider = Provider<ArticleRepository>((ref) {
  return ArticleRepositoryImpl(
    remoteDataSource: ref.watch(articleRemoteDataSourceProvider),
    localDataSource: ref.watch(articleLocalDataSourceProvider),
  );
});

final getArticlesUseCaseProvider = Provider<GetArticlesUseCase>((ref) {
  return GetArticlesUseCase(ref.watch(articleRepositoryProvider));
});

final getBookmarksUseCaseProvider = Provider<GetBookmarksUseCase>((ref) {
  return GetBookmarksUseCase(ref.watch(articleRepositoryProvider));
});

final toggleBookmarkUseCaseProvider = Provider<ToggleBookmarkUseCase>((ref) {
  return ToggleBookmarkUseCase(ref.watch(articleRepositoryProvider));
});

// Interview Providers
final interviewRemoteDataSourceProvider = Provider<InterviewRemoteDataSource>((ref) {
  return InterviewRemoteDataSourceImpl();
});

final interviewLocalDataSourceProvider = Provider<InterviewLocalDataSource>((ref) {
  return InterviewLocalDataSourceImpl();
});

final interviewRepositoryProvider = Provider<InterviewRepository>((ref) {
  return InterviewRepositoryImpl(
    remoteDataSource: ref.watch(interviewRemoteDataSourceProvider),
    localDataSource: ref.watch(interviewLocalDataSourceProvider),
  );
});

final generateQuestionUseCaseProvider = Provider<GenerateQuestionUseCase>((ref) {
  return GenerateQuestionUseCase(ref.watch(interviewRepositoryProvider));
});

final evaluateAnswerUseCaseProvider = Provider<EvaluateAnswerUseCase>((ref) {
  return EvaluateAnswerUseCase(ref.watch(interviewRepositoryProvider));
});

final getInterviewHistoryUseCaseProvider = Provider<GetInterviewHistoryUseCase>((ref) {
  return GetInterviewHistoryUseCase(ref.watch(interviewRepositoryProvider));
});

final saveInterviewSessionUseCaseProvider = Provider<SaveInterviewSessionUseCase>((ref) {
  return SaveInterviewSessionUseCase(ref.watch(interviewRepositoryProvider));
});
