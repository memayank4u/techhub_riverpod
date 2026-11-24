import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../domain/entities/interview_session_entity.dart';
import '../notifiers/interview_notifier.dart';
import '../notifiers/interview_state.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/theme_selector_sheet.dart';

class InterviewPage extends ConsumerWidget {
  const InterviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interviewNotifierProvider);
    final notifier = ref.read(interviewNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: state.step != InterviewStep.setup
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: notifier.backToSetup,
              )
            : null,
        title: const Text(
          AppStrings.interviewTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: AppStrings.themeSettingsTooltip,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const ThemeSelectorSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: AppStrings.interviewHistoryTitle,
            onPressed: () {
              if (state.step == InterviewStep.history) {
                notifier.backToSetup();
              } else {
                notifier.viewHistory();
              }
            },
          ),
        ],
      ),
      body: _buildCurrentStep(context, state, notifier),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    InterviewState state,
    InterviewNotifier notifier,
  ) {
    switch (state.step) {
      case InterviewStep.setup:
        return _buildSetupView(context, state, notifier);
      case InterviewStep.questionActive:
        return _buildQuestionView(context, state, notifier);
      case InterviewStep.evaluating:
      case InterviewStep.evaluationResult:
        return _buildEvaluationView(context, state, notifier);
      case InterviewStep.history:
        return _buildHistoryView(context, state);
    }
  }

  Widget _buildSetupView(
    BuildContext context,
    InterviewState state,
    InterviewNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final topics = [
      AppStrings.interviewTopicAndroid,
      AppStrings.interviewTopicKotlin,
      AppStrings.interviewTopicFlutter,
      AppStrings.interviewTopicArchitecture,
      AppStrings.interviewTopicDsa,
    ];

    final levels = [
      AppStrings.interviewLevelJunior,
      AppStrings.interviewLevelMid,
      AppStrings.interviewLevelSenior,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingLarge),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.heroAiTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppStrings.heroAiSubtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  radius: 24,
                  child: Icon(
                    Icons.psychology,
                    color: theme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          Text(
            AppStrings.interviewSelectTopic,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: topics.map((topic) {
              final isSelected = state.selectedTopic == topic;
              return ChoiceChip(
                label: Text(topic),
                selected: isSelected,
                onSelected: (_) => notifier.selectTopic(topic),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          Text(
            AppStrings.interviewSelectLevel,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingSmall),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: levels.map((level) {
              final isSelected = state.selectedLevel == level;
              return ChoiceChip(
                label: Text(level),
                selected: isSelected,
                onSelected: (_) => notifier.selectLevel(level),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spacingXLarge),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: state.isGeneratingQuestion ? null : notifier.requestQuestion,
              icon: state.isGeneratingQuestion
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: const Text(
                AppStrings.interviewStartButton,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionView(
    BuildContext context,
    InterviewState state,
    InterviewNotifier notifier,
  ) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppStrings.interviewQuestionLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingMedium),
                  Text(
                    state.currentQuestion,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          TextField(
            maxLines: 8,
            onChanged: notifier.updateAnswer,
            decoration: InputDecoration(
              hintText: AppStrings.interviewAnswerHint,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingMedium),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: state.userAnswer.trim().isEmpty ? null : notifier.submitAnswer,
              child: const Text(
                AppStrings.interviewSubmitAnswer,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvaluationView(
    BuildContext context,
    InterviewState state,
    InterviewNotifier notifier,
  ) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      child: Column(
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.interviewFeedbackTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (state.isEvaluatingAnswer)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingMedium),
                  Text(
                    state.streamingEvaluation.isEmpty
                        ? AppStrings.interviewEvaluating
                        : state.streamingEvaluation,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLarge),
          if (!state.isEvaluatingAnswer)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: notifier.reset,
                child: const Text(
                  AppStrings.interviewNewQuestion,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryView(BuildContext context, InterviewState state) {
    if (state.historySessions.isEmpty) {
      return const EmptyStateView(
        icon: Icons.history,
        title: AppStrings.interviewHistoryEmpty,
        subtitle: AppStrings.articlesEmptyBookmarksSub,
        actionText: null,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.spacingMedium),
      itemCount: state.historySessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = state.historySessions[index];
        return _buildHistoryCard(context, session);
      },
    );
  }

  Widget _buildHistoryCard(BuildContext context, InterviewSessionEntity session) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${session.topic} • ${session.level}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.marketGreenContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Score: ${session.score}/10',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.marketGreen,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingMedium),
            Text(
              session.question,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingSmall),
            Text(
              session.evaluationFeedback,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
