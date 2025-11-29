import 'dart:convert';

import 'package:nephosx/widgets/drinking_note_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../model/consumption.dart';
import '../model/drinking_note.dart';
import 'calendar_date.dart';
import 'drink_card.dart';

class DayBlock extends StatelessWidget {
  const DayBlock({
    super.key,
    required this.consumptions,
    required this.date,

    required this.onTap,
    this.drinkingNote,
  });
  final List<Consumption> consumptions;
  final DateTime date;
  final DrinkingNote? drinkingNote;

  final void Function(DateTime) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CalendarDate(date: date, onTap: onTap),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    Row(
                      // textBaseline: TextBaseline.alphabetic,
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.scale,
                            size: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                          ),
                        ),

                        RichText(
                          text: TextSpan(
                            text: NumberFormat(
                              '0',
                            ).format(Consumption.totalCalories(consumptions)),

                            style: Theme.of(context).textTheme.headlineSmall,
                            children: [
                              TextSpan(
                                text: ' kCal',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // textBaseline: TextBaseline.ideographic,
                      // crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.local_bar,
                            size: Theme.of(
                              context,
                            ).textTheme.titleMedium?.fontSize,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            text: NumberFormat(
                              '0.0',
                            ).format(Consumption.totalUnits(consumptions)),

                            style: Theme.of(context).textTheme.headlineSmall,
                            children: [
                              TextSpan(
                                text: ' units',

                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   NumberFormat('0.0 units').format(units),
                    //   style: Theme.of(context).textTheme.headlineSmall,
                    // ),
                  ],
                ),
              ),
            ],
          ),
          if (drinkingNote != null) ...[
            DrinkingNoteView(drinkingNote: drinkingNote!),
          ],
          if (drinkingNote == null) SizedBox(height: 10),
          ...consumptions.map((cons) {
            return ListTile(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => MaxWidthBox(
                    maxWidth: 500,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: DrinkCard(drink: cons.drink!),
                      ),
                    ),
                  ),
                );
              },
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.memory(base64Decode(cons.drink!.imageBase64)),
              ),
              title: Text(cons.drink!.name),
              subtitle: Text(cons.drinkSize.description),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(NumberFormat('0 kCal').format(cons.calories)),
                  Text(NumberFormat('0.0 units').format(cons.units)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
