class Conversions {
  /// Returns the initials from a display name.
  ///
  /// For example:
  /// - "John Doe" -> "JD"
  /// - "Jane" -> "J"
  /// - "  Peter  Jones  " -> "PJ"
  /// - "" -> ""
  /// - null -> ""
  static String getInitials(String? displayName) {
    if (displayName == null || displayName.trim().isEmpty) {
      return '';
    }

    // Split by whitespace and filter out empty parts
    final nameParts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();

    if (nameParts.isEmpty) {
      return '';
    } else if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      // Use the first letter of the first and last name parts
      return (nameParts.first[0] + nameParts.last[0]).toUpperCase();
    }
  }
}
