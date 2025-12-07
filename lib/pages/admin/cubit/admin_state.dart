part of 'admin_cubit.dart';

@immutable
sealed class AdminState {}

final class AdminInitial extends AdminState {}

final class AdminSettingsLoaded extends AdminState {
  final PlatformSettings platformSettings;

  AdminSettingsLoaded({required this.platformSettings});
}
