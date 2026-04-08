part of 'app_versions_bloc.dart';

abstract class AppVersionsState extends Equatable {}

class AppVersionsInitial extends AppVersionsState {
  @override
  List<Object?> get props => [];
}

class AppVersionsLoading extends AppVersionsState {
  @override
  List<Object?> get props => [];
}

class AppVersionsLoaded extends AppVersionsState {
  final List<AppVersionRelease> releases;
  final AppVersionSettings settings;

  AppVersionsLoaded(this.releases, this.settings);

  @override
  List<Object?> get props => [releases, settings];
}

class AppVersionsError extends AppVersionsState {
  final String error;

  AppVersionsError(this.error);

  @override
  List<Object?> get props => [error];
}
