extension AddMonths on DateTime {
  /// Adds [months] to the current DateTime instance.
  ///
  /// This handles end-of-month overflow. If the resulting month has fewer days
  /// than the original day, the date is pinned to the last day of that month.
  ///
  /// Examples:
  /// - August 31 + 1 month -> September 30
  /// - January 31 + 1 month (non-leap year) -> February 28
  /// - January 31 + 1 month (leap year) -> February 29
  DateTime addMonths(int months) {
    // Calculate the target year and month.
    // Dart's DateTime constructor handles year overflow automatically
    // (e.g., month 13 becomes January of next year).
    var expectedMonth = this.month + months;

    // Create a tentative date.
    // We must preserve the timezone (UTC or Local).
    DateTime result;
    if (isUtc) {
      result = DateTime.utc(
        year,
        expectedMonth,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    } else {
      result = DateTime(
        year,
        expectedMonth,
        day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }

    // Calculate what the month *should* be normalized to (1-12).
    // Using simple modulo arithmetic adjusted for 1-based indexing.
    // (expectedMonth - 1) % 12 + 1 handles negative and positive overflows correctly.
    var normalizedExpectedMonth = (expectedMonth - 1) % 12 + 1;

    // If the day overflowed (e.g., Aug 31 -> Sept 31 -> Oct 1),
    // the month will be different from what we expected.
    if (result.month != normalizedExpectedMonth) {
      // Backtrack to the last day of the expected month.
      // Setting day to 0 of the *next* month gives the last day of *current* month.
      if (isUtc) {
        result = DateTime.utc(
          year,
          expectedMonth + 1, // Go to next month
          0, // Day 0 is the last day of previous month
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );
      } else {
        result = DateTime(
          year,
          expectedMonth + 1,
          0,
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        );
      }
    }

    return result;
  }
}

// --- TEST RUNNER ---
void main() {
  print('Running DateTime Extension Tests...\n');

  testCase(
    description: 'Standard Addition',
    start: DateTime(2023, 1, 15),
    monthsToAdd: 1,
    expected: DateTime(2023, 2, 15),
  );

  testCase(
    description: 'User Request: Aug 31 to Sept 30',
    start: DateTime(2023, 8, 31),
    monthsToAdd: 1,
    expected: DateTime(2023, 9, 30),
  );

  testCase(
    description: 'Leap Year: Jan 31 to Feb 29',
    start: DateTime(2024, 1, 31),
    monthsToAdd: 1,
    expected: DateTime(2024, 2, 29),
  );

  testCase(
    description: 'Non-Leap Year: Jan 31 to Feb 28',
    start: DateTime(2023, 1, 31),
    monthsToAdd: 1,
    expected: DateTime(2023, 2, 28),
  );

  testCase(
    description: 'Year Rollover: Dec 31 to Jan 31',
    start: DateTime(2023, 12, 31),
    monthsToAdd: 1,
    expected: DateTime(2024, 1, 31),
  );

  testCase(
    description: 'Subtraction: March 31 minus 1 month',
    start: DateTime(2023, 3, 31),
    monthsToAdd: -1,
    expected: DateTime(2023, 2, 28),
  );

  testCase(
    description: 'Preserves Time and UTC',
    start: DateTime.utc(2023, 8, 31, 14, 30),
    monthsToAdd: 1,
    expected: DateTime.utc(2023, 9, 30, 14, 30),
  );
}

void testCase({
  required String description,
  required DateTime start,
  required int monthsToAdd,
  required DateTime expected,
}) {
  final result = start.addMonths(monthsToAdd);
  final passed = result == expected && result.isUtc == expected.isUtc;

  print('$description:');
  print('  Start:    $start');
  print('  Add:      $monthsToAdd month(s)');
  print('  Result:   $result');
  print('  Expected: $expected');
  print('  Status:   ${passed ? "✅ PASS" : "❌ FAIL"}\n');
}
