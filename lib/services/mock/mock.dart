import 'package:nephosx/model/enums.dart';

import '../../model/consideration.dart';
import 'dart:math' as math;

class Mock {
  static const spRatings = [
    'AAA',
    'AA+',
    'AA',
    'AA-',
    'A+',
    'A',
    'A-',
    'BBB+',
    'BBB',
    'BBB-',
    'B+',
    'BB',
    'BB-',
    'B+',
    'B',
    'B-',
  ];
  static const moodysRatings = [
    'AAA',
    'Aa1',
    'Aa2',
    'Aa3',
    'A1',
    'A2',
    'A3',
    'Baa1',
    'Baa2',
    'Baa3',
    'Ba1',
    'Ba2',
    'Ba3',
    'B1',
    'B2',
    'B3',
  ];
  static const fitchRatings = [
    'AAA',
    'AA+',
    'AA',
    'AA-',
    'A+',
    'A',
    'A-',
    'BBB+',
    'BBB',
    'BBB-',
    'B+',
    'BB',
    'BB-',
    'B+',
    'B',
    'B-',
  ];
  static const creditRatings = [
    'AAA',
    'AA+',
    'AA',
    'AA-',
    'A+',
    'A',
    'A-',
    'BBB+',
    'BBB',
    'BBB-',
    'B+',
    'BB',
    'BB-',
    'B+',
    'B',
    'B-',
  ];

  static Consideration consideration(
    double min,
    double max, [
    Currency ccy = Currency.usd,
  ]) {
    return Consideration(
      amount: min + math.Random().nextDouble() * (max - min),
      currency: ccy,
    );
  }

  static String get portfolioName {
    return 'Portfolio ${math.Random().nextInt(1000000)}';
  }

  static String get spRating {
    return spRatings[math.Random().nextInt(spRatings.length)];
  }

  static String get moodysRating {
    return moodysRatings[math.Random().nextInt(moodysRatings.length)];
  }

  static String get fitchRating {
    return fitchRatings[math.Random().nextInt(fitchRatings.length)];
  }

  static String get creditRating {
    return creditRatings[math.Random().nextInt(creditRatings.length)];
  }
}
