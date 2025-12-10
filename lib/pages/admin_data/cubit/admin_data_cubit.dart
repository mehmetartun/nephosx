import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/enums.dart';
import '../../../model/platform_settings.dart';
import '../../../repositories/database/database.dart';
import '../../../services/platform_settings/platform_settings_service.dart';

part 'admin_data_state.dart';

class AdminDataCubit extends Cubit<AdminDataState> {
  AdminDataCubit(this.databaseRepository) : super(AdminDataInitial());
  final DatabaseRepository databaseRepository;

  init() async {
    emit(
      AdminDataSettingsLoaded(
        platformSettings: PlatformSettingsService.instance.platformSettings,
      ),
    );
  }

  updateFavoriteCountries(Set<Country> countries) async {
    emit(AdminDataInitial());
    await PlatformSettingsService.instance.updateFavoriteCountries(countries);
    emit(
      AdminDataSettingsLoaded(
        platformSettings: PlatformSettingsService.instance.platformSettings,
      ),
    );
  }

  mainScreen() {
    emit(
      AdminDataSettingsLoaded(
        platformSettings: PlatformSettingsService.instance.platformSettings,
      ),
    );
  }

  updateAllowedCountries(Set<Country> countries) async {
    emit(AdminDataInitial());
    await PlatformSettingsService.instance.updateAllowedCountries(countries);
    emit(
      AdminDataSettingsLoaded(
        platformSettings: PlatformSettingsService.instance.platformSettings,
      ),
    );
  }

  allowedCountryUpdateRequest() {
    emit(
      AdminDataAllowedCountriesEdit(
        countries: PlatformSettingsService
            .instance
            .platformSettings
            .datacenterAllowedCountries,
      ),
    );
  }

  favoriteCountryUpdateRequest() {
    emit(
      AdminDataFavoriteCountriesEdit(
        countries:
            PlatformSettingsService.instance.platformSettings.favoriteCountries,
      ),
    );
  }
}
