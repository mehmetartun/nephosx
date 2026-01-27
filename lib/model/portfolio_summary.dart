import 'consideration.dart';
import 'enums.dart';

class PortfolioSummary {
  final String portfolioName;
  final String portfolioDescription;
  final Consideration totalReceivable;
  final Consideration offerPrice;
  final String averageSPRating;
  final String averageMoodysRating;
  final String averageFitchRating;
  final String averageCreditRating;
  final int totalTransactions;

  PortfolioSummary({
    required this.portfolioName,
    required this.portfolioDescription,
    required this.totalReceivable,
    required this.offerPrice,
    required this.averageSPRating,
    required this.averageMoodysRating,
    required this.averageFitchRating,
    required this.averageCreditRating,
    required this.totalTransactions,
  });

  static PortfolioSummary get mock {
    return PortfolioSummary(
      portfolioName: 'Portfolio 1',
      portfolioDescription: 'Portfolio 1 description',
      totalReceivable: Consideration(amount: 2000000.0, currency: Currency.usd),
      offerPrice: Consideration(amount: 1800000.0, currency: Currency.usd),
      averageSPRating: 'A+',
      averageMoodysRating: 'A',
      averageFitchRating: 'A+',
      averageCreditRating: 'A+',
      totalTransactions: 10,
    );
  }
}
