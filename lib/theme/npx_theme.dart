import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0055ac),
      surfaceTint: Color(0xff115db6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2e6ec8),
      onPrimaryContainer: Color(0xfff1f3ff),
      secondary: Color(0xff43617c),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffbeddfd),
      onSecondaryContainer: Color(0xff44627d),
      tertiary: Color(0xff49607b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc7dfff),
      onTertiaryContainer: Color(0xff4c637e),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      onSurfaceVariant: Color(0xff424752),
      outline: Color(0xff727783),
      outlineVariant: Color(0xffc2c6d4),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xffabc7ff),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff001b3f),
      primaryFixedDim: Color(0xffabc7ff),
      onPrimaryFixedVariant: Color(0xff00458e),
      secondaryFixed: Color(0xffcde5ff),
      onSecondaryFixed: Color(0xff001d32),
      secondaryFixedDim: Color(0xffabcae9),
      onSecondaryFixedVariant: Color(0xff2b4964),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff011d35),
      tertiaryFixedDim: Color(0xffb1c9e8),
      onTertiaryFixedVariant: Color(0xff314862),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003570),
      surfaceTint: Color(0xff115db6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2b6cc6),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff183952),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff52708c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff203851),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff586f8b),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff313641),
      outline: Color(0xff4e525e),
      outlineVariant: Color(0xff686d79),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xffabc7ff),
      primaryFixed: Color(0xff2b6cc6),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0053a8),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff52708c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff395872),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff586f8b),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff405771),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c6c6),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffe8e8e8),
      surfaceContainerHigh: Color(0xffdddddd),
      surfaceContainerHighest: Color(0xffd1d1d1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002b5d),
      surfaceTint: Color(0xff115db6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004793),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff0b2e47),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff2d4c66),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff152e46),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff344b65),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff272c37),
      outlineVariant: Color(0xff444954),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xffabc7ff),
      primaryFixed: Color(0xff004793),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003169),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff2d4c66),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff14354e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff344b65),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff1c344d),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b9b9),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f1f1),
      surfaceContainer: Color(0xffe2e2e2),
      surfaceContainerHigh: Color(0xffd4d4d4),
      surfaceContainerHighest: Color(0xffc6c6c6),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffabc7ff),
      surfaceTint: Color(0xffabc7ff),
      onPrimary: Color(0xff002f65),
      primaryContainer: Color(0xff2e6ec8),
      onPrimaryContainer: Color(0xfff1f3ff),
      secondary: Color(0xfff1f6ff),
      onSecondary: Color(0xff11334c),
      secondaryContainer: Color(0xffbeddfd),
      onSecondaryContainer: Color(0xff44627d),
      tertiary: Color(0xfff8f9ff),
      onTertiary: Color(0xff1a324b),
      tertiaryContainer: Color(0xffc7dfff),
      onTertiaryContainer: Color(0xff4c637e),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131313),
      onSurface: Color(0xffe2e2e2),
      onSurfaceVariant: Color(0xffc2c6d4),
      outline: Color(0xff8c919d),
      outlineVariant: Color(0xff424752),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff115db6),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff001b3f),
      primaryFixedDim: Color(0xffabc7ff),
      onPrimaryFixedVariant: Color(0xff00458e),
      secondaryFixed: Color(0xffcde5ff),
      onSecondaryFixed: Color(0xff001d32),
      secondaryFixedDim: Color(0xffabcae9),
      onSecondaryFixedVariant: Color(0xff2b4964),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff011d35),
      tertiaryFixedDim: Color(0xffb1c9e8),
      onTertiaryFixedVariant: Color(0xff314862),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdddff),
      surfaceTint: Color(0xffabc7ff),
      onPrimary: Color(0xff002551),
      primaryContainer: Color(0xff5790ed),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfff1f6ff),
      onSecondary: Color(0xff11334c),
      secondaryContainer: Color(0xffbeddfd),
      onSecondaryContainer: Color(0xff26455f),
      tertiary: Color(0xfff8f9ff),
      onTertiary: Color(0xff1a324b),
      tertiaryContainer: Color(0xffc7dfff),
      onTertiaryContainer: Color(0xff2f4660),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd8dcea),
      outline: Color(0xffadb2bf),
      outlineVariant: Color(0xff8c909d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff004691),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff00112b),
      primaryFixedDim: Color(0xffabc7ff),
      onPrimaryFixedVariant: Color(0xff003570),
      secondaryFixed: Color(0xffcde5ff),
      onSecondaryFixed: Color(0xff001222),
      secondaryFixedDim: Color(0xffabcae9),
      onSecondaryFixedVariant: Color(0xff183952),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff001225),
      tertiaryFixedDim: Color(0xffb1c9e8),
      onTertiaryFixedVariant: Color(0xff203851),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff444444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1d1d1d),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff323232),
      surfaceContainerHighest: Color(0xff3e3e3e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffabc7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa4c3ff),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xfff1f6ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbeddfd),
      onSecondaryContainer: Color(0xff00263e),
      tertiary: Color(0xfff8f9ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc7dfff),
      onTertiaryContainer: Color(0xff0e2740),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffecf0fe),
      outlineVariant: Color(0xffbec2d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff004691),
      primaryFixed: Color(0xffd7e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffabc7ff),
      onPrimaryFixedVariant: Color(0xff00112b),
      secondaryFixed: Color(0xffcde5ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffabcae9),
      onSecondaryFixedVariant: Color(0xff001222),
      tertiaryFixed: Color(0xffd1e4ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb1c9e8),
      onTertiaryFixedVariant: Color(0xff001225),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff505050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f1f),
      surfaceContainer: Color(0xff303030),
      surfaceContainerHigh: Color(0xff3b3b3b),
      surfaceContainerHighest: Color(0xff474747),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) =>
      ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      ).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          border: OutlineInputBorder(
            // borderSide: BorderSide(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  List<ExtendedColor> get extendedColors => [];
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
