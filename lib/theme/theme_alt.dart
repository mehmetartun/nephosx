import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff465d91),
      surfaceTint: Color(0xff465d91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd9e2ff),
      onPrimaryContainer: Color(0xff2d4578),
      secondary: Color(0xff575e71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdbe2f9),
      onSecondaryContainer: Color(0xff404759),
      tertiary: Color(0xff096b5a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffa1f2dd),
      onTertiaryContainer: Color(0xff005143),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff1a1b20),
      onSurfaceVariant: Color(0xff44464f),
      outline: Color(0xff757780),
      outlineVariant: Color(0xffc5c6d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffafc6ff),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff001944),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff2d4578),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff141b2c),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff404759),
      tertiaryFixed: Color(0xffa1f2dd),
      onTertiaryFixed: Color(0xff00201a),
      tertiaryFixedDim: Color(0xff85d6c1),
      onTertiaryFixedVariant: Color(0xff005143),
      surfaceDim: Color(0xffdad9e0),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffeeedf4),
      surfaceContainerHigh: Color(0xffe8e7ef),
      surfaceContainerHighest: Color(0xffe2e2e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1b3566),
      surfaceTint: Color(0xff465d91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff556ca1),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2f3648),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff666d80),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff003e33),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff247a69),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff0f1116),
      onSurfaceVariant: Color(0xff34363e),
      outline: Color(0xff50525a),
      outlineVariant: Color(0xff6b6d75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffafc6ff),
      primaryFixed: Color(0xff556ca1),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff3c5487),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff666d80),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4e5467),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff247a69),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006051),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c6cd),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffe8e7ef),
      surfaceContainerHigh: Color(0xffdddce3),
      surfaceContainerHighest: Color(0xffd1d1d8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0e2a5b),
      surfaceTint: Color(0xff465d91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff30487b),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff252c3d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff42495b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00332a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff005346),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292c33),
      outlineVariant: Color(0xff474951),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3036),
      inversePrimary: Color(0xffafc6ff),
      primaryFixed: Color(0xff30487b),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff163162),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff42495b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2b3244),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff005346),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003a30),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb8b8bf),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f0f7),
      surfaceContainer: Color(0xffe2e2e9),
      surfaceContainerHigh: Color(0xffd4d4db),
      surfaceContainerHighest: Color(0xffc6c6cd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffafc6ff),
      surfaceTint: Color(0xffafc6ff),
      onPrimary: Color(0xff142f60),
      primaryContainer: Color(0xff2d4578),
      onPrimaryContainer: Color(0xffd9e2ff),
      secondary: Color(0xffbfc6dc),
      onSecondary: Color(0xff293042),
      secondaryContainer: Color(0xff404759),
      onSecondaryContainer: Color(0xffdbe2f9),
      tertiary: Color(0xff85d6c1),
      onTertiary: Color(0xff00382e),
      tertiaryContainer: Color(0xff005143),
      onTertiaryContainer: Color(0xffa1f2dd),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff121318),
      onSurface: Color(0xffe2e2e9),
      onSurfaceVariant: Color(0xffc5c6d0),
      outline: Color(0xff8f9099),
      outlineVariant: Color(0xff44464f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff465d91),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff001944),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff2d4578),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff141b2c),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff404759),
      tertiaryFixed: Color(0xffa1f2dd),
      onTertiaryFixed: Color(0xff00201a),
      tertiaryFixedDim: Color(0xff85d6c1),
      onTertiaryFixedVariant: Color(0xff005143),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff38393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff1a1b20),
      surfaceContainer: Color(0xff1e1f25),
      surfaceContainerHigh: Color(0xff282a2f),
      surfaceContainerHighest: Color(0xff33353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd0dcff),
      surfaceTint: Color(0xffafc6ff),
      onPrimary: Color(0xff042355),
      primaryContainer: Color(0xff7990c7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd5dcf3),
      onSecondary: Color(0xff1e2536),
      secondaryContainer: Color(0xff8990a5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff9becd6),
      onTertiary: Color(0xff002c24),
      tertiaryContainer: Color(0xff4e9f8c),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdbdce6),
      outline: Color(0xffb0b1bb),
      outlineVariant: Color(0xff8e9099),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff2f4779),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff00102f),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff1b3566),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff091121),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff2f3648),
      tertiaryFixed: Color(0xffa1f2dd),
      onTertiaryFixed: Color(0xff001510),
      tertiaryFixedDim: Color(0xff85d6c1),
      onTertiaryFixedVariant: Color(0xff003e33),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff43444a),
      surfaceContainerLowest: Color(0xff06070c),
      surfaceContainerLow: Color(0xff1c1d23),
      surfaceContainer: Color(0xff26282d),
      surfaceContainerHigh: Color(0xff313238),
      surfaceContainerHighest: Color(0xff3c3d43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffecefff),
      surfaceTint: Color(0xffafc6ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffaac2fd),
      onPrimaryContainer: Color(0xff000a24),
      secondary: Color(0xffecefff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbbc2d8),
      onSecondaryContainer: Color(0xff040b1b),
      tertiary: Color(0xffb3ffea),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff81d2bd),
      onTertiaryContainer: Color(0xff000e0a),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff121318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffefeff9),
      outlineVariant: Color(0xffc1c2cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff2f4779),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffafc6ff),
      onPrimaryFixedVariant: Color(0xff00102f),
      secondaryFixed: Color(0xffdbe2f9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbfc6dc),
      onSecondaryFixedVariant: Color(0xff091121),
      tertiaryFixed: Color(0xffa1f2dd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff85d6c1),
      onTertiaryFixedVariant: Color(0xff001510),
      surfaceDim: Color(0xff121318),
      surfaceBright: Color(0xff4f5056),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1e1f25),
      surfaceContainer: Color(0xff2f3036),
      surfaceContainerHigh: Color(0xff3a3b41),
      surfaceContainerHighest: Color(0xff45464c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );

  /// Warning
  static const warning = ExtendedColor(
    seed: Color(0xffffb13c),
    value: Color(0xffffb13c),
    light: ColorFamily(
      color: Color(0xff815511),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb5),
      onColorContainer: Color(0xff643f00),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff815511),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb5),
      onColorContainer: Color(0xff643f00),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff815511),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffffddb5),
      onColorContainer: Color(0xff643f00),
    ),
    dark: ColorFamily(
      color: Color(0xfff6bc70),
      onColor: Color(0xff462b00),
      colorContainer: Color(0xff643f00),
      onColorContainer: Color(0xffffddb5),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xfff6bc70),
      onColor: Color(0xff462b00),
      colorContainer: Color(0xff643f00),
      onColorContainer: Color(0xffffddb5),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xfff6bc70),
      onColor: Color(0xff462b00),
      colorContainer: Color(0xff643f00),
      onColorContainer: Color(0xffffddb5),
    ),
  );

  /// Success
  static const success = ExtendedColor(
    seed: Color(0xff50a752),
    value: Color(0xff50a752),
    light: ColorFamily(
      color: Color(0xff3b693a),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffbcf0b4),
      onColorContainer: Color(0xff235024),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff3b693a),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffbcf0b4),
      onColorContainer: Color(0xff235024),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff3b693a),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffbcf0b4),
      onColorContainer: Color(0xff235024),
    ),
    dark: ColorFamily(
      color: Color(0xffa1d39a),
      onColor: Color(0xff09390f),
      colorContainer: Color(0xff235024),
      onColorContainer: Color(0xffbcf0b4),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xffa1d39a),
      onColor: Color(0xff09390f),
      colorContainer: Color(0xff235024),
      onColorContainer: Color(0xffbcf0b4),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xffa1d39a),
      onColor: Color(0xff09390f),
      colorContainer: Color(0xff235024),
      onColorContainer: Color(0xffbcf0b4),
    ),
  );


  List<ExtendedColor> get extendedColors => [
    warning,
    success,
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
