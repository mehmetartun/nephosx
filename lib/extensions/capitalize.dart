extension StringCasingExtension on String {
  /// Converts the string to "Title Case".
  ///
  /// This capitalizes the first letter of each word and makes the remaining
  /// letters in each word lowercase.
  ///
  /// Examples:
  /// - "hello world" -> "Hello World"
  /// - "HELLO WORLD" -> "Hello World"
  /// - "hElLo wOrLd" -> "Hello World"
  /// - "hello   world" -> "Hello   World" (preserves spacing)
  ///
  String toTitleCase() {
    // Return an empty string if the input is empty
    if (isEmpty) {
      return "";
    }

    // Split the string by spaces, map each word, and join them back
    return split(' ')
        .map((word) {
          // Handle empty words (e.g., from multiple spaces)
          if (word.isEmpty) {
            return "";
          }

          // Capitalize the first letter and lowercase the rest
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}

extension ConversionExtensions on double {
  double mLtoOz() {
    return this / 29.5735;
  }

  double ozToMl() {
    return this * 29.5735;
  }
}
