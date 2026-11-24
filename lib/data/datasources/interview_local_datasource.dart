import 'package:hive/hive.dart';
import '../../core/database/hive_service.dart';
import '../models/interview_session_model.dart';

abstract class InterviewLocalDataSource {
  List<InterviewSessionModel> getSavedSessions();
  Future<void> saveSession(InterviewSessionModel session);
}

class InterviewLocalDataSourceImpl implements InterviewLocalDataSource {
  static const String keySessions = 'saved_interview_sessions';

  @override
  List<InterviewSessionModel> getSavedSessions() {
    try {
      final box = Hive.box(HiveService.interviewBox);
      final rawList = box.get(keySessions);
      if (rawList is List) {
        return rawList
            .map((item) => InterviewSessionModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> saveSession(InterviewSessionModel session) async {
    final box = Hive.box(HiveService.interviewBox);
    final current = getSavedSessions();
    current.insert(0, session); // Newest first
    await box.put(keySessions, current.map((s) => s.toMap()).toList());
  }
}
