import 'package:google_generative_ai/google_generative_ai.dart';

abstract class InterviewRemoteDataSource {
  Future<String> generateQuestion(String topic, String level);
  Stream<String> evaluateAnswer(String question, String answer);
}

class InterviewRemoteDataSourceImpl implements InterviewRemoteDataSource {
  final String apiKey;
  GenerativeModel? _model;

  InterviewRemoteDataSourceImpl({this.apiKey = ''}) {
    if (apiKey.isNotEmpty) {
      _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    }
  }

  @override
  Future<String> generateQuestion(String topic, String level) async {
    if (_model != null) {
      try {
        final prompt =
            'You are an expert technical interviewer. Generate exactly ONE practical interview question for a candidate with $level level of experience on "$topic". Output only the question without conversational text.';
        final response = await _model!.generateContent([Content.text(prompt)]);
        if (response.text != null && response.text!.trim().isNotEmpty) {
          return response.text!.trim();
        }
      } catch (_) {}
    }
    return _getFallbackQuestion(topic, level);
  }

  @override
  Stream<String> evaluateAnswer(String question, String answer) async* {
    if (_model != null) {
      try {
        final prompt = '''
          You are an expert technical interviewer evaluating an interview response.
          Question: "$question"
          Candidate Answer: "$answer"

          Evaluate this answer with:
          1. Score: [Number between 1 and 10]/10
          2. Key Strengths: (What the candidate explained accurately)
          3. Areas for Improvement: (What nuances or edge cases were missed)
          4. Ideal Answer: (Brief summary of the ideal response)

          Format clearly with bullet points.
        ''';

        final responseStream = _model!.generateContentStream([Content.text(prompt)]);
        String accumulated = '';

        await for (final chunk in responseStream) {
          if (chunk.text != null) {
            accumulated += chunk.text!;
            yield accumulated;
          }
        }
        if (accumulated.isNotEmpty) return;
      } catch (_) {}
    }

    // Offline / fallback streaming simulation
    final fallback = _getFallbackEvaluation(answer);
    final words = fallback.split(' ');
    String current = '';
    for (final word in words) {
      current += '$word ';
      yield current;
      await Future.delayed(const Duration(milliseconds: 30));
    }
  }

  String _getFallbackQuestion(String topic, String level) {
    if (topic.contains('Flutter')) {
      return 'Explain the architectural differences between BLoC, Riverpod, and GetX in Flutter. How do each manage reactivity and widget rebuilds?';
    } else if (topic.contains('Kotlin') || topic.contains('Android')) {
      return 'Explain how StateFlow and SharedFlow differ in Kotlin Coroutines. Under what circumstances would you choose one over the other?';
    } else if (topic.contains('Architecture') || topic.contains('MVVM')) {
      return 'How do you design a resilient offline-first architecture with a Single Source of Truth (SSOT), and how should the domain layer remain free from UI/framework dependencies?';
    } else {
      return 'How would you design a thread-safe LRU (Least Recently Used) cache with O(1) read and write operations? What data structures are involved?';
    }
  }

  String _getFallbackEvaluation(String answer) {
    final wordCount = answer.trim().split(RegExp(r'\s+')).length;
    final score = wordCount > 40 ? 9 : (wordCount > 15 ? 7 : 5);
    return '''
• Score: $score/10

• Key Strengths:
Clear understanding of core concepts, good vocabulary, and logical explanation.

• Areas for Improvement:
Consider diving deeper into production edge cases, memory management, and reactive stream cancellation.

• Ideal Answer:
An enterprise-grade explanation links design decisions to testability, lifecycle awareness, and clean separation of concerns.
    '''.trim();
  }
}
