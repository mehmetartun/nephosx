import 'package:nephosx/model/consumption_period.dart';
import 'package:nephosx/navigation/my_navigator_route.dart';
import 'package:nephosx/widgets/month_summary_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../model/drinking_note.dart';
import '../../../model/month_summary.dart';
import '../../../widgets/animated_month_list_view.dart';
import '../../../widgets/day_block.dart';

class StatisticsMonthView extends StatelessWidget {
  final ConsumptionPeriod consumptionPeriod;
  final DateTime selectedMonth;
  final void Function() onCancel;
  final void Function(DateTime) onTapDate;
  final DrinkingNote? Function(DateTime) getDrinkingNote;

  const StatisticsMonthView({
    super.key,
    required this.onCancel,
    required this.selectedMonth,
    required this.onTapDate,
    required this.consumptionPeriod,
    required this.getDrinkingNote,
  });

  @override
  Widget build(BuildContext context) {
    // print(data);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton.filledTonal(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                onCancel();
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                DateFormat("MMMM yyyy").format(selectedMonth!),
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black54,
                    ],
                    stops: [0.0, 0.2, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Image.asset(
                  "assets/images/CocktailImage.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  context.pushNamed(MyNavigatorRoute.splash.name);
                },
              ),
            ],
          ),
          SliverPersistentHeader(
            pinned: true, // Keep this true to stick at the top
            delegate: MyStickyHeaderDelegate(
              child: MonthSummaryStatisticsWidget(
                monthSummary: MonthSummary(
                  month: selectedMonth,
                  totalCalories: consumptionPeriod.totalCalories,
                  totalUnits: consumptionPeriod.totalUnits,
                  consumptions: consumptionPeriod.consumptions,
                ),
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return DayBlock(
                consumptions: consumptionPeriod.consumptionsForDate(
                  date: consumptionPeriod.dates()[index],
                  sortOrder: SortOrder.descending,
                ),
                date: consumptionPeriod.dates()[index],
                onTap: onTapDate,
                drinkingNote: getDrinkingNote(consumptionPeriod.dates()[index]),
              );
            }, childCount: consumptionPeriod.dates().length),
          ),

          // SliverList(
          //   delegate: SliverChildBuilderDelegate((context, index) {
          //     Drink drink = consumptions[index].drink!;
          //     DrinkSize size = consumptions[index].drinkSize;
          //     return ListTile(
          //       leading: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Image.memory(base64Decode(drink.imageBase64)),
          //       ),
          //       title: Text(drink.name),
          //       subtitle: Text(size.description),
          //       trailing: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text(
          //             NumberFormat(
          //               '0 kCal',
          //             ).format(consumptions[index].calories),
          //           ),
          //           Text(
          //             NumberFormat(
          //               '0.0 units',
          //             ).format(consumptions[index].units),
          //           ),
          //         ],
          //       ),
          //     );
          //   }, childCount: consumptions.length),
          // ),
        ],
      ),
    );
  }
}

class MyStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  MyStickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 240.0; // Height when fully expanded

  @override
  double get minExtent => 240.0; // Height when fully collapsed (stuck)

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false; // Return true if you pass new data to the delegate
  }
}
