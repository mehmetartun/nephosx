import 'package:nephosx/model/consumption.dart';

enum SortOrder { ascending, descending }

class ConsumptionPeriod {
  final List<Consumption> consumptions;

  ConsumptionPeriod({required this.consumptions});

  List<Consumption> consumptionsForDate({
    required DateTime date,
    SortOrder sortOrder = SortOrder.ascending,
  }) {
    List<Consumption> _consumptions = [];
    _consumptions = consumptions.where((element) {
      return DateTime(date.year, date.month, date.day) ==
          DateTime(
            element.consumptionDate.year,
            element.consumptionDate.month,
            element.consumptionDate.day,
          );
    }).toList();
    if (sortOrder == SortOrder.descending) {
      _consumptions.sort(
        (a, b) => b.consumptionDate.compareTo(a.consumptionDate),
      );
    } else {
      _consumptions.sort(
        (a, b) => a.consumptionDate.compareTo(b.consumptionDate),
      );
    }
    return _consumptions;
  }

  List<Consumption> consumptionsAll({
    SortOrder sortOrder = SortOrder.ascending,
  }) {
    List<Consumption> _consumptions = consumptions.toList();
    if (sortOrder == SortOrder.descending) {
      _consumptions.sort(
        (a, b) => b.consumptionDate.compareTo(a.consumptionDate),
      );
    } else {
      _consumptions.sort(
        (a, b) => a.consumptionDate.compareTo(b.consumptionDate),
      );
    }
    return _consumptions;
  }

  List<Consumption> consumptionsForMonth({
    required DateTime month,
    SortOrder sortOrder = SortOrder.ascending,
  }) {
    List<Consumption> _consumptions = [];
    _consumptions = consumptions.where((element) {
      return DateTime(month.year, month.month, 1) ==
          DateTime(
            element.consumptionDate.year,
            element.consumptionDate.month,
            1,
          );
    }).toList();
    if (sortOrder == SortOrder.descending) {
      _consumptions.sort(
        (a, b) => b.consumptionDate.compareTo(a.consumptionDate),
      );
    } else {
      _consumptions.sort(
        (a, b) => a.consumptionDate.compareTo(b.consumptionDate),
      );
    }
    return _consumptions;
  }

  double get totalCalories {
    double total = 0;
    for (var i = 0; i < consumptions.length; i++) {
      total += consumptions[i].calories;
    }
    return total;
  }

  double get totalUnits {
    double total = 0;
    for (var i = 0; i < consumptions.length; i++) {
      total += consumptions[i].units;
    }
    return total;
  }

  double caloriesForDate(DateTime date) {
    double total = 0;
    consumptions
        .where((element) {
          return DateTime(
                element.consumptionDate.year,
                element.consumptionDate.month,
                element.consumptionDate.day,
              ) ==
              DateTime(date.year, date.month, date.day);
        })
        .toList()
        .forEach((element) {
          total += element.calories;
        });
    return total;
  }

  double unitsForDate(DateTime date) {
    double total = 0;
    consumptions
        .where((element) {
          return DateTime(
                element.consumptionDate.year,
                element.consumptionDate.month,
                element.consumptionDate.day,
              ) ==
              DateTime(date.year, date.month, date.day);
        })
        .toList()
        .forEach((element) {
          total += element.units;
        });
    return total;
  }

  double caloriesForMonth(DateTime date) {
    double total = 0;
    consumptions
        .where((element) {
          return DateTime(
                element.consumptionDate.year,
                element.consumptionDate.month,
                1,
              ) ==
              DateTime(date.year, date.month, 1);
        })
        .toList()
        .forEach((element) {
          total += element.calories;
        });
    return total;
  }

  double unitsForMonth(DateTime date) {
    double total = 0;
    consumptions
        .where((element) {
          return DateTime(
                element.consumptionDate.year,
                element.consumptionDate.month,
                1,
              ) ==
              DateTime(date.year, date.month, 1);
        })
        .toList()
        .forEach((element) {
          total += element.units;
        });
    return total;
  }

  List<DateTime> months() {
    Set<DateTime> months = {};
    List<DateTime> monthList = [];
    consumptions.forEach((cons) {
      months.add(
        DateTime(cons.consumptionDate.year, cons.consumptionDate.month, 1),
      );
    });
    monthList = months.toList();
    monthList.sort();
    return monthList;
  }

  List<DateTime> dates({
    DateTime? month,
    SortOrder sortOrder = SortOrder.ascending,
  }) {
    Set<DateTime> dates = {};
    List<DateTime> dateList = [];
    consumptions.forEach((cons) {
      if (month != null) {
        if (DateTime(
              cons.consumptionDate.year,
              cons.consumptionDate.month,
              1,
            ) ==
            DateTime(month.year, month.month, 1)) {
          dates.add(
            DateTime(
              cons.consumptionDate.year,
              cons.consumptionDate.month,
              cons.consumptionDate.day,
            ),
          );
        }
      } else {
        dates.add(
          DateTime(
            cons.consumptionDate.year,
            cons.consumptionDate.month,
            cons.consumptionDate.day,
          ),
        );
      }
    });
    dateList = dates.toList();
    if (sortOrder == SortOrder.descending) {
      dateList.sort((a, b) => b.compareTo(a));
    } else {
      dateList.sort((a, b) => a.compareTo(b));
    }
    return dateList;
  }
}
