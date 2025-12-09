import 'package:json_annotation/json_annotation.dart';
import 'package:nephosx/model/device.dart';
import 'package:nephosx/model/enums.dart';

import 'cpu.dart';
import 'producer.dart';

part 'platform_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class PlatformSettings {
  @JsonKey(name: "datacenter_allowed_countries")
  final Set<Country> datacenterAllowedCountries;
  @JsonKey(name: "favorite_countries")
  final Set<Country> favoriteCountries;
  final List<Producer> producers;
  final List<Device> devices;
  final List<Cpu> cpus;

  PlatformSettings({
    required this.datacenterAllowedCountries,
    required this.favoriteCountries,
    required this.producers,
    required this.devices,
    required this.cpus,
  });

  static PlatformSettings get defaultSettings => PlatformSettings(
    datacenterAllowedCountries: {
      Country.us,
      Country.gb,
      Country.de,
      Country.se,
      Country.ch,
      Country.ca,
      Country.fr,
      Country.au,
    },
    favoriteCountries: {
      Country.us,
      Country.gb,
      Country.de,
      Country.se,
      Country.ch,
      Country.af,
    },
    producers: [],
    devices: [],
    cpus: [],
  );

  List<Country> get datacenterFavoriteCountriesList {
    List<Country> shortFavs = favoriteCountries.toList();
    shortFavs.removeWhere(
      (element) => !datacenterAllowedCountries.contains(element),
    );
    return shortFavs;
  }

  List<Country> get datacenterRemainingCountriesList {
    Set<Country> allowed = datacenterAllowedCountries.toSet();
    allowed.removeWhere(
      (element) => datacenterFavoriteCountriesList.contains(element),
    );
    List<Country> allowedList = allowed.toList();
    allowedList.sort((a, b) => a.description.compareTo(b.description));
    return allowedList;
  }

  PlatformSettings copyWith({
    Set<Country>? datacenterAllowedCountries,
    Set<Country>? favoriteCountries,
    List<Producer>? producers,
    List<Device>? devices,
    List<Cpu>? cpus,
  }) {
    return PlatformSettings(
      datacenterAllowedCountries:
          datacenterAllowedCountries ?? this.datacenterAllowedCountries,
      favoriteCountries: favoriteCountries ?? this.favoriteCountries,
      producers: producers ?? this.producers,
      devices: devices ?? this.devices,
      cpus: cpus ?? this.cpus,
    );
  }

  factory PlatformSettings.fromJson(Map<String, dynamic> json) =>
      _$PlatformSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PlatformSettingsToJson(this);
}
