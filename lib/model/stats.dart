import 'consumption.dart';
import 'drink.dart';
import 'drinking_note.dart';

class Stats {
  final List<Consumption> consumptions;
  final List<DrinkingNote> notes;
  final List<Drink> drinks;

  Stats({
    required this.consumptions,
    required this.notes,
    required this.drinks,
  });
}
