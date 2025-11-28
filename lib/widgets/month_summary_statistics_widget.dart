import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/month_summary.dart';

class MonthSummaryStatisticsWidget extends StatefulWidget {
  final MonthSummary monthSummary;
  const MonthSummaryStatisticsWidget({super.key, required this.monthSummary});

  @override
  State<MonthSummaryStatisticsWidget> createState() =>
      _MonthSummaryStatisticsWidgetState();
}

class _MonthSummaryStatisticsWidgetState
    extends State<MonthSummaryStatisticsWidget> {
  List<DateTime> dates = [];
  List<double> calories = [];
  List<double> units = [];
  bool _showCalories = true;

  @override
  void initState() {
    // TODO: implement initState
    int numDays = DateTime(
      widget.monthSummary.month.year,
      widget.monthSummary.month.month + 1,
      0,
    ).day;
    for (var i = 0; i < numDays; i++) {
      dates.add(
        DateTime(
          widget.monthSummary.month.year,
          widget.monthSummary.month.month,
          i + 1,
        ),
      );
      calories.add(0.0);
      units.add(0.0);
    }
    for (var cons in widget.monthSummary.consumptions) {
      int index = cons.consumptionDate.day - 1;
      units[index] += cons.units;
      calories[index] += cons.calories;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [_showCalories, !_showCalories],
            onPressed: (index) {
              setState(() {
                _showCalories = index == 0;
              });
            },
            borderRadius: BorderRadius.circular(8.0),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Calories'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Units'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: BarChart(
              BarChartData(
                barGroups: _createBarGroups(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        if (day % 5 == 0 || day == 1) {
                          return Text(day.toString());
                        }
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true, drawVerticalLine: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final day = dates[group.x.toInt() - 1];
                      final value = rod.toY;
                      final formattedDate = DateFormat.MMMMd().format(day);
                      final valueString = _showCalories
                          ? '${value.toStringAsFixed(0)} kcal'
                          : '${value.toStringAsFixed(1)} units';
                      return BarTooltipItem(
                        '$formattedDate\n$valueString',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    final data = _showCalories ? calories : units;
    final color = _showCalories ? Colors.orange : Colors.lightBlue;
    final hoverColor = _showCalories ? Colors.deepOrange : Colors.blue;

    return List.generate(dates.length, (index) {
      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: data[index],
            color: color,
            width: 5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
        showingTooltipIndicators: [],
      );
    });
  }
}
