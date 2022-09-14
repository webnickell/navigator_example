import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';

@freezed
class AppFlowConfiguration with _$AppFlowConfiguration {
  const AppFlowConfiguration._();

  const factory AppFlowConfiguration.root() = RootAppFlowConfiguration;

  const factory AppFlowConfiguration.quest({
    required String id,
    @Default(false) bool share,
  }) = QuestAppFlowConfiguration;

  const factory AppFlowConfiguration.createQuest({
    @Default(false) bool selectMedia,
    @Default(false) bool addParticipants,
  }) = CreateQuestAppFlowConfiguration;
}
