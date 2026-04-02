part of 'app_versions_bloc.dart';

abstract class AppVersionsEvent extends Equatable {}

class InitializedAppVersionsEvent extends AppVersionsEvent {
  @override
  List<Object?> get props => [];
}

class SavedAppVersionEvent extends AppVersionsEvent {
  final AppVersionRelease release;

  SavedAppVersionEvent(this.release);

  @override
  List<Object?> get props => [release];
}

class SavedAppVersionSettingsEvent extends AppVersionsEvent {
  final AppVersionSettings settings;

  SavedAppVersionSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}
