import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/consumption.dart';
import '../../../model/consumption_period.dart';
import '../../../model/drinking_note.dart';
import '../../../model/enums.dart';
import '../../../widgets/editable_day_block.dart';
import '../cubit/statistics_cubit.dart';

class StatisticsDayView extends StatefulWidget {
  const StatisticsDayView({
    super.key,
    required this.date,
    required this.onDelete,
    required this.onSizeChange,
    required this.onCancel,
    required this.consumptionPeriod,
    required this.onSavedNote,
    required this.onUpdatedNote,
    this.drinkingNote,
  });
  final ConsumptionPeriod consumptionPeriod;
  final DateTime date;
  final void Function(Consumption) onDelete;
  final void Function({required Consumption cons, required DrinkSize size})
  onSizeChange;
  final void Function(DateTime) onCancel;
  final void Function(DrinkingNote) onSavedNote;
  final void Function(DrinkingNote) onUpdatedNote;
  final DrinkingNote? drinkingNote;

  @override
  State<StatisticsDayView> createState() => _StatisticsDayViewState();
}

class _StatisticsDayViewState extends State<StatisticsDayView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: IconButton.filledTonal(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                BlocProvider.of<StatisticsCubit>(
                  context,
                ).selectMonth(DateTime(widget.date.year, widget.date.month, 1));
              },
            ),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("EEEE").format(widget.date),
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  Text(
                    DateFormat("d MMMM").format(widget.date).toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ],
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
                  // context.pushNamed(MyNavigatorRoute.splash.name);
                },
              ),
            ],
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return EditableDayBlock(
                consumptions: widget.consumptionPeriod.consumptions,
                date: widget.date,
                onTap: (date) {},
                onDelete: widget.onDelete,
                onSizeChange: widget.onSizeChange,
                onSavedNote: widget.onSavedNote,
                onUpdatedNote: widget.onUpdatedNote,
                drinkingNote: widget.drinkingNote,
              );
            }, childCount: 1),
          ),
        ],
      ),
    );
  }
}
