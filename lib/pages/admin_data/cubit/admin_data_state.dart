part of 'admin_data_cubit.dart';

@immutable
sealed class AdminDataState {}

final class AdminDataInitial extends AdminDataState {}

final class AdminDataSettingsLoaded extends AdminDataState {
  final PlatformSettings platformSettings;

  AdminDataSettingsLoaded({required this.platformSettings});
}

final class AdminDataAllowedCountriesEdit extends AdminDataState {
  final Set<Country> countries;

  AdminDataAllowedCountriesEdit({required this.countries});
}

final class AdminDataFavoriteCountriesEdit extends AdminDataState {
  final Set<Country> countries;

  AdminDataFavoriteCountriesEdit({required this.countries});
}
