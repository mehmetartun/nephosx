import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../model/enums.dart';
import '../../../model/platform_settings.dart';
import '../../../repositories/database/database.dart';
import '../../../services/platform_settings/platform_settings_service.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit(this.databaseRepository) : super(AdminInitial());
  final DatabaseRepository databaseRepository;

  init() async {
    emit(
      AdminSettingsLoaded(
        platformSettings: PlatformSettingsService.instance.platformSettings,
      ),
    );
  }

  updateAllowedCountries(Set<Country> countries) async {
    emit(AdminInitial());
    await PlatformSettingsService.instance.updateAllowedCountries(countries);
    emit(
      AdminSettingsLoaded(
        platformSettings: PlatformSettingsService.instance.platformSettings,
      ),
    );
  }
}
