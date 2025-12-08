import 'package:nephosx/model/consumption_period.dart';
import 'package:nephosx/navigation/my_navigator_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../model/consumption.dart';
import '../../../model/drinking_note.dart';
import '../../../model/month_summary.dart';
import '../../../widgets/animated_month_list_view.dart';
import '../../../widgets/day_block.dart';

class StatisticsFullView extends StatelessWidget {
  final ConsumptionPeriod consumptionPeriod;

  final void Function(DateTime) onTapMonth;
  final void Function(DateTime) onTapDate;
  final DrinkingNote? Function(DateTime) getDrinkingNote;

  const StatisticsFullView({
    super.key,
    required this.consumptionPeriod,
    required this.onTapMonth,
    required this.onTapDate,
    required this.getDrinkingNote,
  });

  @override
  Widget build(BuildContext context) {
    List<Consumption> consumptions = consumptionPeriod.consumptions;
    consumptions.sort((a, b) => b.consumptionDate.compareTo(a.consumptionDate));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            // leading: selectedMonth == null
            //     ? null
            //     : IconButton.filledTonal(
            //         icon: const Icon(Icons.arrow_back),
            //         onPressed: () {
            //           onTapMonth(null);
            //         },
            //       ),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Statistics",
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: AnimatedMonthListView(
                onTap: onTapMonth,
                items: consumptionPeriod.months().map((month) {
                  return MonthSummary(
                    month: month,
                    totalCalories: consumptionPeriod.caloriesForMonth(month),
                    totalUnits: consumptionPeriod.unitsForMonth(month),
                    consumptions: consumptionPeriod.consumptionsForMonth(
                      month: month,
                      sortOrder: SortOrder.descending,
                    ),
                  );
                }).toList(),

                height: 100,
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return DayBlock(
                  consumptions: consumptionPeriod.consumptionsForDate(
                    date: consumptionPeriod.dates(
                      sortOrder: SortOrder.descending,
                    )[index],
                  ),
                  date: consumptionPeriod.dates(
                    sortOrder: SortOrder.descending,
                  )[index],
                  onTap: onTapDate,
                  drinkingNote: getDrinkingNote(
                    consumptionPeriod.dates(
                      sortOrder: SortOrder.descending,
                    )[index],
                  ),
                );
              },
              childCount: consumptionPeriod
                  .dates(sortOrder: SortOrder.descending)
                  .length,
            ),
          ),
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
