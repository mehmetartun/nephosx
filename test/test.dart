import 'package:nephosx/model/enums.dart';
import 'package:nephosx/model/platform_settings.dart';
import 'package:test/test.dart';

void main() {
  test('Favorite Countries', () {
    PlatformSettings settings = PlatformSettings(
      datacenterAllowedCountries: {Country.us, Country.se, Country.gb},
      favoriteCountries: {Country.af, Country.se, Country.gb},
    );
    expect(settings.datacenterFavoriteCountriesList, [Country.se, Country.gb]);
    expect(settings.datacenterRemainingCountriesList, [Country.us]);
  });
}
