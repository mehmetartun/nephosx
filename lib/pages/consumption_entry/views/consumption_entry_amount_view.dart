import 'dart:convert';

import 'package:coach/extensions/capitalize.dart';
import 'package:coach/model/drink.dart';
import 'package:coach/widgets/labeled_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../model/enums.dart';
import '../../../services/responsive_utils.dart';
import '../../../widgets/calendar_date.dart';
import '../../../widgets/date_select.dart';

class ConsumptionEntryAmountView extends StatefulWidget {
  const ConsumptionEntryAmountView({
    super.key,
    required this.drink,
    required this.onAmountSelected,
    required this.onCancel,
  });

  final Drink drink;

  final void Function(Drink, DrinkSize, DateTime) onAmountSelected;
  final void Function() onCancel;

  @override
  State<ConsumptionEntryAmountView> createState() =>
      _ConsumptionEntryAmountViewState();
}

class _ConsumptionEntryAmountViewState
    extends State<ConsumptionEntryAmountView> {
  late final List<DrinkSize> sizes;
  DateTime selectedDate = DateTime.now();
  DrinkSize? selectedSize;

  late Widget imageWidget;
  void onDateChanged(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    imageWidget = Image.memory(
      base64Decode(widget.drink.imageBase64),
      width: 70,
    );
    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    sizes = DrinkSize.values
        .where((val) => val.drinkTypes.contains(widget.drink.drinkType))
        .toList();
    sizes.sort((a, b) {
      return a.volumeInML.compareTo(b.volumeInML);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Consumption Entry"),
      //   actions: [
      //     IconButton(onPressed: widget.cancel, icon: const Icon(Icons.close)),
      //   ],
      // ),
      floatingActionButton: selectedSize == null
          ? null
          : FloatingActionButton.extended(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                widget.onAmountSelected(
                  widget.drink,
                  selectedSize!,
                  selectedDate,
                );
              },
              label: Text("Continue"),
              icon: Icon(Icons.arrow_forward),
              disabledElevation: 10,
              isExtended: true,
            ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Theme.of(context).colorScheme.primary,
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color (for Android)
              // Use Colors.transparent for a "full-bleed" effect
              statusBarColor: Colors.transparent,

              // Status bar icon brightness (light or dark)
              // Use .light for dark backgrounds, .dark for light backgrounds
              statusBarIconBrightness: Brightness.light,

              // Navigation bar color (for Android)
              systemNavigationBarColor: Colors.transparent,

              // Navigation bar icon brightness (light or dark)
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            actions: [
              IconButton.filledTonal(
                icon: Icon(Icons.close),
                onPressed: widget.onCancel,
              ),
            ],
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Drink Diary",
                style: Theme.of(
                  context,
                ).textTheme?.headlineSmall?.copyWith(color: Colors.white),
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
                  'assets/images/DrinkingImage.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: DateSelect(onChanged: onDateChanged),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Container(
          //     padding: EdgeInsets.all(20),
          //     child: Column(
          //       children: [
          //         Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             CalendarDate(date: selectedDate),
          //             SizedBox(width: 10),
          //             Expanded(
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Row(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       imageWidget,
          //                       SizedBox(width: 10),
          //                       Expanded(
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           children: [
          //                             Text(
          //                               widget.drink.name,
          //                               style: Theme.of(
          //                                 context,
          //                               ).textTheme.headlineSmall,
          //                             ),
          //                             Container(
          //                               padding: EdgeInsets.fromLTRB(
          //                                 10,
          //                                 4,
          //                                 10,
          //                                 4,
          //                               ),
          //                               decoration: ShapeDecoration(
          //                                 color: selectedSize == null
          //                                     ? Theme.of(
          //                                         context,
          //                                       ).colorScheme.errorContainer
          //                                     : Theme.of(
          //                                         context,
          //                                       ).colorScheme.surfaceDim,
          //                                 shape: RoundedRectangleBorder(
          //                                   borderRadius: BorderRadius.circular(
          //                                     2,
          //                                   ),
          //                                 ),
          //                               ),
          //                               child: selectedSize == null
          //                                   ? Text(
          //                                       "Select Size",
          //                                       style: Theme.of(context)
          //                                           .textTheme
          //                                           .titleMedium
          //                                           ?.copyWith(
          //                                             color: Theme.of(context)
          //                                                 .colorScheme
          //                                                 .onErrorContainer,
          //                                           ),
          //                                     )
          //                                   : Text(
          //                                       NumberFormat("0 mL").format(
          //                                         selectedSize!.volumeInML,
          //                                       ),
          //                                       style: Theme.of(
          //                                         context,
          //                                       ).textTheme.titleMedium,
          //                                     ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //         Container(
          //           width: double.infinity,
          //           padding: EdgeInsets.only(top: 10),
          //           child: FilledButton(
          //             child: Text("Enter into Diary"),
          //             onPressed: selectedSize != null
          //                 ? () {
          //                     widget.onAmountSelected(
          //                       widget.drink,
          //                       selectedSize!,
          //                       selectedDate,
          //                     );
          //                   }
          //                 : null,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 10),
                // DateSelect(onChanged: onDateChanged),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  // Use the crossAxisCount to configure the grid delegate
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ScreenUtils.getGridCount(context),
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio:
                        1.0, // This is the key to making them square
                  ),
                  itemCount: sizes.length,
                  itemBuilder: (context, index) {
                    // Your button widget goes here
                    return GestureDetector(
                      onTap: () {
                        // widget.onAmountSelected(widget.drink, sizes[index]);
                        setState(() {
                          selectedSize = sizes[index];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: ShapeDecoration(
                          color: selectedSize == sizes[index]
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primaryContainer,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: FittedBox(
                                child: Text(
                                  sizes[index].description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: selectedSize == sizes[index]
                                            ? Theme.of(
                                                context,
                                              ).colorScheme.onPrimary
                                            : Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    NumberFormat('0 mL').format(
                                      widget.drink.drinkType ==
                                              DrinkType.cocktail
                                          ? 100
                                          : sizes[index].volumeInML,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: selectedSize == sizes[index]
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                        ),
                                  ),
                                  Text(
                                    NumberFormat('0.0 oz').format(
                                      (widget.drink.drinkType ==
                                                  DrinkType.cocktail
                                              ? 100.0
                                              : sizes[index].volumeInML)
                                          .mLtoOz(),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: selectedSize == sizes[index]
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       GridView.builder(
      //         shrinkWrap: true,
      //         physics: NeverScrollableScrollPhysics(),
      //         padding: const EdgeInsets.all(16.0),
      //         // Use the crossAxisCount to configure the grid delegate
      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 3,
      //           crossAxisSpacing: 16.0, // Spacing between columns
      //           mainAxisSpacing: 16.0, // Spacing between rows
      //           childAspectRatio: 1.0, // This is the key to making them square
      //         ),
      //         itemCount: sizes.length,
      //         itemBuilder: (context, index) {
      //           // Your button widget goes here
      //           return GestureDetector(
      //             onTap: () {
      //               widget.onAmountSelected(widget.drink, sizes[index]);
      //             },
      //             child: Container(
      //               padding: EdgeInsets.all(10),
      //               decoration: ShapeDecoration(
      //                 color: Theme.of(context).colorScheme.primaryContainer,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(10),
      //                 ),
      //               ),
      //               child: Stack(
      //                 children: [
      //                   Align(
      //                     alignment: Alignment.topLeft,
      //                     child: FittedBox(
      //                       child: Text(
      //                         sizes[index].description,
      //                         style: Theme.of(context).textTheme.headlineSmall
      //                             ?.copyWith(
      //                               color: Theme.of(
      //                                 context,
      //                               ).colorScheme.onPrimaryContainer,
      //                             ),
      //                       ),
      //                     ),
      //                   ),
      //                   Align(
      //                     alignment: Alignment.bottomRight,
      //                     child: Column(
      //                       mainAxisSize: MainAxisSize.min,
      //                       children: [
      //                         Text(
      //                           NumberFormat(
      //                             '0 mL',
      //                           ).format(sizes[index].volumeInML),
      //                           style: Theme.of(context).textTheme.titleMedium
      //                               ?.copyWith(
      //                                 color: Theme.of(
      //                                   context,
      //                                 ).colorScheme.onPrimaryContainer,
      //                               ),
      //                         ),
      //                         Text(
      //                           NumberFormat(
      //                             '0.0 oz',
      //                           ).format(sizes[index].volumeInML.mLtoOz()),
      //                           style: Theme.of(context).textTheme.titleMedium
      //                               ?.copyWith(
      //                                 color: Theme.of(
      //                                   context,
      //                                 ).colorScheme.onPrimaryContainer,
      //                               ),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
