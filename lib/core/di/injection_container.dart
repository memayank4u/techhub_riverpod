import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/article_local_datasource.dart';
import '../../data/datasources/article_remote_datasource.dart';
import '../../data/datasources/crypto_local_datasource.dart';
import '../../data/datasources/crypto_remote_datasource.dart';
import '../../data/datasources/interview_local_datasource.dart';
import '../../data/datasources/interview_remote_datasource.dart';

import '../../data/repositories/article_repository_impl.dart';
import '../../data/repositories/crypto_repository_impl.dart';
import '../../data/repositories/interview_repository_impl.dart';

import '../../domain/repositories/article_repository.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../../domain/repositories/interview_repository.dart';

import '../../domain/usecases/evaluate_answer_usecase.dart';
import '../../domain/usecases/generate_question_usecase.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/get_bookmarks_usecase.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/get_interview_history_usecase.dart';
import '../../domain/usecases/save_interview_session_usecase.dart';
import '../../domain/usecases/search_coins_usecase.dart';
import '../../domain/usecases/toggle_bookmark_usecase.dart';

import '../../presentation/blocs/articles/articles_bloc.dart';
import '../../presentation/blocs/crypto/crypto_bloc.dart';
import '../../presentation/blocs/interview/interview_bloc.dart';
import '../theme/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // DataSources
  sl.registerLazySingleton<CryptoRemoteDataSource>(
      () => CryptoRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CryptoLocalDataSource>(
      () => CryptoLocalDataSourceImpl());

  sl.registerLazySingleton<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ArticleLocalDataSource>(
      () => ArticleLocalDataSourceImpl());

  sl.registerLazySingleton<InterviewRemoteDataSource>(
      () => InterviewRemoteDataSourceImpl());
  sl.registerLazySingleton<InterviewLocalDataSource>(
      () => InterviewLocalDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<CryptoRepository>(() => CryptoRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  sl.registerLazySingleton<ArticleRepository>(() => ArticleRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  sl.registerLazySingleton<InterviewRepository>(() => InterviewRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => GetCoinsUseCase(sl()));
  sl.registerLazySingleton(() => SearchCoinsUseCase(sl()));

  sl.registerLazySingleton(() => GetArticlesUseCase(sl()));
  sl.registerLazySingleton(() => GetBookmarksUseCase(sl()));
  sl.registerLazySingleton(() => ToggleBookmarkUseCase(sl()));

  sl.registerLazySingleton(() => GenerateQuestionUseCase(sl()));
  sl.registerLazySingleton(() => EvaluateAnswerUseCase(sl()));
  sl.registerLazySingleton(() => GetInterviewHistoryUseCase(sl()));
  sl.registerLazySingleton(() => SaveInterviewSessionUseCase(sl()));

  // Blocs & Cubits
  sl.registerFactory(() => ThemeCubit());
  sl.registerFactory(() => CryptoBloc(
        getCoinsUseCase: sl(),
        searchCoinsUseCase: sl(),
      ));
  sl.registerFactory(() => ArticlesBloc(
        getArticlesUseCase: sl(),
        getBookmarksUseCase: sl(),
        toggleBookmarkUseCase: sl(),
      ));
  sl.registerFactory(() => InterviewBloc(
        generateQuestionUseCase: sl(),
        evaluateAnswerUseCase: sl(),
        getHistoryUseCase: sl(),
        saveSessionUseCase: sl(),
      ));
}
