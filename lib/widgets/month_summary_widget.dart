import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/month_summary.dart';

class MonthSummaryWidget extends StatelessWidget {
  const MonthSummaryWidget({
    super.key,
    required this.monthSummary,
    this.selected = false,
  });
  final MonthSummary monthSummary;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMM').format(monthSummary.month).toUpperCase(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: NumberFormat('0').format(monthSummary.totalCalories),

                  style: Theme.of(context).textTheme.headlineSmall,
                  children: [
                    TextSpan(
                      text: ' kCal',

                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: NumberFormat('0.0').format(monthSummary.totalUnits),

                  style: Theme.of(context).textTheme.headlineSmall,
                  children: [
                    TextSpan(
                      text: ' units',

                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              // Text(NumberFormat('0 kCal').format(calories)),
              // Text(NumberFormat('0.0 units').format(units)),
            ],
          ),
        ],
      ),
    );
  }
}
