import '../../model/enums.dart';
import '../../model/platform_settings.dart';
import '../../repositories/database/database.dart';

class PlatformSettingsService {
  static final PlatformSettingsService _instance = PlatformSettingsService._();
  PlatformSettingsService._();

  static PlatformSettingsService get instance => _instance;
  late final DatabaseRepository databaseRepository;

  PlatformSettings _platformSettings = PlatformSettings.defaultSettings;

  PlatformSettings get platformSettings => _platformSettings;

  init(DatabaseRepository databaseRepository) {
    this.databaseRepository = databaseRepository;
    _platformSettings = PlatformSettings.defaultSettings;
    databaseRepository.getPlatformSettings().then((value) {
      _platformSettings = value;
    });
  }

  updateAllowedCountries(Set<Country> countries) async {
    _platformSettings = _platformSettings.copyWith(
      datacenterAllowedCountries: countries,
    );
    await databaseRepository.updateDocument(
      docPath: "settings/settings",
      data: _platformSettings.toJson(),
    );
  }

  updateFavoriteCountries(Set<Country> countries) async {
    _platformSettings = _platformSettings.copyWith(
      favoriteCountries: countries,
    );
    await databaseRepository.updateDocument(
      docPath: "settings/settings",
      data: _platformSettings.toJson(),
    );
  }
}
